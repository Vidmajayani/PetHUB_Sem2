import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  
  bool _isLoading = false;
  String? _currentAddress;
  Position? _currentPosition;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get currentAddress => _currentAddress;
  Position? get currentPosition => _currentPosition;
  String? get errorMessage => _errorMessage;

  Future<void> updateCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        _currentPosition = position;
        final address = await _locationService.getAddressFromLatLng(position);
        _currentAddress = address;
      } else {
        _errorMessage = "Could not get location. Check permissions.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _currentAddress = null;
    _currentPosition = null;
    _errorMessage = null;
    notifyListeners();
  }
}
