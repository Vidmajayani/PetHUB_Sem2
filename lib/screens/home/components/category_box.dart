import 'package:flutter/material.dart';
import '../../../utils/ui_constants.dart';

class CategoryBox extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const CategoryBox({
    super.key,
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UIConstants.cardCornerRadius),
      child: Container(
        width: UIConstants.categoryBoxWidth,
        height: UIConstants.categoryBoxHeight,
        padding: const EdgeInsets.all(UIConstants.spacing / 2),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(UIConstants.cardCornerRadius),
          border: Border.all(color: cs.primary),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bigger image
            Flexible(
              child: Image.asset(
                image,
                width: UIConstants.categoryBoxWidth * 0.8, // 80% of box width
                height:
                    UIConstants.categoryBoxHeight * 0.6, // 60% of box height
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
