import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/product_model.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/offline_dialog.dart';

class ProductAppBar extends StatelessWidget {
  final Product product;

  const ProductAppBar({
    super.key,
    required this.product,
  });

  void _shareProduct() {
    final String text = 'Check out this ${product.name} for Rs. ${product.price.toStringAsFixed(2)} on Pet Supplies App!\n\nView more: https://petsupplies.app/product/${product.id}';
    Share.share(text, subject: 'Share Product');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Product Image with Hero Animation
            Hero(
              tag: 'product_image_${product.id}',
              child: product.image.startsWith('http')
                  ? Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image_not_supported, size: 64, color: colorScheme.outline),
                      ),
                    )
                  : Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image_not_supported, size: 64, color: colorScheme.outline),
                      ),
                    ),
            ),
            
            // Gradient Overlay for better readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colorScheme.surface.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Favorite Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              final isFavorite = wishlist.isFavorite(product.id);
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : colorScheme.onSurface,
                    size: 20,
                  ),
                  onPressed: () {
                    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                    if (productsProvider.isOffline) {
                      print('⚠️ BLOCKED: User tried to favorite item while OFFLINE');
                      OfflineDialog.show(context, "favorite items");
                      return;
                    }
                    wishlist.toggleFavorite(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite ? 'Removed from favorites' : 'Added to favorites'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                ),
              );
            },
          ),
        ),
        // Share Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.share, color: colorScheme.onSurface, size: 20),
              onPressed: () {
                final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                if (productsProvider.isOffline) {
                  print('⚠️ BLOCKED: User tried to SHARE item while OFFLINE');
                  OfflineDialog.show(context, "share products");
                  return;
                }
                _shareProduct();
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
