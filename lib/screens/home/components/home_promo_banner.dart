import 'package:flutter/material.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Sample promo banners
    final promos = [
      'Shop. Earn. Repeat. 5% Cashback on Every Purchase!',
      'Limited Offer: 20% Off on Dog Food!',
      'Buy 1 Get 1 Free: Cat Toys!',
      'Exclusive: 15% Off on Pet Accessories!',
      'New Arrival: Organic Pet Treats!',
      'Flash Sale: Up to 30% Off Today!',
    ];

    // Use theme primary but ensure brightness in dark mode
    final bannerColor = cs.brightness == Brightness.dark
        ? Colors
              .deepPurple // bright for dark mode
        : cs.primary; // primary for light mode

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: promos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final promo = promos[index];
          return Container(
            width: 280,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: bannerColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                promo,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
