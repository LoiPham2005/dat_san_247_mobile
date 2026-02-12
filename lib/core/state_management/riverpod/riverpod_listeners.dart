// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/riverpod_listeners.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// 🎯 Reusable listeners cho Riverpod
///
/// Cung cấp các helper functions để listen provider changes
/// và thực hiện side effects (toast, dialog, navigation, etc.)

/// Listen AsyncValue và tự động show SnackBar khi có error hoặc success
///
/// Example:
/// ```dart
/// listenAsyncValueWithSnackBar(
///   ref: ref,
///   context: context,
///   provider: myProvider,
///   successMessage: 'Thành công!',
///   onSuccess: () => Navigator.pop(context),
/// );
/// ```
void listenAsyncValueWithSnackBar<T>({
  required WidgetRef ref,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
  String? successMessage,
  String? errorMessage,
  void Function(T data)? onSuccess,
  void Function(Object error)? onError,
  bool showSuccessSnackBar = false,
  bool showErrorSnackBar = true,
}) {
  ref.listen<AsyncValue<T>>(provider, (previous, next) {
    // Bỏ qua nếu state không thay đổi
    if (next == previous) return;

    next.whenOrNull(
      error: (error, stack) {
        onError?.call(error);

        if (showErrorSnackBar) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            final message = error is Failure ? error.message : error.toString();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage ?? message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          });
        }
      },
      data: (data) {
        onSuccess?.call(data);

        if (showSuccessSnackBar && successMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(successMessage),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          });
        }
      },
    );
  });
}

/// Listen BaseAsyncNotifier message và show SnackBar
///
/// Example:
/// ```dart
/// listenNotifierMessage(
///   ref: ref,
///   context: context,
///   provider: myProvider,
/// );
/// ```
void listenNotifierMessage<T>({
  required WidgetRef ref,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
  String? Function()? getMessageCallback,
}) {
  ref.listen<AsyncValue<T>>(provider, (previous, next) {
    if (next == previous) return;

    // Lấy message từ callback nếu có
    final message = getMessageCallback?.call();

    if (message != null && !next.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  });
}

/// Listen và show Dialog khi có error
///
/// Example:
/// ```dart
/// listenAsyncValueWithDialog(
///   ref: ref,
///   context: context,
///   provider: myProvider,
///   errorTitle: 'Lỗi',
/// );
/// ```
void listenAsyncValueWithDialog<T>({
  required WidgetRef ref,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
  String errorTitle = 'Lỗi',
  String successTitle = 'Thành công',
  String? successMessage,
  void Function(T data)? onSuccess,
  void Function(Object error)? onError,
  bool showSuccessDialog = false,
  bool showErrorDialog = true,
}) {
  ref.listen<AsyncValue<T>>(provider, (previous, next) {
    if (next == previous) return;

    next.whenOrNull(
      error: (error, stack) {
        onError?.call(error);

        if (showErrorDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            final message = error is Failure ? error.message : error.toString();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(errorTitle),
                content: Text(message),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
                ],
              ),
            );
          });
        }
      },
      data: (data) {
        onSuccess?.call(data);

        if (showSuccessDialog && successMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(successTitle),
                content: Text(successMessage),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
                ],
              ),
            );
          });
        }
      },
    );
  });
}

/// Listen và navigate khi success
///
/// Example:
/// ```dart
/// listenAndNavigateOnSuccess(
///   ref: ref,
///   context: context,
///   provider: myProvider,
///   route: '/home',
/// );
/// ```
void listenAndNavigateOnSuccess<T>({
  required WidgetRef ref,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
  String? route,
  Widget? page,
  bool replace = false,
  void Function(T data)? onSuccess,
}) {
  ref.listen<AsyncValue<T>>(provider, (previous, next) {
    if (next == previous) return;

    next.whenOrNull(
      data: (data) {
        onSuccess?.call(data);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          if (route != null) {
            if (replace) {
              Navigator.pushReplacementNamed(context, route);
            } else {
              Navigator.pushNamed(context, route);
            }
          } else if (page != null) {
            if (replace) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page));
            }
          }
        });
      },
    );
  });
}

/// Listen và pop khi success
///
/// Example:
/// ```dart
/// listenAndPopOnSuccess(
///   ref: ref,
///   context: context,
///   provider: myProvider,
///   result: 'created',
/// );
/// ```
void listenAndPopOnSuccess<T>({
  required WidgetRef ref,
  required BuildContext context,
  required ProviderListenable<AsyncValue<T>> provider,
  Object? result,
  void Function(T data)? onSuccess,
}) {
  ref.listen<AsyncValue<T>>(provider, (previous, next) {
    if (next == previous) return;

    next.whenOrNull(
      data: (data) {
        onSuccess?.call(data);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          Navigator.pop(context, result);
        });
      },
    );
  });
}

/// Listen specific field changes
///
/// Example:
/// ```dart
/// listenFieldChange<User, String>(
///   ref: ref,
///   provider: userProvider,
///   selector: (user) => user.name,
///   onChanged: (oldName, newName) => print('Name changed from $oldName to $newName'),
/// );
/// ```
void listenFieldChange<T, R>({
  required WidgetRef ref,
  required ProviderListenable<AsyncValue<T>> provider,
  required R Function(T data) selector,
  required void Function(R? previous, R current) onChanged,
}) {
  ref.listen<R?>(provider.select((state) => state.whenOrNull(data: selector)), (previous, next) {
    if (next != null && previous != next) {
      onChanged(previous, next);
    }
  });
}
