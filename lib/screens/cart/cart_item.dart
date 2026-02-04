import 'package:flutter/material.dart';
import '../../models/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final void Function() onRemove;
  final void Function(int) onQuantityChanged;

  const CartItemWidget({super.key, required this.item, required this.onRemove, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          SizedBox(width: 100, height: 100, child: item.product.image.isNotEmpty ? Image.asset(item.product.image, fit: BoxFit.cover) : const Icon(Icons.image)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => onQuantityChanged(item.quantity - 1)),
                  Text(item.quantity.toString()),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => onQuantityChanged(item.quantity + 1)),
                ]),
              ]),
            ),
          ),
          IconButton(onPressed: onRemove, icon: const Icon(Icons.delete, color: Colors.red)),
        ],
      ),
    );
  }
}