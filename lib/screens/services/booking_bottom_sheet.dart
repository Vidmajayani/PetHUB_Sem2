import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pet_service_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/payment_service.dart';
import 'package:intl/intl.dart';
import '../../widgets/common/error_notification_box.dart';

class BookingBottomSheet extends StatefulWidget {
  final PetServiceModel service;

  const BookingBottomSheet({super.key, required this.service});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _errorMessage; // Add error state
  final List<String> _timeSlots = ['09:00 AM', '11:00 AM', '02:00 PM', '04:00 PM'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            "Schedule Appointment",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          // Error Message Component
          ErrorNotificationBox(
            errorMessage: _errorMessage,
            onClose: () => setState(() => _errorMessage = null),
          ),

          Text(
            "Book your session with our ${widget.service.title} expert.",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Date Selection
          const Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              // Clear error when user interacts
              setState(() => _errorMessage = null);
              
              final now = DateTime.now();
              // Calculate exactly midnight of tomorrow
              final tomorrow = DateTime(now.year, now.month, now.day + 1);
              
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: tomorrow,
                firstDate: tomorrow,
                lastDate: now.add(const Duration(days: 60)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        onSurface: Colors.black, // Ensure dates are clearly visible
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                setState(() => _selectedDate = pickedDate);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? "Choose a date (Tomorrow onwards)"
                        : DateFormat('EEEE, MMM d, y').format(_selectedDate!),
                    style: TextStyle(
                      color: _selectedDate == null ? Colors.grey : Colors.black,
                    ),
                  ),
                  Icon(Icons.calendar_month, color: colorScheme.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Time Slots
          const Text("Select Time Slot", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: _timeSlots.map((slot) {
              final isSelected = _selectedTime == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    _selectedTime = slot;
                    _errorMessage = null; // Clear error
                  });
                },
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: (_selectedDate == null || _selectedTime == null || bookingProvider.isLoading)
                  ? null
                  : () async {
                      // Clear previous error
                      setState(() => _errorMessage = null);

                      // --- FINAL DATE VALIDATION ---
                      final now = DateTime.now();
                      final todayMidnight = DateTime(now.year, now.month, now.day);
                      if (_selectedDate!.isBefore(todayMidnight.add(const Duration(days: 1)))) {
                        setState(() => _errorMessage = "Please select a date from tomorrow onwards. 🐾");
                        return;
                      }

                      // --- STRIPE PAYMENT ---
                      final paymentService = RipplePaymentService();
                      final amountInCents = (widget.service.price * 100).toInt().toString();

                      final paymentError = await paymentService.makePayment(
                        amount: amountInCents,
                        currency: 'LKR',
                        context: context,
                      );

                      if (paymentError != null) {
                        setState(() => _errorMessage = 'Payment Failed: $paymentError 🐾');
                        return;
                      }
                      // -----------------------

                      final success = await bookingProvider.createBooking(
                        userId: authProvider.user?.uid ?? 'guest',
                        serviceId: widget.service.id,
                        serviceTitle: widget.service.title,
                        serviceImage: widget.service.image,
                        date: _selectedDate!,
                        timeSlot: _selectedTime!,
                        price: widget.service.price,
                        notificationProvider: notificationProvider,
                      );

                      if (success) {
                        if (mounted) Navigator.pop(context);
                        _showSuccessDialog(context);
                      }
                    },
              child: bookingProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Confirm & Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            const Text(
              "Booking Confirmed!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your digital appointment has been locked in. Check your notifications for details.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
