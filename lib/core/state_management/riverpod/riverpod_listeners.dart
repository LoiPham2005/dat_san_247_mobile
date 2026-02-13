import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// 🎯 Reusable listeners cho Riverpod
class RiverpodListeners {
  /// Hiển thị SnackBar khi state thất bại hoặc thành công
  static void common<T>({
    required WidgetRef ref,
    required BuildContext context,
    required ProviderListenable<AsyncValue<T>> provider,
    String? successMessage,
    void Function(T data)? onSuccess,
  }) {
    ref.listen<AsyncValue<T>>(provider, (previous, next) {
      if (next == previous) return;

      next.whenOrNull(
        error: (error, _) {
          final message = error is Failure ? error.message : error.toString();
          _showSnackBar(context, message, Colors.red);
        },
        data: (data) {
          if (successMessage != null) {
            _showSnackBar(context, successMessage, Colors.green);
          }
          onSuccess?.call(data);
        },
      );
    });
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }
}
