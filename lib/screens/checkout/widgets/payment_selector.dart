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
      children: [
        _buildPaymentOption(
          context,
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive your pet treats',
          icon: Icons.payments_outlined,
          value: 'Cash on Delivery',
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildPaymentOption(
          context,
          title: 'Credit/Debit Card',
          subtitle: 'Secure payment via Stripe gateway',
          icon: Icons.credit_card_outlined,
          value: 'Credit/Debit Card',
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildPaymentOption(
          context,
          title: 'PayPal',
          subtitle: 'Fast and secure checkout with PayPal',
          icon: Icons.account_balance_wallet_outlined,
          value: 'PayPal',
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedPayment == value;
    final colorScheme = Theme.of(context).colorScheme;

    return RadioListTile<String>(
      value: value,
      groupValue: selectedPayment,
      onChanged: onChanged,
      activeColor: colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isSelected ? colorScheme.primary : Colors.grey.shade600, size: 22),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

