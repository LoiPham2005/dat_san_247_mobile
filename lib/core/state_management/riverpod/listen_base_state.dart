import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_base_template/shared/widgets/toast/show_toast.dart';

/// ✅ Lắng nghe thay đổi AsyncValue<T> từ provider
/// Tự động show toast khi success/error và hỗ trợ callback linh hoạt.
void listenAsyncValue<T>({
  required WidgetRef ref,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
  String? successMessage,
  String? errorMessage,
  VoidCallback? onSuccess,
  void Function(T data)? onData,
  void Function(Object error)? onError,
}) {
  ref.listen<AsyncValue<T>>(
    provider,
    (previous, next) {
      // Nếu state không thay đổi thực sự -> bỏ qua
      if (next == previous) return;

      // ⚙️ Xử lý từng trạng thái
      next.whenOrNull(
        error: (error, _) {
          onError?.call(error);

          // ✅ Đảm bảo chỉ show toast sau khi frame build xong
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            ShowToast(
              context,
              message: errorMessage ?? error.toString(),
              type: ToastificationType.error,
            );
          });
        },
        data: (data) {
          onData?.call(data);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            ShowToast(
              context,
              message: successMessage ?? 'Thao tác thành công!',
              type: ToastificationType.success,
            );
          });

          onSuccess?.call();
        },
      );
    },
  );
}
