import 'package:flutter/material.dart';

class RateStarSelector extends StatelessWidget {
  final double rating;
  final Function(double) onRatingSelected;

  const RateStarSelector({
    super.key,
    required this.rating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            "Select Rating (Mandatory)",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => onRatingSelected(starValue),
                child: Icon(
                  index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: Colors.amber,
                  size: 48,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
