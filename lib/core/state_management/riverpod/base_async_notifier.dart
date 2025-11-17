// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/base_async_notifier.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base_template/core/errors/failures.dart';
import 'package:flutter_base_template/core/errors/result.dart';

/// BaseAsyncNotifier cho Riverpod
abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  /// Thực thi UseCase với full Failure object
  /// 
  /// Example:
  /// ```dart
  /// await executeUseCase(
  ///   action: () => getUserUseCase(userId),
  ///   onSuccess: (user) => ref.read(routerProvider).go('/home'),
  ///   onFailure: (failure) {
  ///     if (failure is AuthenticationFailure) {
  ///       ref.read(authProvider.notifier).logout();
  ///     }
  ///   },
  /// );
  /// ```
  Future<void> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure, // ✅ Full Failure object
    bool showLoading = true,
  }) async {
    if (showLoading) {
      state = const AsyncLoading();
    }

    try {
      final result = await action();

      result.fold(
        onSuccess: (data) {
          state = AsyncData(data);
          onSuccess?.call(data);
        },
        onFailure: (failure) {
          // ✅ Store failure as error in AsyncValue
          state = AsyncError(failure, StackTrace.current);
          onFailure?.call(failure); // ✅ Pass Failure object
        },
      );
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
      onFailure?.call(const UnknownFailure(message: 'Đã xảy ra lỗi không xác định'));
    }
  }

  /// Version đơn giản với String message
  Future<void> executeWithMessage({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(String message)? onFailure, // ✅ Rõ ràng là message
    bool showLoading = true,
  }) async {
    if (showLoading) {
      state = const AsyncLoading();
    }

    try {
      final result = await action();

      result.fold(
        onSuccess: (data) {
          state = AsyncData(data);
          onSuccess?.call(data);
        },
        onFailure: (failure) {
          final message = failure.message;
          state = AsyncError(message, StackTrace.current);
          onFailure?.call(message);
        },
      );
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
      onFailure?.call('Đã xảy ra lỗi không xác định');
    }
  }

  /// Helpers
  bool get isLoading => state is AsyncLoading;
  bool get hasError => state is AsyncError;
  bool get hasData => state is AsyncData;
  
  /// Get error as Failure if possible
  Failure? get failure {
    final error = state.error;
    if (error is Failure) return error;
    return null;
  }
}