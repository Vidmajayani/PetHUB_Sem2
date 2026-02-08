import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../products/product_card.dart';
import '../product_details/product_details_screen.dart';
import 'widgets/no_search_results.dart';
import 'widgets/service_promo_card.dart';
import 'widgets/search_section_title.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    
    // 1. Search Products
    final allProducts = productsProvider.products;
    final filteredProducts = allProducts.where((p) {
      final searchLower = query.toLowerCase();
      return p.name.toLowerCase().contains(searchLower) ||
          p.description.toLowerCase().contains(searchLower) ||
          p.category.toLowerCase().contains(searchLower);
    }).toList();

    // 2. Search Services (Keyword Matching for Recommendations)
    final searchLower = query.toLowerCase();
    final List<String> commonServices = ['grooming', 'vet', 'doctor', 'consultation', 'advice', 'training'];
    bool queryMatchesServices = commonServices.any((s) => searchLower.contains(s));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search: "$query"', style: const TextStyle(fontSize: 18)),
            Text(
              '${filteredProducts.length} results found',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: (filteredProducts.isEmpty && !queryMatchesServices)
          ? const NoSearchResults()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (queryMatchesServices) ...[
                    const SearchSectionTitle(title: "Recommended Services 🏥", icon: Icons.bolt_rounded),
                    const SizedBox(height: 12),
                    const ServicePromoCard(),
                    const SizedBox(height: 24),
                  ],
                  if (filteredProducts.isNotEmpty) ...[
                    const SearchSectionTitle(title: "Matching Products 🛒", icon: Icons.shopping_bag_outlined),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

