// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/base_async_notifier.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// SMART & FLEXIBLE BaseAsyncNotifier for Riverpod
abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  // Additional states not covered by AsyncValue
  String? _message;
  bool _isRefreshing = false;
  bool _isSubmitting = false;

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════
  String? get message => _message;
  bool get isRefreshing => _isRefreshing;
  bool get isSubmitting => _isSubmitting;
  bool get isLoading => state is AsyncLoading;

  T? get data => state.whenOrNull(data: (d) => d);
  Failure? get failure => state.whenOrNull(error: (e, _) => e is Failure ? e : null);

  /// 🎯 Mapping AsyncValue to unified BaseStatus
  BaseStatus get status {
    return state.when(
      data: (d) {
        if (_isSubmitting) return BaseStatus.submitting;
        if (_isRefreshing) return BaseStatus.refreshing;
        if (d is List && d.isEmpty) return BaseStatus.empty;
        return BaseStatus.loaded;
      },
      error: (e, _) {
        if (_isSubmitting || _isRefreshing) return BaseStatus.failure;
        return BaseStatus.failure;
      },
      loading: () => BaseStatus.loading,
    );
  }

  /// Hủy operation hiện tại (chỉ áp dụng cho Query)
  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  // ════════════════════════════════════════════════════════════
  // 🎯 SMART EXECUTE
  // ════════════════════════════════════════════════════════════

  /// [QUERY] Use for fetching data (GET)
  Future<T?> onQuery({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    bool cancelPrevious = true,
    bool preserveData = false,
  }) {
    return execute(
      action: action,
      onSuccess: onSuccess,
      onFailure: onFailure,
      isMutation: false,
      cancelPrevious: cancelPrevious,
      preserveData: preserveData,
    );
  }

  /// [MUTATION] Use for changing data (POST, PUT, DELETE)
  Future<T?> onMutation({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,
    bool showLoading = true,
  }) {
    return execute(
      action: action,
      onSuccess: onSuccess,
      onFailure: onFailure,
      successMessage: successMessage,
      isMutation: true,
      cancelPrevious: false,
      showLoading: showLoading,
    );
  }

  Future<T?> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,
    bool? isMutation,
    bool? preserveData,
    bool? cancelPrevious,
    AsyncValue<T>? customLoadingState,
    bool showLoading = true, // Control loading state
  }) async {
    final currentData = data;
    final bool isRefreshingNow = currentData != null && !_isSubmitting && !isLoading;

    // 1. Resolve configuration (Auto detect)
    final bool mutationMode = isMutation ?? (successMessage != null);
    final bool shouldPreserve = preserveData ?? (mutationMode || isRefreshingNow);
    final bool shouldCancel = cancelPrevious ?? !mutationMode;

    // 2. Handle cancellation
    if (shouldCancel) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    // 3. Update internal loading flags & state
    if (!showLoading) {
      // Do nothing
    } else if (customLoadingState != null) {
      state = customLoadingState;
    } else if (mutationMode) {
      _isSubmitting = true;
    } else if (isRefreshingNow) {
      _isRefreshing = true;
    } else {
      state = const AsyncLoading();
    }
    _message = null;

    try {
      final result = await action();

      // Kiểm tra nếu đã bị cancel
      if (isCancelled && !mutationMode) return null;

      // 4. Handle success/failure
      return result.fold(
        onSuccess: (data) {
          _isSubmitting = false;
          _isRefreshing = false;

          if (mutationMode) {
            _message = successMessage ?? 'Thành công';
          }

          state = AsyncData(data);
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          _isSubmitting = false;
          _isRefreshing = false;

          if (shouldPreserve && currentData != null) {
            state = AsyncData(currentData);
          } else {
            state = AsyncError(failure, StackTrace.current);
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseAsyncNotifier: Execute failed', error: e, stackTrace: stackTrace);

      _isSubmitting = false;
      _isRefreshing = false;

      final unknownFailure = UnknownFailure(message: e.toString());

      if (shouldPreserve && currentData != null) {
        state = AsyncData(currentData);
      } else {
        state = AsyncError(unknownFailure, stackTrace);
      }
      onFailure?.call(unknownFailure);
      return null;
    } finally {
      if (!mutationMode) _currentOperation = null;
    }
  }

  // ════════════════════════════════════════════════════════════
  // Utility Methods
  // ════════════════════════════════════════════════════════════

  void reset() {
    cancelCurrentOperation();
    _message = null;
    _isRefreshing = false;
    _isSubmitting = false;
    ref.invalidateSelf();
  }

  // ════════════════════════════════════════════════════════════
  // 🔓 FLEXIBLE EXECUTE (No Rules)
  // ════════════════════════════════════════════════════════════

  /// [RUN] Execute any logic freely.
  Future<void> run({
    required Future<void> Function() action,
    AsyncValue<T>? loadingState,
    void Function()? onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool showLog = true,
  }) async {
    if (loadingState != null) state = loadingState;
    try {
      await action();
      onSuccess?.call();
    } catch (e, stackTrace) {
      if (showLog) {
        Logger.error('BaseAsyncNotifier: execution failed', error: e, stackTrace: stackTrace);
      }
      onError?.call(e, stackTrace);
    }
  }
}
