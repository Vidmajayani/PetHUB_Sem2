import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/navigation_provider.dart';
import '../../../providers/products_provider.dart'; // Just in case, though not used here directly

class WishlistEmptyView extends StatelessWidget {
  final String type; // 'products' or 'services'

  const WishlistEmptyView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 80, color: colorScheme.primary.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text('No $type saved yet', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Save your favorite $type to find them easily later!', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                if (type == 'products') {
                  Provider.of<NavigationProvider>(context, listen: false).goToCategories();
                } else {
                  Provider.of<NavigationProvider>(context, listen: false).goToServices();
                }
              },
              child: Text('Explore $type'),
            ),
          ],
        ),
      ),
    );
  }
}
