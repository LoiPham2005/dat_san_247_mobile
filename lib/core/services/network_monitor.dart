// ════════════════════════════════════════════════════════════════
// 📁 lib/core/presentation/network_monitor.dart (FIXED - Support List)
// ════════════════════════════════════════════════════════════════
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Network monitor with UI feedback
/// - Hiển thị SnackBar khi mất/có mạng
/// - Dùng trong widgets cần UI feedback
/// - Không inject, dùng trực tiếp
class NetworkMonitor {
  NetworkMonitor._();
  static final NetworkMonitor _instance = NetworkMonitor._();
  factory NetworkMonitor() => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isSnackBarShown = false;

  /// Start monitoring with UI feedback
  Future<void> startMonitoring(
    BuildContext context, {
    VoidCallback? onConnected,
    VoidCallback? onDisconnected,
    bool showSnackBar = true,
  }) async {
    // Check initial state
    final results = await _connectivity.checkConnectivity();
    if (!_isConnected(results)) {
      if (showSnackBar && context.mounted) {
        _showDisconnectedSnackBar(context);
      }
      onDisconnected?.call();
    }

    // Start listening
    await _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) => _handleConnectivityChange(
        context,
        results,
        showSnackBar: showSnackBar,
        onConnected: onConnected,
        onDisconnected: onDisconnected,
      ),
    );
  }

  void _handleConnectivityChange(
    BuildContext context,
    List<ConnectivityResult> results, {
    bool showSnackBar = true,
    VoidCallback? onConnected,
    VoidCallback? onDisconnected,
  }) {
    if (!context.mounted) return;

    final isConnected = _isConnected(results);

    if (isConnected) {
      if (_isSnackBarShown && showSnackBar) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showConnectedSnackBar(context, results);
      }
      onConnected?.call();
    } else {
      if (!_isSnackBarShown && showSnackBar) {
        _showDisconnectedSnackBar(context);
      }
      onDisconnected?.call();
    }
  }

  void _showConnectedSnackBar(
    BuildContext context,
    List<ConnectivityResult> results,
  ) {
    _isSnackBarShown = false;
    final connectionType = _getConnectionTypeName(results);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi, color: Colors.white),
            const SizedBox(width: 12),
            Text('Đã kết nối ($connectionType)'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDisconnectedSnackBar(BuildContext context) {
    _isSnackBarShown = true;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 12),
            Text('Mất kết nối mạng'),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(days: 1), // Keep until reconnected
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Thử lại',
          textColor: Colors.white,
          onPressed: () => startMonitoring(context),
        ),
      ),
    );
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.isNotEmpty && 
           !results.every((result) => result == ConnectivityResult.none);
  }

  String _getConnectionTypeName(List<ConnectivityResult> results) {
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return 'Không có kết nối';
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
        return '4G/5G';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      default:
        return 'Internet';
    }
  }

  /// Stop monitoring
  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
    _isSnackBarShown = false;
  }

  void dispose() => stopMonitoring();
}