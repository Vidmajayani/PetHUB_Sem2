import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pet_supplies_app_v2/models/review_model.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';
import 'package:pet_supplies_app_v2/providers/products_provider.dart';
import '../../product_details/product_details_screen.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final Product? product = productsProvider.getProductById(review.productId);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (product != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Header (Light Purple Background)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Product Image
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: product != null 
                        ? _buildImage(product.image, 45, 45, context)
                        : const Icon(Icons.image),
                  ),
                  const SizedBox(width: 12),
                  
                  // Product Name & Rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? "Product ID: ${review.productId}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < review.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 14,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(review.date),
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: colorScheme.primary),
                ],
              ),
            ),

            // Review Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.comment,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  // If review has image (can be base64 or url)
                  if (review.reviewImage != null && review.reviewImage!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          width: double.infinity,
                          child: _buildImageWidget(review.reviewImage!, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageStr, double? height, double? width, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      width: width,
      height: height,
      child: _buildImageWidget(imageStr, fit: BoxFit.cover),
    );
  }

  Widget _buildImageWidget(String source, {BoxFit fit = BoxFit.cover}) {
    if (source.startsWith('data:image')) {
      // Base64 Image
      try {
        final base64Content = source.split(',')[1];
        return Image.memory(
          base64Decode(base64Content),
          fit: fit,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } catch (e) {
        return const Icon(Icons.broken_image);
      }
    } else if (source.startsWith('http')) {
      // Network URL
      return Image.network(
        source,
        fit: fit,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else {
      // Asset
      return Image.asset(
        source,
        fit: fit,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }
  }
}
