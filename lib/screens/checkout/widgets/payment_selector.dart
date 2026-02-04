import 'package:flutter/material.dart';

class PaymentSelector extends StatelessWidget {
  final String selectedPayment;
  final ValueChanged<String?> onChanged;

  const PaymentSelector({
    super.key,
    required this.selectedPayment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedPayment,
          items: const [
            DropdownMenuItem(
                value: 'Cash on Delivery', child: Text('Cash on Delivery')),
            DropdownMenuItem(
                value: 'Credit/Debit Card', child: Text('Credit/Debit Card')),
            DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
          ],
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.payment),
          ),
        ),
      ],
    );
  }
}
