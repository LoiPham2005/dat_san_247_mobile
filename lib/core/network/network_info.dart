// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/network_info.dart (FIXED - Support List)
// ════════════════════════════════════════════════════════════════
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Core network connectivity checker
/// - Không phụ thuộc UI/BuildContext
/// - Testable với DI
/// - Dùng trong business logic, repositories, use cases
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<List<ConnectivityResult>> get connectionTypes;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
  
  // Helper methods
  bool isConnectedFromResult(List<ConnectivityResult> results);
  String getConnectionTypeName(List<ConnectivityResult> results);
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  
  NetworkInfoImpl(this._connectivity);
  
  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return isConnectedFromResult(results);
  }

  @override
  Future<List<ConnectivityResult>> get connectionTypes async {
    return await _connectivity.checkConnectivity();
  }
  
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  @override
  bool isConnectedFromResult(List<ConnectivityResult> results) {
    return results.isNotEmpty && 
           !results.every((result) => result == ConnectivityResult.none);
  }

  @override
  String getConnectionTypeName(List<ConnectivityResult> results) {
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return 'No Connection';
    }

    // Get first non-none result
    final result = results.firstWhere(
      (r) => r != ConnectivityResult.none,
      orElse: () => ConnectivityResult.none,
    );

    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }
}