import 'package:flutter/material.dart';
import '../../../models/cart_model.dart';

class OrderSummary extends StatelessWidget {
  final CartModel cart;
  const OrderSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...cart.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: colorScheme.surfaceContainerHighest,
                    child: item.product.image.isEmpty
                        ? const Icon(Icons.inventory_2_outlined)
                        : item.product.image.startsWith('http')
                            ? Image.network(
                                item.product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 20, color: Colors.grey),
                              )
                            : Image.asset(
                                item.product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, size: 20, color: Colors.grey),
                              ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('Qty: ${item.quantity}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Text('Rs. ${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          )),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                "Rs. ${cart.totalPrice.toStringAsFixed(2)}", 
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
        Text("Rs. ${amount.toStringAsFixed(2)}", style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
