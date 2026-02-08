import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../screens/products/product_card.dart';
import '../../screens/product_details/product_details_screen.dart';
import '../../providers/products_provider.dart';
import '../../widgets/offline_dialog.dart';
import 'widgets/wishlist_service_card.dart';
import 'widgets/wishlist_empty_view.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isOffline = Provider.of<ProductsProvider>(context, listen: false).isOffline;
      if (isOffline) {
        OfflineDialog.show(context, "access all wishlist features");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOffline = Provider.of<ProductsProvider>(context).isOffline;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            tabs: [
              Tab(text: 'Products', icon: Icon(Icons.shopping_bag_outlined)),
              Tab(text: 'Services', icon: Icon(Icons.pets_outlined)),
            ],
          ),

          actions: [
            Consumer<WishlistProvider>(
              builder: (context, wishlist, child) {
                if (wishlist.favorites.isEmpty && wishlist.serviceFavorites.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  iconSize: 28,
                  tooltip: 'Clear All',
                  onPressed: () {
                    if (isOffline) {
                      OfflineDialog.show(context, "clear your wishlist");
                      return;
                    }
                    _showClearAllDialog(context, wishlist);
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildProductsTab(),
                  _buildServicesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTab() {
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, child) {
        if (wishlist.isLoading) return const Center(child: CircularProgressIndicator());
        if (wishlist.favorites.isEmpty) return const WishlistEmptyView(type: 'products');

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: wishlist.favorites.length,
          itemBuilder: (context, index) {
            final product = wishlist.favorites[index];
            return ProductCard(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServicesTab() {
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, child) {
        if (wishlist.isLoading) return const Center(child: CircularProgressIndicator());
        if (wishlist.serviceFavorites.isEmpty) return const WishlistEmptyView(type: 'services');

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: wishlist.serviceFavorites.length,
          itemBuilder: (context, index) {
            final service = wishlist.serviceFavorites[index];
            return WishlistServiceCard(service: service);
          },
        );
      },
    );
  }


  void _showClearAllDialog(BuildContext context, WishlistProvider wishlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wishlist?'),
        content: const Text('Remove everything from your products and services wishlist?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              wishlist.clearAll();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

