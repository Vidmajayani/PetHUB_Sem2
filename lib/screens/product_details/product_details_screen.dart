import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/cart_model.dart';
import 'package:intl/intl.dart';
import '../../models/product_model.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/review_provider.dart';
import '../../models/review_model.dart';

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
  int quantity = 1;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Expandable sections state
  final Map<String, bool> _expandedSections = {
    'description': true,
    'ingredients': false,
    'healthBenefits': false,
    'targetAudience': false,
    'specialFeatures': false,
    'usageInstructions': false,
  };

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

  void _shareProduct() {
    final String text = 'Check out this ${widget.product.name} for Rs. ${widget.product.price.toStringAsFixed(2)} on Pet Supplies App!\n\nView more: https://petsupplies.app/product/${widget.product.id}';
    Share.share(text, subject: 'Share Product');
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar with Product Image
          SliverAppBar(
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
                    tag: 'product_image_${widget.product.id}',
                    child: widget.product.image.startsWith('http')
                        ? Image.network(
                            widget.product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(Icons.image_not_supported, size: 64, color: colorScheme.outline),
                            ),
                          )
                        : Image.asset(
                            widget.product.image,
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
                    final isFavorite = wishlist.isFavorite(widget.product.id);
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
                          wishlist.toggleFavorite(widget.product);
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
                    onPressed: _shareProduct,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),

          // Product Details Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Product Header Card
                  _buildHeaderCard(context, colorScheme, textTheme),
                  
                  const SizedBox(height: 16),
                  
                  // Information Sections
                  _buildExpandableSection(
                    context,
                    'description',
                    'Description',
                    widget.product.description,
                    Icons.description_outlined,
                  ),
                  
                  if (widget.product.ingredients != null)
                    _buildExpandableSection(
                      context,
                      'ingredients',
                      'Ingredients',
                      widget.product.ingredients!,
                      Icons.restaurant_menu,
                    ),
                  
                  if (widget.product.healthBenefits != null)
                    _buildExpandableSection(
                      context,
                      'healthBenefits',
                      'Health Benefits',
                      widget.product.healthBenefits!,
                      Icons.favorite_outline,
                    ),
                  
                  if (widget.product.targetAudience != null)
                    _buildExpandableSection(
                      context,
                      'targetAudience',
                      'Target Audience',
                      widget.product.targetAudience!,
                      Icons.pets,
                    ),
                  
                  if (widget.product.specialFeatures != null)
                    _buildExpandableSection(
                      context,
                      'specialFeatures',
                      'Special Features',
                      widget.product.specialFeatures!,
                      Icons.star_outline,
                    ),
                  
                  if (widget.product.usageInstructions != null)
                    _buildExpandableSection(
                      context,
                      'usageInstructions',
                      'Usage Instructions',
                      widget.product.usageInstructions!,
                      Icons.info_outline,
                  ),
                  
                  _buildReviewsSection(context, colorScheme, textTheme),
                  
                  const SizedBox(height: 120), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Enhanced Bottom Bar
      bottomNavigationBar: _buildBottomBar(context, colorScheme, textTheme),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
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
                widget.product.category,
                _getCategoryIcon(widget.product.category),
                colorScheme.primary,
              ),
              const SizedBox(width: 12),
              _buildBadge(
                widget.product.subcategory,
                _getSubcategoryIcon(widget.product.subcategory),
                const Color(0xFFFF6F00), // Darker Yellow (Amber 900)
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Product Name
          Text(
            widget.product.name,
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
                      widget.product.rating.toStringAsFixed(1),
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
                'Rs. ${widget.product.price.toStringAsFixed(2)}',
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

  Widget _buildExpandableSection(
    BuildContext context,
    String key,
    String title,
    String content,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isExpanded = _expandedSections[key] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Section Header (Clickable)
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[key] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
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
                  Provider.of<CartModel>(context, listen: false)
                      .addProduct(widget.product, quantity);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: colorScheme.onPrimary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Added to Cart!',
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$quantity x ${widget.product.name}',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onPrimary.withOpacity(0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(16),
                      elevation: 8,
                      action: SnackBarAction(
                        label: 'VIEW CART',
                        textColor: colorScheme.onPrimary,
                        backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                    ),
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

  Widget _buildReviewsSection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        if (reviewProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = reviewProvider.currentProductReviews;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Customer Reviews",
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${reviews.length} Reviews",
                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (reviews.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.rate_review_outlined, size: 48, color: colorScheme.outline),
                      const SizedBox(height: 8),
                      const Text("No reviews yet. Be the first to review!"),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return _buildReviewItem(review, colorScheme, textTheme);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewItem(ReviewModel review, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: review.userImage.isNotEmpty ? NetworkImage(review.userImage) : null,
                child: review.userImage.isEmpty ? Icon(Icons.person, size: 20, color: colorScheme.onPrimaryContainer) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(review.date),
                      style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
