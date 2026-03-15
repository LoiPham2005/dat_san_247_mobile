import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/common/extensions/context_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../errors/failures.dart';

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
          context.toast.error(message);
        },
        data: (data) {
          if (successMessage != null) {
            context.toast.success(successMessage);
          }
          onSuccess?.call(data);
        },
      );
    });
  }
}
