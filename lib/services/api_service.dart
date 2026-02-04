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

  /// NEW: Public API Integration for "Exotic Pets" category (Requirement: Public API)
  /// Fetches live pet data and filters for unique animal types
  Future<List<Product>> fetchExoticPetsApi() async {
    try {
      print('📡 Fetching from Swagger Petstore (Exotic Pets API)...');
      final response = await http.get(
        Uri.parse('https://petstore.swagger.io/v2/pet/findByStatus?status=available'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Define existing categories to filter them out
        final existingCategories = ['dog', 'cat', 'bird', 'fish', 'reptile', 'hamster', 'rabbit', 'turtle'];
        
        return data.where((item) {
          if (item['name'] == null || item['name'].toString().isEmpty) return false;
          
          final categoryName = item['category'] != null 
              ? item['category']['name']?.toString().toLowerCase() ?? '' 
              : '';
          
          // Filter out existing categories to show something NEW
          return !existingCategories.any((ex) => categoryName.contains(ex));
        }).take(15).map((item) {
          final id = 'api_${item['id']}';
          final name = item['name'] ?? 'Exotic Friend';
          final subcategory = item['category'] != null ? item['category']['name'] ?? 'Exotic' : 'Exotic';
          
          return Product(
            id: id,
            category: 'Exotic Pets',
            subcategory: subcategory,
            name: name,
            description: 'Live information about unique and exotic pets fetched directly from the Public Swagger Petstore API.',
            price: 49.99, // Placeholder price for exotic pets
            image: (item['photoUrls'] != null && (item['photoUrls'] as List).isNotEmpty && (item['photoUrls'][0]).contains('http'))
                ? item['photoUrls'][0]
                : 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&q=80&w=400',
            rating: 4.9,
            specialFeatures: 'Source: Public Petstore API',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('❌ Exotic Pets API error: $e');
      return [];
    }
  }

  /// NEW: Load products from local JSON asset (Requirement: Local JSON)
  /// Used as a final fallback when both Online and Cache fail.
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
