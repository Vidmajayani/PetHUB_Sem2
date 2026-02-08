import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';
import 'package:pet_supplies_app_v2/providers/review_provider.dart';
import 'review_card.dart'; // Ensure this import is correct

class ProductReviewsSection extends StatelessWidget {
  final Product product;

  const ProductReviewsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Always show Header so the user knows where they are
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Customer Reviews",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Consumer<ReviewProvider>(
                builder: (context, reviewProvider, child) {
                  // Merge Model reviews (built-in) with Provider reviews (live)
                  final allReviews = [
                    ...product.reviews,
                    ...reviewProvider.currentProductReviews.where(
                      (pr) => !product.reviews.any((mr) => mr.id == pr.id)
                    ),
                  ];
                  
                  final count = allReviews.length;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$count Reviews",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Consumer<ReviewProvider>(
            builder: (context, reviewProvider, child) {
              // Merge Model reviews (built-in) with Provider reviews (live)
              final reviews = [
                ...product.reviews,
                ...reviewProvider.currentProductReviews.where(
                  (pr) => !product.reviews.any((mr) => mr.id == pr.id)
                ),
              ];

              if (reviewProvider.isLoading && reviews.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary.withOpacity(0.5)),
                    ),
                  ),
                );
              }

              if (reviews.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.rate_review_outlined, size: 48, color: colorScheme.outline.withOpacity(0.5)),
                      const SizedBox(height: 12),
                      Text(
                        "No reviews yet",
                        style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Be the first to share your experience!",
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                   return ReviewCard(review: review);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
