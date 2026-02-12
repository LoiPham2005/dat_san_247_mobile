// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/getx/base_controller.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:get/get.dart';

/// SMART & FLEXIBLE BaseController for GetX
abstract class BaseController<T> extends GetxController {
  // ════════════════════════════════════════════════════════════
  // Reactive States
  // ════════════════════════════════════════════════════════════
  final Rx<BaseStatus> _status = BaseStatus.initial.obs;
  final Rx<T?> _data = Rx<T?>(null);
  final RxString _error = ''.obs;
  final RxString _message = ''.obs;

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════
  BaseStatus get status => _status.value;
  T? get data => _data.value;
  String get error => _error.value;
  String get message => _message.value;

  bool get isLoading => _status.value == BaseStatus.loading;
  bool get isRefreshing => _status.value == BaseStatus.refreshing;
  bool get isSubmitting => _status.value == BaseStatus.submitting;
  bool get hasData => _data.value != null;
  bool get hasError => _error.value.isNotEmpty;

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
    bool showLoading = true, // Control loading state
  }) async {
    final currentData = _data.value;
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
      _status.value = customStatus;
    } else if (mutationMode) {
      _status.value = BaseStatus.submitting;
    } else if (isRefreshingNow) {
      _status.value = BaseStatus.refreshing;
    } else {
      _status.value = BaseStatus.loading;
      _data.value = null; // Reset data cho fresh load
    }
    _error.value = '';
    _message.value = '';

    try {
      final result = await action();

      // Kiểm tra nếu đã bị cancel
      if (isCancelled && !mutationMode) return null;

      // 4. Handle success/failure
      return result.fold(
        onSuccess: (data) {
          if (mutationMode) {
            _status.value = BaseStatus.success;
            _message.value = successMessage ?? 'Thành công';
          } else {
            if (data is List && (data as List).isEmpty) {
              _status.value = BaseStatus.empty;
            } else {
              _status.value = BaseStatus.loaded;
            }
          }
          _data.value = data;
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          _status.value = BaseStatus.failure;
          _error.value = failure.message;
          if (!shouldPreserve) _data.value = null;
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseController: Execute failed', error: e, stackTrace: stackTrace);

      _status.value = BaseStatus.failure;
      _error.value = e.toString();
      if (!shouldPreserve) _data.value = null;
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
    _status.value = BaseStatus.initial;
    _data.value = null;
    _error.value = '';
    _message.value = '';
  }

  @override
  void onClose() {
    cancelCurrentOperation();
    super.onClose();
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
    if (loadingStatus != null) _status.value = loadingStatus;
    try {
      await action();
      onSuccess?.call();
    } catch (e, stackTrace) {
      if (showLog) {
        Logger.error('BaseController: execution failed', error: e, stackTrace: stackTrace);
      }
      onError?.call(e, stackTrace);
    }
  }
}
