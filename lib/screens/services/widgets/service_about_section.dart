import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/pet_service_model.dart';

class ServiceAboutSection extends StatelessWidget {
  final PetServiceModel service;

  const ServiceAboutSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About this Breed", 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          )
        ),
        const SizedBox(height: 8),
        Text(
          service.description,
          style: TextStyle(
            fontSize: 15, 
            height: 1.5, 
            color: isDark ? Colors.grey[300] : Colors.black87
          ),
        ),
        if (service.temperament != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.label_outline, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Traits", 
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.grey[300] : Colors.black87
                )
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.temperament!.split(',').take(6).map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 1),
              ),
              child: Text(
                t.trim(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            )).toList(),
          ),
        ],

      ],
    );
  }
}
