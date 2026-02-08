import 'package:flutter/material.dart';

class SearchSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SearchSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.2),
        ),
      ],
    );
  }
}
