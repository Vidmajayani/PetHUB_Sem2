import 'package:flutter/material.dart';
import 'category_card.dart';

class ServicesHomeView extends StatelessWidget {
  final Function(String) onCategorySelected;

  const ServicesHomeView({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleek Re-designed Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(32),
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EXPERT PET ADVICE",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Consult with our\nProfessionals",
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Premium Circular Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.star, color: colorScheme.onPrimaryContainer, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          Text(
            "Select Specialty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose a category to browse specific breed consultations",
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          CategoryCard(
            title: "Feline Consultations",
            subtitle: "Expert health & behavior advice for 25+ cat breeds",
            icon: Icons.pets,
            gradient: const [Color(0xFF6A11CB), Color(0xFF2575FC)], // Premium Purple-Blue
            onTap: () => onCategorySelected('cat'),
          ),
          const SizedBox(height: 20),
          CategoryCard(
            title: "Canine Consultations",
            subtitle: "Specialized care plans for 30+ dog breeds",
            icon: Icons.pets,
            gradient: const [Color(0xFFFF5F6D), Color(0xFFFFC371)], // Premium Peach-Pink
            onTap: () => onCategorySelected('dog'),
          ),
        ],
      ),
    );
  }
}
