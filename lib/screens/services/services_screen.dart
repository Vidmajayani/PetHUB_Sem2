import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/pet_service_model.dart';
import 'package:pet_supplies_app_v2/services/public_pet_services_api.dart';
import 'package:pet_supplies_app_v2/services/connectivity_service.dart';
import 'package:pet_supplies_app_v2/screens/services/widgets/service_card.dart';
import 'widgets/services_home_view.dart';
import 'widgets/services_error_view.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final PublicPetServicesApi _apiService = PublicPetServicesApi();
  List<PetServiceModel> _services = [];
  bool _isLoading = false;
  String? _selectedType; // null = Selection Home, 'cat', 'dog'

  @override
  void initState() {
    super.initState();
    // Start at Selection Home (null)
  }

  Future<void> _loadBreedData(String type) async {
    final connectivity = ConnectivityService();
    final isOnline = await connectivity.isOnline();

    setState(() {
      _selectedType = type;
      _isLoading = true;
      _services = [];
    });

    List<PetServiceModel> results = [];

    // ENHANCED LOGGING: Clear indication of data source
    print('================================================================');
    print('🔍 PET SERVICES DATA REQUEST');
    print('================================================================');
    print('🐩 TYPE: ${type.toUpperCase()} Consultations');
    print('📡 CONNECTIVITY STATUS: ${isOnline ? "ONLINE (Wi-Fi/Mobile)" : "OFFLINE (No Internet)"}');
    
    if (isOnline) {
      print('🌐 SOURCE: Fetching live data from Public REST API...');
      print('🔗 ENDPOINT: ${type == 'cat' ? "TheCatAPI" : "TheDogAPI"}');
      
      try {
        results = (type == 'cat') 
            ? await _apiService.fetchCatServices() 
            : await _apiService.fetchDogServices();
            
        print('✅ API SUCCESS: Retrieved ${results.length} records from external API.');
      } catch (e) {
        print('❌ API FAILURE: $e');
        print('⚠️ FALLBACK: Attempting to load offline data due to API failure...');
        // Fallback to offline if online fetch fails
         final allOffline = await _apiService.fetchOfflineServices();
         results = allOffline.where((s) {
            final category = s.category.toLowerCase();
            if (type == 'dog') return category.contains('canine') || category.contains('dog');
            if (type == 'cat') return category.contains('feline') || category.contains('cat');
            return false;
         }).toList();
         print('📂 FALLBACK SUCCESS: Loaded ${results.length} records from local assets.');
      }
    } else {
      print('📂 SOURCE: Loading data from LOCAL JSON ASSETS (Offline Mode)');
      print('📍 FILE: assets/data/${type}_services_offline.json');

      final allOffline = await _apiService.fetchOfflineServices();
      // FIX: Ensure 'cat' matches 'Feline' and 'dog' matches 'Canine' or 'Dog'
      results = allOffline.where((s) {
        final category = s.category.toLowerCase();
        if (type == 'dog') return category.contains('canine') || category.contains('dog');
        if (type == 'cat') return category.contains('feline') || category.contains('cat');
        return false;
      }).toList();
      
      print('✅ LOCAL SUCCESS: Loaded ${results.length} records from internal storage.');
    }
    
    print('================================================================');

    if (mounted) {
      setState(() {
        _services = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedType == null 
            ? 'Professional Services' 
            : (_selectedType == 'cat' ? 'Cat Consultations' : 'Dog Consultations')),
        centerTitle: true,
        leading: _selectedType != null 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedType = null),
              )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_selectedType == null) {
      return ServicesHomeView(onCategorySelected: _loadBreedData);
    }

    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Fetching Live Expert Data..."),
          ],
        ),
      );
    }

    if (_services.isEmpty) {
      return ServicesErrorView(onRetry: () => _loadBreedData(_selectedType!));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        return ServiceCard(service: _services[index]);
      },
    );
  }
}

