import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/models/pet_service_model.dart';
import 'package:pet_supplies_app_v2/providers/wishlist_provider.dart';
import 'package:pet_supplies_app_v2/providers/products_provider.dart';
import 'package:pet_supplies_app_v2/providers/booking_provider.dart';
import 'package:pet_supplies_app_v2/screens/services/service_details_screen.dart';
import 'package:pet_supplies_app_v2/widgets/offline_dialog.dart';

class ServiceCard extends StatelessWidget {
  final PetServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
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
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 4,
        color: isDark ? const Color(0xFF1E1E1E) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark ? BorderSide(color: Colors.grey.shade800, width: 1) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'service_${service.id}',
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: isDark ? const Color(0xFF252525) : Colors.white,
                    child: service.image.startsWith('http')
                        ? Image.network(
                            service.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                          )
                        : Image.asset(
                            service.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                          ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      service.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isFav = wishlist.isServiceFavorite(service.id);
                      return CircleAvatar(
                        backgroundColor: isDark ? Colors.black45 : Colors.white70,
                        radius: 18,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : (isDark ? Colors.white70 : Colors.grey),
                            size: 20,
                          ),
                          onPressed: () {
                            final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                            if (productsProvider.isOffline) {
                              OfflineDialog.show(context, "favorite services");
                              return;
                            }
                            wishlist.toggleServiceFavorite(service);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.title, 
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        "Rs. ${service.price.toStringAsFixed(0)}", 
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: colorScheme.primary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description, 
                    style: TextStyle(
                      fontSize: 12, 
                      color: isDark ? Colors.grey[400] : Colors.black54,
                    ), 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? colorScheme.primary : null,
                        foregroundColor: isDark ? Colors.white : null,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ServiceDetailsScreen(service: service)),
                        );
                      },
                      child: const Text("View Details"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
