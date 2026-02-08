import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String categoryName;
  final IconData icon;
  final String emoji;
  final int productCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.emoji,
    required this.productCount,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Press animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // Continuous bounce animation
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounceAnimation = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      colorScheme.surfaceContainerHighest,
                      colorScheme.surfaceContainer,
                    ]
                  : [
                      colorScheme.primaryContainer.withOpacity(0.4),
                      colorScheme.secondaryContainer.withOpacity(0.3),
                    ],
            ),
            border: Border.all(
              color: _isPressed
                  ? colorScheme.primary.withOpacity(0.5)
                  : colorScheme.outline.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? colorScheme.primary.withOpacity(0.3)
                    : colorScheme.primary.withOpacity(0.15),
                blurRadius: _isPressed ? 20 : 16,
                offset: Offset(0, _isPressed ? 6 : 8),
                spreadRadius: _isPressed ? 2 : 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Emoji with animated background and bounce
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: child,
                    );
                  },
                  child: Hero(
                    tag: 'category-${widget.categoryName}',
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark 
                            ? [
                                colorScheme.primary.withOpacity(0.15),
                                colorScheme.surfaceContainerHighest.withOpacity(0.8),
                              ]
                            : [
                                colorScheme.primary.withOpacity(0.3),
                                colorScheme.primaryContainer.withOpacity(0.6),
                              ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark 
                              ? Colors.black.withOpacity(0.3)
                              : colorScheme.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                
                // Category Name - CENTERED
                Text(
                  widget.categoryName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.5,
                        fontSize: 17,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
