import 'package:flutter/material.dart';

class CheckoutEmptyView extends StatelessWidget {
  const CheckoutEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: colorScheme.outline),
          const SizedBox(height: 16),
          const Text('Your cart is empty'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
