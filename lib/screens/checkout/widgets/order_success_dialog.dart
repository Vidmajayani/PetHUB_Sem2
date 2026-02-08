import 'package:flutter/material.dart';

class OrderSuccessDialog extends StatelessWidget {
  const OrderSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      icon: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 64),
      ),
      title: const Text('Order Successful!', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text(
        'Your order has been successfully placed. Check your orders for live status updates.',
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('AWESOME!'),
          ),
        ),
      ],
    );
  }
}
