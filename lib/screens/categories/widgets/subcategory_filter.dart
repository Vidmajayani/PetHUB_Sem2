import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SubcategoryFilter extends StatelessWidget {
  final List<String> subcategories;
  final String? selectedSubcategory;
  final Function(String?) onSubcategorySelected;

  const SubcategoryFilter({
    super.key,
    required this.subcategories,
    required this.selectedSubcategory,
    required this.onSubcategorySelected,
  });

  // Get icon for each subcategory
  IconData _getIconForSubcategory(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'toys':
        return Icons.toys_rounded;
      case 'accessories':
        return Icons.shopping_bag_rounded;
      case 'treats':
        return Icons.cookie_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Combine "All" with the rest of the subcategories
    final List<String?> items = [null, ...subcategories];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimationLimiter(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(items.length, (index) {
                final String? subcategory = items[index];
                final bool isSelected = subcategory == selectedSubcategory;
                final String label = subcategory ?? 'All';
                final IconData icon = subcategory == null 
                    ? Icons.grid_view_rounded 
                    : _getIconForSubcategory(subcategory);

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 20.0,
                    child: FadeInAnimation(
                      child: _AnimatedFilterChip(
                        label: label,
                        icon: icon,
                        isSelected: isSelected,
                        onTap: () => onSubcategorySelected(subcategory),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedFilterChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedFilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<_AnimatedFilterChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: widget.isSelected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected 
                  ? colorScheme.primary 
                  : colorScheme.outlineVariant.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: widget.isSelected ? [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: widget.isSelected ? colorScheme.onPrimary : colorScheme.primary,
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  color: widget.isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 15,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
