import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/models/cart_model.dart';
import 'package:pet_supplies_app_v2/widgets/offline_dialog.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isOffline;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isOffline,
  });

  void _showDeleteConfirmation(BuildContext context, String productId, String productName) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.remove_shopping_cart_rounded, color: colorScheme.primary, size: 32),
        title: const Text('Remove Item?'),
        content: Text('Are you sure you want to remove "$productName" from your cart?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<CartModel>(context, listen: false).remove(productId);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('REMOVE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            Hero(
              tag: 'cart_image_${item.product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 95,
                  width: 95,
                  child: item.product.image.startsWith('http')
                      ? Image.network(
                          item.product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(colorScheme),
                        )
                      : Image.asset(
                          item.product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(colorScheme),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                            height: 1.2,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded, color: colorScheme.error, size: 16),
                        ),
                        onPressed: () {
                          if (isOffline) {
                            OfflineDialog.show(context, "remove items from cart");
                            return;
                          }
                          _showDeleteConfirmation(context, item.product.id, item.product.name);
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  Text(
                    item.product.category,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Rs. ${item.product.price.toStringAsFixed(2)}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      // Quantity Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.outline.withOpacity(0.05)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildQtyBtn(
                              Icons.remove_rounded,
                              item.quantity > 1 ? () {
                                if (isOffline) {
                                  OfflineDialog.show(context, "update item quantity");
                                  return;
                                }
                                Provider.of<CartModel>(context, listen: false).updateQuantity(item.product.id, item.quantity - 1);
                              } : null,
                              colorScheme,
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 28),
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity}',
                                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _buildQtyBtn(
                              Icons.add_rounded,
                              () {
                                if (isOffline) {
                                  OfflineDialog.show(context, "update item quantity");
                                  return;
                                }
                                Provider.of<CartModel>(context, listen: false).updateQuantity(item.product.id, item.quantity + 1);
                              },
                              colorScheme,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_not_supported, color: colorScheme.outline),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback? onPressed, ColorScheme colorScheme) {
    return IconButton(
      icon: Icon(icon, size: 18),
      onPressed: onPressed,
      color: colorScheme.primary,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(8),
    );
  }
}
