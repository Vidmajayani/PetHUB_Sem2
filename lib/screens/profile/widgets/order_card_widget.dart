import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_supplies_app_v2/models/order_model.dart';
import '../sections/order_details_page.dart';
import 'order_item_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;

  const OrderCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(order.date);

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
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID and Date
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
              
              // Items List
              ...order.items.map((item) => OrderItemWidget(item: item)),
              
              const Divider(height: 24),
              
              // Total
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
      ),
    );
  }
}
