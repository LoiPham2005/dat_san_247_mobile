import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/errors/failures.dart';

/// Mixin xử lý network errors
mixin NetworkMixin<T extends StatefulWidget> on State<T> {
  /// Handle network error với UI feedback
  void handleNetworkError(Object error, {void Function()? onRetry, bool showDialog = false}) {
    // 🎯 Use Failure system to get user-friendly message
    final message = error is Failure ? error.userMessage : error.toString();

    if (showDialog) {
      _showErrorDialog(message, onRetry);
    } else {
      _showErrorSnackbar(message, onRetry);
    }
  }

  void _showErrorSnackbar(String message, void Function()? onRetry) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: onRetry != null
            ? SnackBarAction(label: 'Thử lại', textColor: Colors.white, onPressed: onRetry)
            : null,
      ),
    );
  }

  void _showErrorDialog(String message, void Function()? onRetry) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              child: const Text('Thử lại'),
            ),
        ],
      ),
    );
  }

  /// Execute với network error handling
  Future<R?> executeWithNetworkHandling<R>(
    Future<R> Function() action, {
    void Function()? onRetry,
    bool showDialog = false,
  }) async {
    try {
      return await action();
    } catch (e) {
      handleNetworkError(e, onRetry: onRetry, showDialog: showDialog);
      return null;
    }
  }
}
