import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/pet_service_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/products_provider.dart';
import '../../services/service_details_screen.dart'; 
import '../../../widgets/offline_dialog.dart';

class WishlistServiceCard extends StatelessWidget {
  final PetServiceModel service;

  const WishlistServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false); // Fix: get provider nicely
    final isActuallyOffline = productsProvider.isOffline;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: bookingProvider,
                      child: ServiceDetailsScreen(service: service),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // High-Definition Image Section with Indicator
                      Hero(
                        tag: 'wishlist_service_${service.id}',
                        child: Container(
                          width: 120,
                          height: 120, // Keep height consistent
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _buildServiceImage(service.image),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Information Section
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.category.toUpperCase(),
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 10, // Slightly bigger for readability
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              service.title,
                              style: TextStyle(
                                fontSize: 18, // Adjusted for responsiveness
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                letterSpacing: -0.5,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 2, // Allow 2 lines to prevent truncated titles
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Rs. ${service.price.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.primary,
                              ),
                            ),
                            const Spacer(), // Push button to bottom
                            // Premium Inline Action Button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "BOOK NOW",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Floating Favorite Toggle
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (isActuallyOffline) {
                      OfflineDialog.show(context, "remove items from favorites");
                      return;
                    }
                    Provider.of<WishlistProvider>(context, listen: false).toggleServiceFavorite(service);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, color: Colors.red, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image,  color: Colors.grey));
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
        },
      );
    }
  }
}
