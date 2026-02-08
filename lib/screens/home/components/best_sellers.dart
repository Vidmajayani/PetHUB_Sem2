import 'package:flutter/material.dart';
import '../../../models/product_model.dart';
import '../../categories/categories_screen.dart';
import '../../product_details/product_details_screen.dart';
import '../../products/product_card.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BestSellers extends StatelessWidget {
  final List<Product> products;

  const BestSellers({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // Show only first 6 products as best sellers
    final bestSellers = products.take(6).toList();
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid
    int crossAxisCount = 2;
    if (screenWidth > 900) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Best Sellers 🔥", 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              )
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                );
              },
              child: const Text("See All"),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 260, // Total height for the horizontal carousel
          child: AnimationLimiter(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: bestSellers.length,
              itemBuilder: (context, index) {
                final product = bestSellers[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        width: 180, // Consistent width for horizontal cards
                        margin: const EdgeInsets.only(right: 16),
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
