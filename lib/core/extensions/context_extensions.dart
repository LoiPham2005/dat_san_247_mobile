// ════════════════════════════════════════════════════════════════
// 📁 lib/extensions/context_extensions.dart (SỬ DỤNG CHÍNH)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/services/toast_service.dart';
import 'package:dat_san_247_mobile/core/state_management/auth/auth_cubit.dart';
import 'package:dat_san_247_mobile/core/state_management/auth/auth_state.dart';
import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';
import 'package:dat_san_247_mobile/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

/// 🌍 Global BuildContext - CHỈ DÙNG KHI KHÔNG CÓ CONTEXT
BuildContext get appContext {
  final ctx = getIt<AppRouter>().router.routerDelegate.navigatorKey.currentContext;
  assert(ctx != null, '⛔ appContext is null!');
  return ctx!;
}

BuildContext? get appContextOrNull =>
    getIt<AppRouter>().router.routerDelegate.navigatorKey.currentContext;

extension ContextExtensions on BuildContext {
  // ═══════════════════════════════════════════════════════════════
  // THEME & COLORS (giữ nguyên)
  // ═══════════════════════════════════════════════════════════════

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get primaryColor => Theme.of(this).primaryColor;
  Color get accentColor => Theme.of(this).colorScheme.secondary;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(this).cardColor;

  // ═══════════════════════════════════════════════════════════════
  // TEXT STYLES (giữ nguyên)
  // ═══════════════════════════════════════════════════════════════

  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  // ═══════════════════════════════════════════════════════════════
  // NAVIGATION (⭐ SỬ DỤNG CHÍNH - 95% cases)
  // ═══════════════════════════════════════════════════════════════

  NavigatorState get nav => Navigator.of(this);

  /// Push widget page with MaterialPageRoute
  /// Example: context.navPush(DetailsPage())
  Future<T?> navPush<T>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Push with custom route
  /// Example: context.navPushRoute(customRoute)
  Future<T?> navPushRoute<T>(Route<T> route) {
    return Navigator.of(this).push<T>(route);
  }

  /// Push and replace current
  /// Example: context.navReplace(HomePage())
  Future<T?> navReplace<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(
      this,
    ).pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page), result: result);
  }

  /// Push and remove all until predicate
  /// Example: context.navPushAndClear(HomePage(), (route) => false)
  Future<T?> navPushAndClear<T>(Widget page, bool Function(Route<dynamic>) predicate) {
    return Navigator.of(
      this,
    ).pushAndRemoveUntil<T>(MaterialPageRoute(builder: (_) => page), predicate);
  }

  /// Push and clear all (go to root with new page)
  /// Example: context.navPushAndRemoveAll(LoginPage())
  Future<T?> navPushAndRemoveAll<T>(Widget page) {
    return navPushAndClear<T>(page, (route) => false);
  }

  /// Pop current route (Navigator)
  /// Example: context.navPop()
  void navPop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Pop until predicate
  /// Example: context.navPopUntil((route) => route.isFirst)
  void navPopUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// Pop to root (first route)
  /// Example: context.navPopToRoot()
  void navPopToRoot() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  /// Check if can pop (Navigator)
  bool get canNavPop => Navigator.of(this).canPop();

  // ═══════════════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════════════

  Future<T?> showCustomDialog<T>({required Widget child, bool barrierDismissible = true}) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }

  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
  }) {
    return showDialog<bool>(
      context: this,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => pop(false), child: Text(cancelText)),
          TextButton(onPressed: () => pop(true), child: Text(confirmText)),
        ],
      ),
    );
  }

  void showSuccessDialog(String message) {
    showCustomDialog(
      child: AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Thành công'),
        content: Text(message),
        actions: [TextButton(onPressed: () => pop(), child: const Text('OK'))],
      ),
    );
  }

  void showErrorDialog(String message) {
    showCustomDialog(
      child: AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 48),
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [TextButton(onPressed: () => pop(), child: const Text('OK'))],
      ),
    );
  }

  void showLoadingDialog({String? message}) {
    showCustomDialog(
      barrierDismissible: false,
      child: PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[const SizedBox(height: 16), Text(message)],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void hideDialog() => pop();

  // ═══════════════════════════════════════════════════════════════
  // BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════

  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      builder: (_) => child,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SNACKBAR
  // ═══════════════════════════════════════════════════════════════

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[Icon(icon, color: Colors.white), const SizedBox(width: 12)],
            Expanded(child: Text(message)),
          ],
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
      duration: const Duration(seconds: 3),
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: const Duration(seconds: 2),
    );
  }

  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber,
      duration: const Duration(seconds: 3),
    );
  }

  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info_outline,
      duration: const Duration(seconds: 2),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FOCUS & KEYBOARD
  // ═══════════════════════════════════════════════════════════════

  void unfocus() => FocusScope.of(this).unfocus();
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ═══════════════════════════════════════════════════════════════
  // AUTH (⭐ NEW)
  // ═══════════════════════════════════════════════════════════════

  /// Access global AuthCubit
  AuthCubit get authCubit => read<AuthCubit>();

  /// Watch global AuthState
  AuthState get authState => watch<AuthCubit>().state;

  /// Get current authenticated user
  AuthUser? get currentUser => authState.user;

  /// Check if user is authenticated
  bool get isAuthenticated => authState.isAuthenticated;
}

// Thêm extension này vào cuối file ContextExtensions
extension ContextToastExtensions on BuildContext {
  // ═══════════════════════════════════════════════════════════════
  // TOAST SHORTCUTS (Ultra Easy!)
  // ═══════════════════════════════════════════════════════════════

  ToastService get toast => getIt<ToastService>();

  /// Show success toast
  /// Example: context.showSuccess('Login successful!')
  ToastificationItem showSuccess(String message, {String? title, Duration? duration}) {
    return toast.success(message, title: title, duration: duration, context: this);
  }

  /// Show error toast
  /// Example: context.showError('Login failed!')
  ToastificationItem showError(String message, {String? title, Duration? duration}) {
    return toast.error(message, title: title, duration: duration, context: this);
  }

  /// Show warning toast
  /// Example: context.showWarning('Please check your input')
  ToastificationItem showWarning(String message, {String? title, Duration? duration}) {
    return toast.warning(message, title: title, duration: duration, context: this);
  }

  /// Show info toast
  /// Example: context.showInfo('New update available')
  ToastificationItem showInfo(String message, {String? title, Duration? duration}) {
    return toast.info(message, title: title, duration: duration, context: this);
  }

  /// Show loading toast
  /// Example:
  /// ```dart
  /// final loading = context.showLoading('Processing...');
  /// await doWork();
  /// context.dismissToast(loading);
  /// ```
  ToastificationItem showLoading(String message, {String? title}) {
    return toast.loading(message, title: title, context: this);
  }

  /// Show custom toast
  /// Example:
  /// ```dart
  /// context.showCustomToast(
  ///   message: 'Custom',
  ///   icon: Icons.star,
  ///   color: Colors.purple,
  /// )
  /// ```
  ToastificationItem showCustomToast({
    required String message,
    String? title,
    IconData? icon,
    Color? color,
    Duration? duration,
  }) {
    return toast.custom(
      message: message,
      title: title,
      icon: icon,
      color: color,
      duration: duration,
      context: this,
    );
  }

  /// Dismiss specific toast
  /// Example: context.dismissToast(toastItem)
  void dismissToast(ToastificationItem item) {
    toast.dismiss(item);
  }

  /// Dismiss all toasts
  /// Example: context.dismissAllToasts()
  void dismissAllToasts() {
    toast.dismissAll();
  }

  /// Show toast from exception
  /// Example: context.showException(error)
  ToastificationItem showException(dynamic exception, {String? title}) {
    return toast.fromException(exception, title: title, context: this);
  }
}
