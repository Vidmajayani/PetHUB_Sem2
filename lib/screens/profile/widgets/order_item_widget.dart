import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/models/order_model.dart';
import 'package:pet_supplies_app_v2/providers/auth_provider.dart';
import 'package:pet_supplies_app_v2/providers/review_provider.dart';
import '../components/review_dialog.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem item;

  const OrderItemWidget({
    super.key,
    required this.item,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    // Get product ID for review check
    final String productId = widget.item.productId;
    final String userId = authProvider.user?.uid ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Item Image
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.item.image.startsWith('http')
                ? Image.network(widget.item.image, fit: BoxFit.cover)
                : Image.asset(widget.item.image, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${widget.item.quantity} x Rs. ${widget.item.price.toStringAsFixed(2)}",
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Review Button Logic
          FutureBuilder<bool>(
            future: reviewProvider.checkUserReview(userId, productId),
            builder: (context, snapshot) {
              final hasReviewed = snapshot.data ?? false;

              return ElevatedButton(
                onPressed: hasReviewed
                    ? null
                    : () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => ReviewDialog(
                            productId: productId,
                            productName: widget.item.productName,
                          ),
                        );
                        if (result == true) {
                          // Force rebuild to update button state
                          if (mounted) setState(() {});
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
    );
  }
}
