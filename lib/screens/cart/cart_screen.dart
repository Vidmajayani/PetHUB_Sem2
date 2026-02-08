import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import '../../providers/products_provider.dart';
import '../../widgets/offline_dialog.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary.dart';
import 'widgets/empty_cart_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Show offline dialog if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isOffline = Provider.of<ProductsProvider>(context, listen: false).isOffline;
      if (isOffline) {
        OfflineDialog.show(context, "access all cart features");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isOffline = Provider.of<ProductsProvider>(context).isOffline;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (cart.items.isNotEmpty && !isOffline)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              iconSize: 28,
              tooltip: 'Clear all items',
              onPressed: () => _showClearCartConfirmation(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const EmptyCartView()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return CartItemCard(
                              item: item,
                              isOffline: isOffline,
                            );
                          },
                        ),
                      ),
                      CartSummary(
                        itemCount: cart.items.length,
                        totalPrice: cart.totalPrice,
                        isOffline: isOffline,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showClearCartConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.delete_forever_rounded, color: colorScheme.error, size: 32),
        title: const Text('Clear Shopping Cart?'),
        content: const Text('This will remove all items from your cart. This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<CartModel>(context, listen: false).clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cart cleared successfully'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: colorScheme.error,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('CLEAR ALL', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
