// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/provider/base_provider.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';

/// BaseProvider cho Provider pattern
class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Thực thi UseCase với full Failure object
  Future<void> execute<T>({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure, // ✅ Full Failure object
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
      }

      final result = await action();

      result.fold(
        onSuccess: (data) {
          _errorMessage = null;
          onSuccess?.call(data);
        },
        onFailure: (failure) {
          _errorMessage = failure.message;
          onFailure?.call(failure); // ✅ Pass Failure object
        },
      );
    } catch (exception) {
      const unknownFailure = UnknownFailure(message: 'Đã xảy ra lỗi không xác định');
      _errorMessage = unknownFailure.message;
      onFailure?.call(unknownFailure);
    } finally {
      if (showLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Version đơn giản với String message
  Future<void> executeWithMessage<T>({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(String message)? onFailure, // ✅ Rõ ràng là message
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
      }

      final result = await action();

      result.fold(
        onSuccess: (data) {
          _errorMessage = null;
          onSuccess?.call(data);
        },
        onFailure: (failure) {
          final message = failure.message;
          _errorMessage = message;
          onFailure?.call(message);
        },
      );
    } catch (exception) {
      const message = 'Đã xảy ra lỗi không xác định';
      _errorMessage = message;
      onFailure?.call(message);
    } finally {
      if (showLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
