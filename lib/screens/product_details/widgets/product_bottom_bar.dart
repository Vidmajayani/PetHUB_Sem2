import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';
import 'package:pet_supplies_app_v2/providers/products_provider.dart';
import 'package:pet_supplies_app_v2/models/cart_model.dart';
import 'package:pet_supplies_app_v2/providers/notification_provider.dart';
import 'package:pet_supplies_app_v2/widgets/offline_dialog.dart';

class ProductBottomBar extends StatefulWidget {
  final Product product;

  const ProductBottomBar({super.key, required this.product});

  @override
  State<ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends State<ProductBottomBar> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final totalPrice = widget.product.price * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity & Total Row
            Row(
              children: [
                // Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                        color: colorScheme.primary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$quantity',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Total Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Rs. ${totalPrice.toStringAsFixed(2)}',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                  
                  if (productsProvider.isOffline) {
                    print('⚠️ BLOCKED: User tried to Add to Cart while OFFLINE');
                    OfflineDialog.show(context, "add items to cart");
                    return;
                  }
                  
                  Provider.of<CartModel>(context, listen: false)
                      .addProduct(widget.product, quantity);
                  
                  // Trigger Temporary In-App Banner ONLY (No history, No system alert)
                  final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
                  notificationProvider.showTemporaryBanner(
                    title: 'Added to Cart! 🛒',
                    message: '$quantity x ${widget.product.name} is now in your bag.',
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),

                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
