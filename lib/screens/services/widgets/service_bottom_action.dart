import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/models/pet_service_model.dart';
import 'package:pet_supplies_app_v2/providers/booking_provider.dart';
import 'package:pet_supplies_app_v2/providers/products_provider.dart';
import 'package:pet_supplies_app_v2/widgets/offline_dialog.dart';
import '../booking_bottom_sheet.dart';

class ServiceBottomAction extends StatelessWidget {
  final PetServiceModel service;

  const ServiceBottomAction({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () {
            final isOffline = Provider.of<ProductsProvider>(context, listen: false).isOffline;
            if (isOffline) {
              OfflineDialog.show(context, "book professional sessions");
              return;
            }
            _showBookingDialog(context);
          },
          child: const Text("Book Consultation Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: bookingProvider,
        child: BookingBottomSheet(service: service),
      ),
    );
  }
}
