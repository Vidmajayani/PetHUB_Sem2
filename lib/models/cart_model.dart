import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';
import 'package:pet_supplies_app_v2/services/cart_sync_service.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final CartSyncService _syncService = CartSyncService();

  List<CartItem> get items => List.unmodifiable(_items);

  CartModel() {
    _initCart();
  }

  Future<void> _initCart() async {
    final loadedItems = await _syncService.loadCart();
    if (loadedItems.isNotEmpty) {
      _items.clear();
      _items.addAll(loadedItems);
      notifyListeners();
    }
  }

  void addProduct(Product p, int qty) {
    final existing = _items.where((i) => i.product.id == p.id).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity += qty;
    } else {
      _items.add(CartItem(product: p, quantity: qty));
    }
    _syncService.syncCart(_items);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQty) {
    final item = _items.firstWhere((i) => i.product.id == productId, orElse: () => throw Exception('Not found'));
    item.quantity = newQty;
    if (item.quantity <= 0) {
      _items.removeWhere((i) => i.product.id == productId);
    }
    _syncService.syncCart(_items);
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    _syncService.syncCart(_items);
    notifyListeners();
  }

  double get totalPrice => _items.fold(0.0, (t, i) => t + i.total);

  void clear() {
    _items.clear();
    _syncService.syncCart(_items);
    notifyListeners();
  }
}