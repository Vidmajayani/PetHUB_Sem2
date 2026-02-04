import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _favorites = [];
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = true;

  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;

  WishlistProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedFavorites = await _dbService.getFavorites();
      _favorites.clear();
      _favorites.addAll(loadedFavorites);
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String productId) {
    // Trim to avoid whitespace issues and compare
    final id = productId.trim();
    return _favorites.any((p) => p.id.trim() == id);
  }

  Future<void> toggleFavorite(Product product) async {
    final productId = product.id.trim();
    final existingIndex = _favorites.indexWhere((p) => p.id.trim() == productId);

    if (existingIndex >= 0) {
      // Remove from list
      _favorites.removeAt(existingIndex);
      // Remove from DB
      await _dbService.removeFavorite(product.id);
      debugPrint('💖 Removed from favorites: ${product.name}');
    } else {
      // Add to list
      _favorites.add(product);
      // Add to DB
      await _dbService.insertFavorite(product);
      debugPrint('💖 Added to favorites: ${product.name}');
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    _favorites.clear();
    await _dbService.clearAllFavorites();
    notifyListeners();
  }
}
