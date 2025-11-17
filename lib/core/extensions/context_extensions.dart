// ════════════════════════════════════════════════════════════════
// 📁 lib/extensions/context_extensions.dart (SỬ DỤNG CHÍNH)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  // MEDIAQUERY & RESPONSIVE (giữ nguyên)
  // ═══════════════════════════════════════════════════════════════

  // MediaQueryData get mediaQuery => MediaQuery.of(this);
  // Size get screenSize => mediaQuery.size;
  // double get screenWidth => screenSize.width;
  // double get screenHeight => screenSize.height;
  // double get statusBarHeight => mediaQuery.padding.top;
  // double get bottomBarHeight => mediaQuery.padding.bottom;
  // Orientation get orientation => mediaQuery.orientation;
  // bool get isLandscape => orientation == Orientation.landscape;
  // bool get isPortrait => orientation == Orientation.portrait;

  // bool get isMobile => screenWidth < 600;
  // bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  // bool get isDesktop => screenWidth >= 900;

  // ═══════════════════════════════════════════════════════════════
  // NAVIGATION (⭐ SỬ DỤNG CHÍNH - 95% cases)
  // ═══════════════════════════════════════════════════════════════

  // NavigatorState get navigator => Navigator.of(this);

  // /// Pop current route
  // void pop<T>([T? result]) => Navigator.of(this).pop(result);

  // /// Push new page
  // Future<T?> push<T>(Widget page) {
  //   return Navigator.of(this).push<T>(
  //     MaterialPageRoute(builder: (_) => page),
  //   );
  // }

  // /// Push named route
  // Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
  //   return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  // }

  // /// Push and replace current
  // Future<T?> pushReplacement<T, TO>(Widget page, {TO? result}) {
  //   return Navigator.of(this).pushReplacement<T, TO>(
  //     MaterialPageRoute(builder: (_) => page),
  //     result: result,
  //   );
  // }

  // /// Push and remove all until predicate
  // Future<T?> pushAndRemoveUntil<T>(
  //   Widget page,
  //   bool Function(Route<dynamic>) predicate,
  // ) {
  //   return Navigator.of(this).pushAndRemoveUntil<T>(
  //     MaterialPageRoute(builder: (_) => page),
  //     predicate,
  //   );
  // }

  // /// Pop until predicate
  // void popUntil(bool Function(Route<dynamic>) predicate) {
  //   Navigator.of(this).popUntil(predicate);
  // }

  // /// Pop to root
  // void popToRoot() {
  //   Navigator.of(this).popUntil((route) => route.isFirst);
  // }

  // /// Check if can pop
  // bool canPop() => Navigator.of(this).canPop();





  // ═══════════════════════════════════════════════════════════════
  // GoRouter Methods (95% use cases)
  // ═══════════════════════════════════════════════════════════════

  // /// Navigate to a route by path
  // void goTo(String path, {Object? extra}) => go(path, extra: extra);

  // /// Navigate to a route by name
  // void goToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
  //   goNamed(name, pathParameters: pathParameters ?? {}, queryParameters: queryParameters ?? {}, extra: extra);
  // }

  // /// Push a new route
  // void pushTo(String path, {Object? extra}) => push(path, extra: extra);

  // /// Push by name
  // void pushToNamed(String name, {Map<String, String>? pathParameters, Map<String, dynamic>? queryParameters, Object? extra}) {
  //   pushNamed(name, pathParameters: pathParameters ?? {}, queryParameters: queryParameters ?? {}, extra: extra);
  // }

  // /// Replace current route
  // void replaceTo(String path, {Object? extra}) => replace(path, extra: extra);

  // /// Pop current route
  // void goBack<T>([T? result]) => pop(result);

  // /// Check if can pop
  // bool canGoBack() => canPop();

  // /// Pop to root
  // void popToRoot() {
  //   while (canPop()) {
  //     pop();
  //   }
  // }


  // ═══════════════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════════════

  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
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
          TextButton(
            onPressed: () => pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => pop(true),
            child: Text(confirmText),
          ),
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
        actions: [
          TextButton(
            onPressed: () => pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showCustomDialog(
      child: AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 48),
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => pop(),
            child: const Text('OK'),
          ),
        ],
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
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
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
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
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
}
