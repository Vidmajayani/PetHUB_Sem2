import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../products/product_card.dart';
import '../product_details/product_details_screen.dart';
import 'widgets/subcategory_filter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/animations/shimmer_loading.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String? selectedSubcategory;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final allProducts = productsProvider.products;
    final isLoading = productsProvider.isLoading;

    // Filter products by category
    final categoryProducts = allProducts
        .where((p) => p.category == widget.categoryName)
        .toList();

    // Filter by subcategory if selected
    final filteredProducts = selectedSubcategory == null
        ? categoryProducts
        : categoryProducts
            .where((p) => p.subcategory == selectedSubcategory)
            .toList();

    // Get unique subcategories for this category
    final subcategories = categoryProducts
        .map((p) => p.subcategory)
        .toSet()
        .toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subcategory Filter
          if (subcategories.isNotEmpty)
            SubcategoryFilter(
              subcategories: subcategories,
              selectedSubcategory: selectedSubcategory,
              onSubcategorySelected: (subcategory) {
                setState(() {
                  selectedSubcategory = subcategory;
                });
              },
            ),

          // Products Grid
          Expanded(
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ShimmerGrid(),
                  )
                : filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              selectedSubcategory != null
                                  ? 'Try selecting a different filter'
                                  : 'Check back later for new products',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : AnimationLimiter(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: ProductCard(
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
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
