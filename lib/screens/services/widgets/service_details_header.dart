import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/pet_service_model.dart';

class ServiceDetailsHeader extends StatelessWidget {
  final PetServiceModel service;

  const ServiceDetailsHeader({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                service.title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Rs. ${service.price.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.public, size: 16, color: isDark ? const Color(0xFFD1C4E9) : colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  "Origin: ${service.origin ?? 'Unknown'}",
                  style: TextStyle(
                    color: isDark ? const Color(0xFFD1C4E9) : colorScheme.secondary, 
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text(
                  "Lifespan: ${service.lifeSpan ?? '12-15'} years",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
