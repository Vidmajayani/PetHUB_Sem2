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
import 'widgets/payment_selector.dart';
import 'widgets/notes_field.dart';

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

  String _selectedPayment = 'Cash on Delivery';
  bool _isProcessing = false;

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
    if (!_formKey.currentState!.validate()) return;

    final cart = Provider.of<CartModel>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please login to place an order')),
      );
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

    final error = await orderProvider.placeOrder(order);

    setState(() => _isProcessing = false);

    if (mounted) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $error'), backgroundColor: Colors.red),
        );
      } else {
        // Trigger Order Success Notification
        Provider.of<NotificationProvider>(context, listen: false).addNotification(
          title: 'Order Placed! 🐾',
          message: 'Your order has been successfully placed. Thank you for shopping with us!',
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
      builder: (_) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text(
          'Your order has been successfully placed. Thank you for shopping with us!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.items.isEmpty
            ? const Center(child: Text('No items to checkout'))
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        OrderSummary(cart: cart),
                        const Divider(),

                        // Shipping Form
                        Text(
                          'Shipping Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ShippingForm(
                                name: _name,
                                email: _email,
                                phone: _phone,
                                street: _street,
                                city: _city,
                                state: _state,
                                zip: _zip,
                                country: _country,
                              ),
                              const SizedBox(height: 20),
                              PaymentSelector(
                                selectedPayment: _selectedPayment,
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => _selectedPayment = v);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              NotesField(notes: _notes),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isProcessing ? null : _handlePlaceOrder,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Place Order'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
