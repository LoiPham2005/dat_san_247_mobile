// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/bloc_listeners.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/bloc_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🎯 Reusable listeners cho Bloc/Cubit
///
/// Cung cấp các helper functions để listen state changes
/// và thực hiện side effects (toast, dialog, navigation, etc.)

/// Listen BaseState và tự động show SnackBar khi có error hoặc success
///
/// Example:
/// ```dart
/// listenBaseStateWithSnackBar<MyBloc, List<Item>>(
///   context: context,
///   listener: (context, state) {
///     // Additional logic
///   },
/// );
/// ```
BlocListener<B, BaseState<T>>
listenBaseStateWithSnackBar<B extends StateStreamable<BaseState<T>>, T>({
  required BuildContext context,
  void Function(BuildContext context, BaseState<T> state)? listener,
  Widget? child,
  bool showSuccessSnackBar = true,
  bool showErrorSnackBar = true,
}) {
  return BlocListener<B, BaseState<T>>(
    listener: (context, state) {
      // Custom listener
      listener?.call(context, state);

      // Show error snackbar
      if (showErrorSnackBar && state.isFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Đã xảy ra lỗi'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      }

      // Show success snackbar
      if (showSuccessSnackBar && state.isSuccess && state.message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      }
    },
    child: child ?? const SizedBox.shrink(),
  );
}

/// Listen BaseState và show Dialog khi có error
///
/// Example:
/// ```dart
/// listenBaseStateWithDialog<MyBloc, List<Item>>(
///   context: context,
///   errorTitle: 'Lỗi',
/// );
/// ```
BlocListener<B, BaseState<T>>
listenBaseStateWithDialog<B extends StateStreamable<BaseState<T>>, T>({
  required BuildContext context,
  String errorTitle = 'Lỗi',
  String successTitle = 'Thành công',
  void Function(BuildContext context, BaseState<T> state)? listener,
  Widget? child,
  bool showSuccessDialog = false,
  bool showErrorDialog = true,
}) {
  return BlocListener<B, BaseState<T>>(
    listener: (context, state) {
      listener?.call(context, state);

      // Show error dialog
      if (showErrorDialog && state.isFailure) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(errorTitle),
              content: Text(state.error ?? 'Đã xảy ra lỗi'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
              ],
            ),
          );
        });
      }

      // Show success dialog
      if (showSuccessDialog && state.isSuccess && state.message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(successTitle),
              content: Text(state.message!),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
              ],
            ),
          );
        });
      }
    },
    child: child ?? const SizedBox.shrink(),
  );
}

/// Listen và navigate khi success
///
/// Example:
/// ```dart
/// listenAndNavigateOnSuccess<MyBloc, Item>(
///   context: context,
///   route: '/home',
/// );
/// ```
BlocListener<B, BaseState<T>>
listenAndNavigateOnSuccess<B extends StateStreamable<BaseState<T>>, T>({
  required BuildContext context,
  String? route,
  Widget? page,
  bool replace = false,
  void Function(BuildContext context, T data)? onSuccess,
  Widget? child,
}) {
  return BlocListener<B, BaseState<T>>(
    listener: (context, state) {
      if (state.isSuccess && state.hasData) {
        onSuccess?.call(context, state.data as T);

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
      }
    },
    child: child ?? const SizedBox.shrink(),
  );
}

/// Listen và pop khi success
///
/// Example:
/// ```dart
/// listenAndPopOnSuccess<MyBloc, Item>(
///   context: context,
///   result: 'created',
/// );
/// ```
BlocListener<B, BaseState<T>> listenAndPopOnSuccess<B extends StateStreamable<BaseState<T>>, T>({
  required BuildContext context,
  Object? result,
  void Function(BuildContext context, T data)? onSuccess,
  Widget? child,
}) {
  return BlocListener<B, BaseState<T>>(
    listener: (context, state) {
      if (state.isSuccess) {
        if (state.hasData) {
          onSuccess?.call(context, state.data as T);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          Navigator.pop(context, result);
        });
      }
    },
    child: child ?? const SizedBox.shrink(),
  );
}

/// Listen loading state và show loading indicator
///
/// Example:
/// ```dart
/// listenLoadingState<MyBloc, List<Item>>(
///   context: context,
/// );
/// ```
BlocListener<B, BaseState<T>> listenLoadingState<B extends StateStreamable<BaseState<T>>, T>({
  required BuildContext context,
  void Function(bool isLoading)? onLoadingChanged,
  Widget? child,
}) {
  return BlocListener<B, BaseState<T>>(
    listener: (context, state) {
      onLoadingChanged?.call(state.isLoadingState);
    },
    child: child ?? const SizedBox.shrink(),
  );
}
