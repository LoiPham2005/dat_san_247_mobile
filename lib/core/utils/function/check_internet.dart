import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_utils/nb_utils.dart';

class CheckInternet {
  static StreamSubscription? _subscription;
  static bool _isShown = false;

  static Future<bool> hasConnection() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }

  static Future<void> check(
    BuildContext context, {
    Function()? onConnected,
    Function()? onDisconnected,
    bool showMessage = true,
  }) async {
    final bool isConnected = await hasConnection();

    if (!isConnected && !_isShown && showMessage) {
      _isShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 8),
              Text('Không có kết nối mạng'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Thử lại',
            textColor: Colors.white,
            onPressed: () => check(context),
          ),
        ),
      );
      if (onDisconnected != null) onDisconnected();
    }

    _subscription?.cancel();
    _subscription = InternetConnectionChecker.instance.onStatusChange.listen((
      status,
    ) {
      switch (status) {
        case InternetConnectionStatus.connected:
          if (_isShown && showMessage) {
            _isShown = false;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.wifi, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Đã kết nối mạng'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (onConnected != null) onConnected();
          break;

        case InternetConnectionStatus.disconnected:
          if (!_isShown && showMessage) {
            _isShown = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Mất kết nối mạng'),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: Duration(days: 1),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Thử lại',
                  textColor: Colors.white,
                  onPressed: () => check(context),
                ),
              ),
            );
          }
          if (onDisconnected != null) onDisconnected();
          break;
        case InternetConnectionStatus.slow:
          if (showMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.signal_wifi_bad, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Kết nối mạng yếu'),
                  ],
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          break;
      }
    });
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _isShown = false;
  }
}
