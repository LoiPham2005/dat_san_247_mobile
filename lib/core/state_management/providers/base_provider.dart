// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/providers/base_provider.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';

/// SMART & FLEXIBLE BaseProvider
abstract class BaseProvider<T> extends ChangeNotifier {
  BaseStatus _status = BaseStatus.initial;
  T? _data;
  String _error = '';
  String _message = '';

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════
  BaseStatus get status => _status;
  T? get data => _data;
  String get error => _error;
  String get message => _message;

  bool get isLoading => _status == BaseStatus.loading;
  bool get isRefreshing => _status == BaseStatus.refreshing;
  bool get isSubmitting => _status == BaseStatus.submitting;
  bool get hasData => _data != null;
  bool get hasError => _error.isNotEmpty;

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
    BaseStatus? customStatus,
    bool showLoading = true,
  }) async {
    final currentData = _data;
    final bool isRefreshingNow = currentData != null && !isSubmitting && !isLoading;

    // 1. Resolve configuration (Auto detect)
    final bool mutationMode = isMutation ?? (successMessage != null);
    final bool shouldPreserve = preserveData ?? (mutationMode || isRefreshingNow);
    final bool shouldCancel = cancelPrevious ?? !mutationMode;

    // 2. Handle cancellation
    if (shouldCancel) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    // 3. Update status (Loading/Submitting/Refreshing)
    if (!showLoading) {
      // Do nothing
    } else if (customStatus != null) {
      _status = customStatus;
    } else if (mutationMode) {
      _status = BaseStatus.submitting;
    } else if (isRefreshingNow) {
      _status = BaseStatus.refreshing;
    } else {
      _status = BaseStatus.loading;
      _data = null;
    }
    _error = '';
    _message = '';
    notifyListeners();

    try {
      final result = await action();

      // Kiểm tra nếu đã bị cancel
      if (isCancelled && !mutationMode) return null;

      // 4. Handle success/failure
      return result.fold(
        onSuccess: (data) {
          if (mutationMode) {
            _status = BaseStatus.success;
            _message = successMessage ?? 'Thành công';
          } else {
            if (data is List && (data as List).isEmpty) {
              _status = BaseStatus.empty;
            } else {
              _status = BaseStatus.loaded;
            }
          }
          _data = data;
          _error = '';
          notifyListeners();
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          _status = BaseStatus.failure;
          _error = failure.message;
          if (!shouldPreserve) _data = null;
          notifyListeners();
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseProvider: Execute failed', error: e, stackTrace: stackTrace);

      _status = BaseStatus.failure;
      _error = e.toString();
      if (!shouldPreserve) _data = null;
      notifyListeners();
      onFailure?.call(UnknownFailure(message: e.toString()));
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
    _status = BaseStatus.initial;
    _data = null;
    _error = '';
    _message = '';
    notifyListeners();
  }

  @override
  void dispose() {
    cancelCurrentOperation();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // 🔓 FLEXIBLE EXECUTE (No Rules)
  // ════════════════════════════════════════════════════════════

  /// [RUN] Execute any logic freely.
  Future<void> run({
    required Future<void> Function() action,
    BaseStatus? loadingStatus,
    void Function()? onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool showLog = true,
  }) async {
    if (loadingStatus != null) {
      _status = loadingStatus;
      notifyListeners();
    }
    try {
      await action();
      onSuccess?.call();
    } catch (e, stackTrace) {
      if (showLog) {
        Logger.error('BaseProvider: execution failed', error: e, stackTrace: stackTrace);
      }
      onError?.call(e, stackTrace);
    }
  }
}
