import 'package:flutter/material.dart';
import '../../../models/cart_model.dart';

class OrderSummary extends StatelessWidget {
  final CartModel cart;
  const OrderSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...cart.items.map(
          (it) => ListTile(
            title: Text(it.product.name),
            subtitle: Text('Quantity: ${it.quantity}'),
            trailing: Text('Rs. ${it.total.toStringAsFixed(2)}'),
          ),
        ),
      ],
    );
  }
}
