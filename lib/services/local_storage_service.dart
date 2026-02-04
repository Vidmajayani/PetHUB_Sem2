import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';

class LocalStorageService {
  static const String _fileName = 'products_cache.json';

  /// Get the path to the local JSON file
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Get the File object for products cache
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  /// Save products to local JSON file
  Future<void> saveProducts(List<Product> products) async {
    try {
      final file = await _localFile;
      
      // Convert products to JSON
      final jsonData = products.map((product) => product.toJson()).toList();
      final jsonString = json.encode(jsonData);
      
      // Write to file
      await file.writeAsString(jsonString);
      
      print('✅ Saved ${products.length} products to local storage');
    } catch (e) {
      print('❌ Error saving products: $e');
      throw Exception('Failed to save products to local storage: $e');
    }
  }

  /// Load products from local JSON file
  Future<List<Product>> loadProducts() async {
    try {
      final file = await _localFile;
      
      // Check if file exists
      if (!await file.exists()) {
        print('⚠️ No cached products found');
        return [];
      }

      // Read file
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);
      
      // Convert JSON to Product objects
      final products = jsonData.map((json) => Product.fromJson(json)).toList();
      
      print('✅ Loaded ${products.length} products from local storage');
      return products;
    } catch (e) {
      print('❌ Error loading products: $e');
      throw Exception('Failed to load products from local storage: $e');
    }
  }

  /// Check if cached data exists
  Future<bool> hasCachedData() async {
    try {
      final file = await _localFile;
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Clear cached data
  Future<void> clearCache() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
        print('✅ Cache cleared');
      }
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }
}
