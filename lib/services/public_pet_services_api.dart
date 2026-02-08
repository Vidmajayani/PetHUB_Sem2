import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_service_model.dart';
import 'package:flutter/services.dart'; // For rootBundle

class PublicPetServicesApi {
  // Global Third-Party REST API (Requirement: Publicly Available API)
  // Official Service: The Cat API
  // Private API Key for Authorized Access
  static const String _catBaseUrl = 'https://api.thecatapi.com/v1/breeds';
  static const String _dogBaseUrl = 'https://api.thedogapi.com/v1/breeds';
  
  // Private API Keys
  static const String _catApiKey = 'live_QBrMlcwlNeCDsV5kHDxMvzQx05RDhdWlGBS9K3Xk8n1YQf5JjOKmeWx40WH4CaBA';
  static const String _dogApiKey = 'live_crOPVt1qYrhRVkU7hYFJvYIz2roLDXXFGfgPe4IGjwEub1EEjOIPjVY3xlGYKfbj';


  /// Fetches feline breed consultations
  Future<List<PetServiceModel>> fetchCatServices() async {
    try {
      final ts = DateTime.now().millisecondsSinceEpoch;
      final response = await http.get(
        Uri.parse('$_catBaseUrl?limit=30&ts=$ts'), 
        headers: {'x-api-key': _catApiKey}
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('🐈 CAT API: Received ${data.length} breeds.');
        return data.map((j) => PetServiceModel.fromJson(j)..setCategory('Feline Care Service')).toList();
      }
      return [];
    } catch (e) {
      print('❌ Cat API Fail: $e');
      return [];
    }
  }

  /// Fetches canine breed consultations
  Future<List<PetServiceModel>> fetchDogServices() async {
    try {
      final ts = DateTime.now().millisecondsSinceEpoch;
      print('🌐 CONNECTING: Dog API (Requested: 25)...');
      final response = await http.get(
        Uri.parse('$_dogBaseUrl?limit=30&ts=$ts'), 
        headers: {'x-api-key': _dogApiKey}
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('🐕 DOG API: Received ${data.length} breeds.');
        return data.map((j) => PetServiceModel.fromJson(j)..setCategory('Canine Care Service')).toList();
      }
      return [];
    } catch (e) {
      print('❌ Dog API ERROR: $e');
      return [];
    }
  }



  /// Combined fetch for general overview
  Future<List<PetServiceModel>> fetchServices() async {
    final cats = await fetchCatServices();
    final dogs = await fetchDogServices();
    if (cats.isEmpty && dogs.isEmpty) return fetchOfflineServices();
    return [...cats, ...dogs]..shuffle();
  }




  /// NEW: Load services from local JSON asset (Requirements: Local JSON Fallback)
  /// NEW: Load services from local JSON asset (Requirements: Local JSON Fallback)
  Future<List<PetServiceModel>> fetchOfflineServices() async {
    List<PetServiceModel> allServices = [];
    try {
      print(' Loading services from local JSON assets (OFFLINE MODE)...');
      
      // Load Cat Services
      try {
        final String catResponse = await rootBundle.loadString('assets/data/cat_services_offline.json');
        final List<dynamic> catData = json.decode(catResponse);
        allServices.addAll(catData.map((json) => PetServiceModel.fromJson(json)).toList());
      } catch (e) {
        print('⚠️ Error loading cat services: $e');
      }

      // Load Dog Services
      try {
        final String dogResponse = await rootBundle.loadString('assets/data/dog_services_offline.json');
        final List<dynamic> dogData = json.decode(dogResponse);
        allServices.addAll(dogData.map((json) => PetServiceModel.fromJson(json)).toList());
      } catch (e) {
        print('⚠️ Error loading dog services: $e');
      }

      return allServices;
    } catch (e) {
      print('❌ Offline asset error: $e');
      return [];
    }
  }
}





