import 'package:flutter/material.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Promo Data using Images AND Icons
    final promos = [
      {
        'text': 'Free Delivery on EVERY Order!\nRs. 0 Fees!',
        'image': 'assets/images/promo-home_2.png',
        'icon': Icons.local_shipping,
        'iconColor': Colors.blue,
      },
      {
        'text': 'Premium Veterinary Services\nBook Now!',
        'image': 'assets/images/promo-home_3.png',
        'icon': Icons.medical_services,
        'iconColor': Colors.red,
      },
      {
        'text': 'Get expert advice for your pets!\n24/7 Support!',
        'image': 'assets/images/promo-home_4.png',
        'icon': Icons.lightbulb,
        'iconColor': Colors.purple,
      },
      {
        'text': 'Quality You Can Trust for\nYour Furry Friends!',
        'image': 'assets/images/promo-home_5.png',
        'icon': Icons.verified_user,
        'iconColor': Colors.teal,
      },
      {
        'text': 'Food, Toys, Treats & Accessories!\nEverything for your pet!',
        'image': 'assets/images/promo-home_1.png',
        'icon': Icons.pets,
        'iconColor': Colors.orange,
      },
    ];

    // Design Colors
    final bgColor = isDark ? Colors.black : Colors.white;
    final borderColor = Colors.purpleAccent; // Distinct purple border
    final textColor = isDark ? Colors.white : Colors.black;

    return SizedBox(
      height: 320, // Increased height significantly for text space
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: promos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final promo = promos[index];

          return Container(
            width: 280, 
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section (Top)
                Expanded(
                  flex: 3, 
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0), // moved top padding here for control
                    child: Image.asset(
                      promo['image'] as String,
                      width: double.infinity,
                      fit: BoxFit.contain, // Fixed cropping issue
                      errorBuilder: (context, error, stackTrace) {
                         return Container(
                           color: isDark ? Colors.grey[900] : Colors.grey[200],
                           child: Center(child: Icon(Icons.image_not_supported, color: borderColor, size: 60)),
                         );
                      },
                    ),
                  ),
                ),
                
                // Content Section (Bottom)
                Expanded(
                  flex: 2, // Keeps ratio 3:2 (60% image, 40% text)
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colored Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (promo['iconColor'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            promo['icon'] as IconData,
                            color: promo['iconColor'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Text
                        Expanded(
                          child: Text(
                            promo['text'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 16.0, // adjusted slightly for fit
                              height: 1.3,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
