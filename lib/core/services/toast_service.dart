// ════════════════════════════════════════════════════════════════
// 📁 lib/core/services/toast_service.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

@LazySingleton()
class ToastService {
  // ═══════════════════════════════════════════════════════════════
  // SUCCESS TOAST
  // ═══════════════════════════════════════════════════════════════

  /// Show success toast
  /// Example: toast.success('Login successful!')
  ToastificationItem success(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle),
      primaryColor: Colors.green,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ERROR TOAST
  // ═══════════════════════════════════════════════════════════════

  /// Show error toast
  /// Example: toast.error('Login failed!')
  ToastificationItem error(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 4),
      icon: const Icon(Icons.error),
      primaryColor: Colors.red,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // WARNING TOAST
  // ═══════════════════════════════════════════════════════════════

  /// Show warning toast
  /// Example: toast.warning('Please check your input')
  ToastificationItem warning(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      icon: const Icon(Icons.warning_amber),
      primaryColor: Colors.orange,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // INFO TOAST
  // ═══════════════════════════════════════════════════════════════

  /// Show info toast
  /// Example: toast.info('New update available')
  ToastificationItem info(
    String message, {
    String? title,
    Duration? duration,
    BuildContext? context,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      icon: const Icon(Icons.info),
      primaryColor: Colors.blue,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CUSTOM TOAST
  // ═══════════════════════════════════════════════════════════════

  /// Show custom toast with full control
  /// Example:
  /// ```dart
  /// toast.custom(
  ///   message: 'Custom message',
  ///   title: 'Custom Title',
  ///   icon: Icons.star,
  ///   color: Colors.purple,
  /// )
  /// ```
  ToastificationItem custom({
    required String message,
    String? title,
    IconData? icon,
    Color? color,
    Duration? duration,
    Alignment? alignment,
    ToastificationStyle? style,
    BuildContext? context,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.info,
      style: style ?? ToastificationStyle.fillColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      alignment: alignment ?? Alignment.topRight,
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      icon: icon != null ? Icon(icon) : const Icon(Icons.notifications),
      primaryColor: color ?? Colors.blue,
      backgroundColor: color ?? Colors.blue,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LOADING TOAST (Without auto close)
  // ═══════════════════════════════════════════════════════════════

  /// Show loading toast (must manually dismiss)
  /// Example:
  /// ```dart
  /// final loadingToast = toast.loading('Processing...');
  /// // Do work
  /// toast.dismiss(loadingToast);
  /// ```
  ToastificationItem loading(
    String message, {
    String? title,
    BuildContext? context,
  }) {
    return toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: title != null ? Text(title) : null,
      description: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(days: 365), // Không tự đóng
      icon: const Icon(Icons.hourglass_empty),
      primaryColor: Colors.blue,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      closeOnClick: false,
      pauseOnHover: false,
      dragToClose: false,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DISMISS METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Dismiss a specific toast
  /// Example: toast.dismiss(toastItem)
  void dismiss(ToastificationItem item) {
    toastification.dismiss(item);
  }

  /// Dismiss all toasts
  /// Example: toast.dismissAll()
  void dismissAll() {
    toastification.dismissAll();
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Show toast from Exception
  /// Example: toast.fromException(e)
  ToastificationItem fromException(
    dynamic exception, {
    String? title,
    BuildContext? context,
  }) {
    String message = 'An error occurred';

    if (exception is Exception) {
      message = exception.toString().replaceAll('Exception: ', '');
    } else if (exception is Error) {
      message = exception.toString();
    } else {
      message = exception.toString();
    }

    return error(message, title: title ?? 'Error', context: context);
  }

  /// Show success with custom icon
  /// Example: toast.successWithIcon('Done!', Icons.check_circle_outline)
  ToastificationItem successWithIcon(
    String message,
    IconData icon, {
    String? title,
    BuildContext? context,
  }) {
    return custom(
      message: message,
      title: title,
      icon: icon,
      color: Colors.green,
      context: context,
    );
  }
}
