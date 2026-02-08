import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/review_model.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              // User Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer.withOpacity(0.5),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
                ),
                child: ClipOval(
                  child: review.userImage.isNotEmpty
                      ? _buildImage(review.userImage, colorScheme)
                      : Icon(
                          Icons.person,
                          color: colorScheme.primary,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, y').format(review.date),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Comment
          Text(
            review.comment,
            style: textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          
          // Optional Review Image
          if (review.reviewImage != null && review.reviewImage!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: _buildImage(review.reviewImage!, colorScheme, fit: BoxFit.contain),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String source, ColorScheme colorScheme, {BoxFit fit = BoxFit.cover}) {
    if (source.isEmpty) {
      return Icon(Icons.person, color: colorScheme.primary);
    }

    // Check for Base64 (starts with data:image)
    if (source.startsWith('data:image')) {
      try {
        final base64String = source.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          fit: fit,
          errorBuilder: (_, error, stackTrace) {
            return Icon(Icons.person, color: colorScheme.primary);
          },
        );
      } catch (e) {
        return Icon(Icons.person, color: colorScheme.primary);
      }
    } 
    
    // Check for standard HTTP/HTTPS URL
    if (source.startsWith('http')) {
      return Image.network(
        source,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, color: colorScheme.error);
        },
      );
    }

    // Fallback: Try as Asset
    return Image.asset(
      source,
      fit: fit,
      errorBuilder: (_, error, stackTrace) {
        return Icon(Icons.person, color: colorScheme.primary);
      },
    );
  }
}
