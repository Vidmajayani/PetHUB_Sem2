import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device is currently online
  Future<bool> isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      
      // Check if connected to mobile or wifi
      final isConnected = result.contains(ConnectivityResult.mobile) ||
                         result.contains(ConnectivityResult.wifi);
      
      return isConnected;
    } catch (e) {
      print('❌ Error checking connectivity: $e');
      return false;
    }
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
