import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/cart_model.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/notification_provider.dart';
import 'widgets/order_summary.dart';
import 'widgets/shipping_form.dart';
import 'widgets/notes_field.dart';
import 'widgets/checkout_empty_view.dart';
import 'widgets/checkout_stepper.dart';
import 'widgets/checkout_bottom_bar.dart';
import 'widgets/order_success_dialog.dart';
import '../../services/payment_service.dart';
import '../../widgets/common/error_notification_box.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
  final _country = TextEditingController();
  final _notes = TextEditingController();

  bool _isProcessing = false;
  String? _errorMessage; // Add error state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.userProfile != null) {
        setState(() {
          _name.text = auth.userProfile!.displayName;
          _email.text = auth.userProfile!.email;
          _phone.text = auth.userProfile!.phoneNumber;
          _street.text = auth.userProfile!.address;
        });
      }
    });
  }

  Future<void> _handlePlaceOrder() async {
    // Clear previous error
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      setState(() => _errorMessage = 'Please fill in all required shipping details! 🐾');
      return;
    }

    final cart = Provider.of<CartModel>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (auth.user == null) {
      setState(() => _errorMessage = 'Please login to place an order');
      return;
    }

    setState(() => _isProcessing = true);

    final orderItems = cart.items.map((item) {
      return OrderItem(
        productId: item.product.id,
        productName: item.product.name,
        quantity: item.quantity,
        price: item.product.price,
        image: item.product.image,
      );
    }).toList();

    final order = OrderModel(
      id: const Uuid().v4(),
      userId: auth.user!.uid,
      items: orderItems,
      totalAmount: cart.totalPrice,
      date: DateTime.now(),
    );

    // --- INTEGRATED STRIPE PAYMENT GATEWAY ---
    final paymentService = RipplePaymentService();
    
    // Amount must be in cents (e.g., Rs. 9000 -> 900000)
    final amountInCents = (cart.totalPrice * 100).toInt().toString();

    final paymentError = await paymentService.makePayment(
      amount: amountInCents,
      currency: 'LKR',
      context: context,
    );

    if (paymentError != null) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Payment Incomplete: $paymentError 🐾';
      });
      return;
    }
    // ------------------------------------------

    final error = await orderProvider.placeOrder(order);

    setState(() => _isProcessing = false);

    if (mounted) {
      if (error != null) {
        setState(() => _errorMessage = 'Error placing order: $error');
      } else {
        // Trigger Order Success Notification
        Provider.of<NotificationProvider>(context, listen: false).addNotification(
          title: 'Order Placed! 🐾✨',
          message: 'Your order has been successfully placed. Thank you for shopping with us! 🐾 You can review your ordered items anytime in your Profile > Orders section.',
        );
        
        cart.clear();
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const OrderSuccessDialog(),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (cart.items.isEmpty && !_isProcessing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const CheckoutEmptyView(),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // PREMIUM THEMED STEPPER
            const CheckoutStepper(),

            // Error Message Component
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ErrorNotificationBox(
                  errorMessage: _errorMessage,
                  onClose: () => setState(() => _errorMessage = null),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Shipping Section
                  _buildSectionHeader(context, "Shipping Address", Icons.location_on_outlined),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ShippingForm(
                        name: _name,
                        email: _email,
                        phone: _phone,
                        street: _street,
                        city: _city,
                        state: _state,
                        zip: _zip,
                        country: _country,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order Summary Section
                  _buildSectionHeader(context, "Order Review", Icons.receipt_long_outlined),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: OrderSummary(cart: cart),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Notes Section
                  _buildSectionHeader(context, "Additional Notes", Icons.note_add_outlined),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: NotesField(notes: _notes),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CheckoutBottomBar(
        totalPrice: cart.totalPrice,
        isProcessing: _isProcessing,
        onPlaceOrder: _handlePlaceOrder,
      ),
    );
  }
}

