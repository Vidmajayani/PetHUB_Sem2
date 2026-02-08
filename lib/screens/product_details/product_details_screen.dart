import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';
import 'package:pet_supplies_app_v2/providers/wishlist_provider.dart';
import 'package:pet_supplies_app_v2/providers/review_provider.dart';
import 'package:pet_supplies_app_v2/providers/products_provider.dart';
import 'package:pet_supplies_app_v2/widgets/offline_dialog.dart';
import 'widgets/product_details_header.dart';
import 'widgets/product_expandable_section.dart';
import 'widgets/product_bottom_bar.dart';
import 'widgets/product_reviews_section.dart';
import 'widgets/product_app_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Fetch reviews for this product
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewProvider>(context, listen: false).fetchReviews(widget.product.id);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with Product Image
          ProductAppBar(product: widget.product),

          // Product Details Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Product Header Card
                  ProductDetailsHeader(product: widget.product),
                  
                  const SizedBox(height: 16),
                  
                  // Information Sections
                  ProductExpandableSection(
                    title: 'Description',
                    content: widget.product.description,
                    icon: Icons.description_outlined,
                    initialExpanded: true,
                  ),
                  
                  if (widget.product.ingredients != null)
                    ProductExpandableSection(
                      title: 'Ingredients',
                      content: widget.product.ingredients!,
                      icon: Icons.restaurant_menu,
                    ),
                  
                  if (widget.product.healthBenefits != null)
                    ProductExpandableSection(
                      title: 'Health Benefits',
                      content: widget.product.healthBenefits!,
                      icon: Icons.favorite_outline,
                    ),
                  
                  if (widget.product.targetAudience != null)
                    ProductExpandableSection(
                      title: 'Target Audience',
                      content: widget.product.targetAudience!,
                      icon: Icons.pets,
                    ),
                  
                  if (widget.product.specialFeatures != null)
                    ProductExpandableSection(
                      title: 'Special Features',
                      content: widget.product.specialFeatures!,
                      icon: Icons.star_outline,
                    ),
                  
                  if (widget.product.usageInstructions != null)
                    ProductExpandableSection(
                      title: 'Usage Instructions',
                      content: widget.product.usageInstructions!,
                      icon: Icons.info_outline,
                    ),
                  
                  ProductReviewsSection(product: widget.product),
                  
                  const SizedBox(height: 120), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Enhanced Bottom Bar
      bottomNavigationBar: ProductBottomBar(product: widget.product),
    );
  }
}
