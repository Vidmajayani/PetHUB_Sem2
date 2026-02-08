import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // For rootBundle
import '../models/product_model.dart';

class ApiService {
  // Your GitHub raw URL
  static const String _jsonUrl = 'https://raw.githubusercontent.com/Vidmajayani/pet_app_json/refs/heads/main/products.json';

  /// Fetches products from external JSON file (Requirement: External JSON)
  Future<List<Product>> fetchProducts() async {
    try {
      print('📡 Fetching products from external JSON...');
      
      final response = await http.get(
        Uri.parse(_jsonUrl),
      ).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  /// Used as a final fallback when Online fails.
  Future<List<Product>> fetchOfflineProducts() async {
    try {
      print('📂 Loading products from built-in JSON asset...');
      final String response = await rootBundle.loadString('assets/data/products_offline.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error loading offline asset: $e');
      return [];
    }
  }
}
