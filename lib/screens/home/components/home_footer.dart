import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.primary.withOpacity(
        0.05,
      ), // soft version of theme color
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Footer image
          Image.asset(
            'assets/images/pets_footer.png',
            height: 160,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 24),

          //Title
          Text(
            'Care & Healthy Pets',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          //Description
          Text(
            'At Pet HUB, we believe every pet deserves the best care, love, and happiness. '
            'Explore our trusted range of supplies designed to keep your furry friends '
            'healthy, happy, and full of life.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          Divider(color: colorScheme.primary.withOpacity(0.2), thickness: 1),

          const SizedBox(height: 12),

          Text(
            '© 2025 Pet HUB. Created by VidmaJayani | All Rights Reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
