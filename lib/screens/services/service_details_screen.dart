import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pet_service_model.dart';
import '../../providers/wishlist_provider.dart';
import 'package:pet_supplies_app_v2/providers/products_provider.dart';
import 'package:pet_supplies_app_v2/widgets/offline_dialog.dart';
import 'widgets/service_details_header.dart';
import 'widgets/service_about_section.dart';
import 'widgets/service_stats_grid.dart';
import 'widgets/service_bottom_action.dart';


class ServiceDetailsScreen extends StatelessWidget {

  final PetServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceDetailsHeader(service: service),
                  const SizedBox(height: 24),
                  ServiceAboutSection(service: service),
                  const SizedBox(height: 24),
                  if (service.category == 'Feline Care Service') ...[
                    ServiceStatsGrid(service: service),
                    const SizedBox(height: 24),
                  ],
                  // Button removed from here to be pinned at bottom
                  const SizedBox(height: 100), // Extra space to scroll past the fixed button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ServiceBottomAction(service: service),
    );
  }


  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black26, // Subtle dark background for visibility
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<WishlistProvider>(
            builder: (context, wishlist, child) {
              final isFav = wishlist.isServiceFavorite(service.id);
              return CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () {
                    final isOffline = Provider.of<ProductsProvider>(context, listen: false).isOffline;
                    if (isOffline) {
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
      flexibleSpace: FlexibleSpaceBar(

        background: Hero(
          tag: 'service_${service.id}',
          child: service.image.startsWith('http')
            ? Image.network(
                service.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 100)),
              )
            : Image.asset(
                service.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 100)),
              ),
        ),
      ),
    );
  }
}

