import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_supplies_app_v2/models/cart_model.dart';
import 'package:pet_supplies_app_v2/models/product_model.dart';

class CartSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  /// Sync the entire cart to Firestore
  Future<void> syncCart(List<CartItem> items) async {
    final uid = _uid;
    if (uid == null) return;

    final cartData = items.map((item) => {
      'productId': item.product.id,
      'quantity': item.quantity,
      'product': item.product.toJson(), // Store full product for offline/speed
    }).toList();

    await _firestore.collection('users').doc(uid).set({
      'cart': cartData,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Load cart from Firestore
  Future<List<CartItem>> loadCart() async {
    final uid = _uid;
    if (uid == null) return [];

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data()?['cart'] == null) return [];

    final List<dynamic> cartData = doc.data()!['cart'];
    return cartData.map((data) {
      return CartItem(
        product: Product.fromJson(data['product']),
        quantity: data['quantity'],
      );
    }).toList();
  }
}
