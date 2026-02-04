import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pet_supplies_app_v2/models/order_model.dart';
import 'package:pet_supplies_app_v2/providers/order_provider.dart';
import 'package:pet_supplies_app_v2/providers/auth_provider.dart';
import 'package:pet_supplies_app_v2/providers/review_provider.dart';
import '../components/review_dialog.dart';
import 'order_details_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.user != null) {
        Provider.of<OrderProvider>(context, listen: false).fetchOrders(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.orders.isEmpty
              ? _buildEmptyState(colorScheme)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(order: order),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: _buildOrderCard(context, order, colorScheme),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            "You have no orders yet 🛍️",
            style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Go to the shop to find great items!",
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, ColorScheme colorScheme) {
    final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(order.date);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID: #${order.id.substring(0, 8).toUpperCase()}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      dateStr,
                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            ...order.items.map((item) => _buildItemRow(context, item, colorScheme)),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  "Rs. ${order.totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, OrderItem item, ColorScheme colorScheme) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: item.image.startsWith('http')
                    ? Image.network(item.image, fit: BoxFit.cover)
                    : Image.asset(item.image, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${item.quantity} x Rs. ${item.price.toStringAsFixed(2)}",
                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ),
              FutureBuilder<bool>(
                future: reviewProvider.checkUserReview(authProvider.user?.uid ?? '', item.productId),
                builder: (context, snapshot) {
                  final hasReviewed = snapshot.data ?? false;

                  return ElevatedButton(
                    onPressed: hasReviewed
                        ? null
                        : () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => ReviewDialog(
                                productId: item.productId,
                                productName: item.productName,
                              ),
                            );
                            if (result == true) {
                              setState(() {}); // Refresh to update button state
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasReviewed ? colorScheme.surface : colorScheme.primary,
                      foregroundColor: hasReviewed ? colorScheme.outline : colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(80, 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: hasReviewed ? 0 : 2,
                    ),
                    child: Text(
                      hasReviewed ? "Reviewed" : "Review",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
