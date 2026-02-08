import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  List<Product> _products = [];
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;

  ProductsProvider() {
    // Start listening to connectivity changes
    _initConnectivityListener();
  }

  /// Load products - fetch from API if online, load from built-in assets if offline
  Future<void> loadProducts() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Check connectivity
      final isOnline = await _connectivityService.isOnline();
      _isOffline = !isOnline;

      if (isOnline) {
        // Online: Fetch from External GitHub JSON (Requirement)
        print('-------------------------------------------');
        print('🌐 NETWORK: ONLINE');
        print('📥 FETCHING: Products from GitHub (External JSON)');
        print('-------------------------------------------');

        final fetchedProducts = await _apiService.fetchProducts();
        _products = fetchedProducts;
        print('✅ SUCCESS: Loaded ${_products.length} products from GitHub!');
        print('🔥 BEST SELLERS: derived from GitHub data (First 6 items)');
      } else {
        // Offline Mode (Requirement: Local JSON Folder)
        print('-------------------------------------------');
        print('⚠️ NETWORK: OFFLINE');
        print('📂 REDIRECT: Loading from Local JSON (Assets/Data)');
        print('-------------------------------------------');

        final assetProducts = await _apiService.fetchOfflineProducts();
        
        if (assetProducts.isNotEmpty) {
          _products = assetProducts;
          print('✅ SUCCESS: Loaded ${_products.length} local products!');
          print('🔥 BEST SELLERS: derived from Local JSON data (First 6 items)');
        } else {
          _errorMessage = 'No offline data found in assets/data/';
          print('❌ ERROR: Could not find local products.json');
        }
      }
    } catch (e) {
      print('❌ Error loading products: $e');
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh products (force fetch from API)
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  /// Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Initialize connectivity listener for real-time updates
  void _initConnectivityListener() {
    print('🎯 Connectivity listener initialized!');
    
    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        print('🔔 Connectivity changed! Results: $results');
        
        final wasOffline = _isOffline;
        final isOnline = results.contains(ConnectivityResult.mobile) ||
                         results.contains(ConnectivityResult.wifi);
        
        print('📊 Was offline: $wasOffline, Is online now: $isOnline');
        
        _isOffline = !isOnline;
        
        print('📱 Updated _isOffline to: $_isOffline');
        
        // Log connectivity change
        if (wasOffline && !_isOffline) {
          print('🟢 Connection restored - Back online!');
        } else if (!wasOffline && _isOffline) {
          print('🔴 Connection lost - Now offline!');
        }
        
        // Notify listeners immediately to update UI
        print('🔄 Notifying listeners...');
        notifyListeners();
        
        // Reload products when connectivity changes
        if (wasOffline != _isOffline) {
          print('♻️ Reloading products...');
          await loadProducts();
        }
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
