import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storageService = LocalStorageService();
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

  /// Load products - fetch from API if online, load from cache if offline
  Future<void> loadProducts() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Check connectivity
      final isOnline = await _connectivityService.isOnline();
      _isOffline = !isOnline;

      if (isOnline) {
        // Online: Fetch from both sources
        print('📡 Online - Fetching products from API and Public Source...');
        
        // 1. Fetch main products (External JSON requirement)
        final fetchedProducts = await _apiService.fetchProducts();
        
        // 2. Fetch public API products (Public API requirement)
        final publicApiProducts = await _apiService.fetchExoticPetsApi();
        
        // Combine them
        _products = [...fetchedProducts, ...publicApiProducts];
        
        // Save to local storage for offline use
        await _storageService.saveProducts(_products);
        
        print('✅ Loaded ${_products.length} total products (JSON + Public API)');
      } else {
        // LAYER 2: Offline - Load from cache
        print('📴 Offline - Loading products from cache...');
        final cachedProducts = await _storageService.loadProducts();
        
        if (cachedProducts.isEmpty) {
          // LAYER 3: Final Fallback - Load from Built-in JSON Asset
          print('📦 Cache empty - Loading from built-in JSON asset...');
          final assetProducts = await _apiService.fetchOfflineProducts();
          if (assetProducts.isNotEmpty) {
            _products = assetProducts;
            print('✅ Loaded ${_products.length} products from built-in asset');
          } else {
            _errorMessage = 'No products available. Please connect to the internet.';
          }
        } else {
          _products = cachedProducts;
          print('✅ Loaded ${_products.length} products from cache');
        }
      }
    } catch (e) {
      print('❌ Error loading products: $e');
      _errorMessage = 'Failed to load products: $e';
      
      // Try loading from cache as fallback
      try {
        final cachedProducts = await _storageService.loadProducts();
        if (cachedProducts.isNotEmpty) {
          _products = cachedProducts;
          _errorMessage = 'Using cached data (Error: $e)';
          print('⚠️ Loaded ${_products.length} products from cache (fallback)');
        }
      } catch (cacheError) {
        print('❌ Cache fallback also failed: $cacheError');
      }
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
