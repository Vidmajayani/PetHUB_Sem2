import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  final String imageUrl;

  const ProductImageWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Check if image is a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.pets, size: 48, color: Colors.grey),
          );
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.contain, // Changed from cover to contain to prevent cropping asset images
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.pets, size: 48, color: Colors.grey),
          );
        },
      );
    }
  }
}
