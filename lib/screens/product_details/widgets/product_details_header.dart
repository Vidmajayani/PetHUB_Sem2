import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';


class ProductDetailsHeader extends StatelessWidget {
  final Product product;

  const ProductDetailsHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Subcategory Badges
          Row(
            children: [
              _buildBadge(
                product.category,
                _getCategoryIcon(product.category),
                colorScheme.primary,
              ),
              const SizedBox(width: 12),
              _buildBadge(
                product.subcategory,
                _getSubcategoryIcon(product.subcategory),
                const Color(0xFFFF6F00), // Darker Yellow (Amber 900)
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Product Name
          Text(
            product.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Rating Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '(4.2k reviews)',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${product.price.toStringAsFixed(2)}',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              // Stock Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'In Stock',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color baseColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withOpacity(0.12),
            baseColor.withOpacity(0.22),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: baseColor.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: baseColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: baseColor,
              fontWeight: FontWeight.w800,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'dogs': return Icons.pets;
      case 'cats': return Icons.pets;
      case 'birds': return Icons.flutter_dash_rounded;
      case 'fish': return Icons.water_rounded;
      case 'reptiles': return Icons.bug_report_rounded;
      case 'hamsters':
      case 'rabbits': return Icons.cruelty_free_rounded;
      case 'turtles': return Icons.waves_rounded;
      case 'exotic pets': return Icons.star_rounded;
      default: return Icons.category_rounded;
    }
  }

  IconData _getSubcategoryIcon(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'food': return Icons.restaurant_rounded;
      case 'toys': return Icons.toys_rounded;
      case 'accessories': return Icons.shopping_bag_rounded;
      case 'treats': return Icons.cookie_rounded;
      default: return Icons.category_rounded;
    }
  }
}
