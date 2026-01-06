import 'package:flutter/material.dart';

/// Base StatefulWidget với các tiện ích
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

/// Base State với các tiện ích
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Lấy Theme
  ThemeData get theme => Theme.of(context);

  /// Lấy ColorScheme
  ColorScheme get colors => Theme.of(context).colorScheme;

  /// Lấy TextTheme
  TextTheme get textTheme => Theme.of(context).textTheme;

  /// Screen size
  Size get screenSize => MediaQuery.of(context).size;

  /// Is dark mode
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  /// Safe setState
  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  /// Set loading state
  void setLoading(bool value) {
    safeSetState(() => _isLoading = value);
  }

  /// Set error message
  void setError(String? message) {
    safeSetState(() => _errorMessage = message);
  }

  /// Clear error
  void clearError() => setError(null);

  /// Execute async action với loading state
  Future<R?> executeAsync<R>(
    Future<R> Function() action, {
    bool showLoading = true,
    void Function(R result)? onSuccess,
    void Function(dynamic error)? onError,
  }) async {
    try {
      if (showLoading) setLoading(true);
      clearError();

      final result = await action();
      onSuccess?.call(result);
      return result;
    } catch (e) {
      setError(e.toString());
      onError?.call(e);
      return null;
    } finally {
      if (showLoading) setLoading(false);
    }
  }
}
