import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/pet_service_model.dart';
import '../services/database_service.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _favorites = [];
  final List<PetServiceModel> _serviceFavorites = [];
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = true;

  List<Product> get favorites => _favorites;
  List<PetServiceModel> get serviceFavorites => _serviceFavorites;
  bool get isLoading => _isLoading;

  WishlistProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load Product Favorites
      final loadedFavorites = await _dbService.getFavorites();
      _favorites.clear();
      _favorites.addAll(loadedFavorites);

      // Load Service Favorites
      final loadedServiceFavorites = await _dbService.getServiceFavorites();
      _serviceFavorites.clear();
      _serviceFavorites.addAll(loadedServiceFavorites);
      
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- PRODUCT LOGIC ---
  bool isFavorite(String productId) {
    final id = productId.trim();
    return _favorites.any((p) => p.id.trim() == id);
  }

  Future<void> toggleFavorite(Product product) async {
    final productId = product.id.trim();
    final existingIndex = _favorites.indexWhere((p) => p.id.trim() == productId);

    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
      await _dbService.removeFavorite(product.id);
    } else {
      _favorites.add(product);
      await _dbService.insertFavorite(product);
    }
    notifyListeners();
  }

  // --- SERVICE LOGIC ---
  bool isServiceFavorite(String serviceId) {
    final id = serviceId.trim();
    return _serviceFavorites.any((s) => s.id.trim() == id);
  }

  Future<void> toggleServiceFavorite(PetServiceModel service) async {
    final serviceId = service.id.trim();
    final existingIndex = _serviceFavorites.indexWhere((s) => s.id.trim() == serviceId);

    if (existingIndex >= 0) {
      _serviceFavorites.removeAt(existingIndex);
      await _dbService.removeServiceFavorite(service.id);
      debugPrint('💖 Removed Service from favorites: ${service.title}');
    } else {
      _serviceFavorites.add(service);
      await _dbService.insertServiceFavorite(service);
      debugPrint('💖 Added Service to favorites: ${service.title}');
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    _favorites.clear();
    _serviceFavorites.clear();
    await _dbService.clearAllFavorites();
    notifyListeners();
  }
}

