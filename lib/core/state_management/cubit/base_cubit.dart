// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/cubit/base_cubit.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// SMART & FLEXIBLE BaseCubit
///
/// Tăng cường khả năng xử lý state tự động:
/// - Tự động phát hiện Mutation (POST/PUT/DELETE) nếu có successMessage.
/// - Tự động phát hiện Refresh nếu đang có data.
/// - Tự động hủy (cancel) các request Query cũ nếu có request mới.
/// - Giữ lại data cũ (Preserve Data) khi có lỗi xảy ra trong quá trình Mutation/Refresh.
abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit([BaseState<T>? initialState]) : super(initialState ?? BaseState<T>.initial());

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  /// Hủy operation hiện tại (chỉ áp dụng cho Query)
  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  /// Emit state an toàn (check isClosed)
  void safeEmit(BaseState<T> newState) {
    if (!isClosed) emit(newState);
  }

  // ════════════════════════════════════════════════════════════
  // 🎯 SMART EXECUTE
  // ════════════════════════════════════════════════════════════

  /// [QUERY] Use for fetching data (GET)
  /// - Default: cancelPrevious = true (cancel old requests)
  /// - Default: isMutation = false
  Future<T?> onQuery({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    bool cancelPrevious = true, // Cancel old queries by default
    bool preserveData = false, // Show loading, hide old data (optional)
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
  /// - Default: cancelPrevious = false (allow parallel mutations)
  /// - Default: isMutation = true
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

  /// Thực thi một action Async và quản lý toàn bộ vòng đời state.
  ///
  /// [action]: Hàm thực thi UseCase trả về Result.
  /// [isMutation]: Ép buộc là mutation (Submitting) thay vì query (Loading).
  /// [preserveData]: Ép buộc giữ data cũ khi lỗi.
  /// [cancelPrevious]: Ép buộc hủy request trước đó (mặc định true cho Query, false cho Mutation).
  Future<T?> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,
    bool? isMutation,
    bool? preserveData,
    bool? cancelPrevious,
    BaseState<T>? customLoadingState,
    bool showLoading = true, // Control loading state
  }) async {
    final currentData = state.data;
    final bool isRefreshing = currentData != null && !state.isSubmitting && !state.isLoading;

    // 1. Resolve configuration (Auto detect)
    final bool mutationMode = isMutation ?? (successMessage != null);
    final bool shouldPreserve = preserveData ?? (mutationMode || isRefreshing);
    final bool shouldCancel = cancelPrevious ?? !mutationMode;

    // 2. Handle cancellation
    if (shouldCancel) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    // 3. Emit Loading/Submitting/Refreshing state
    if (!showLoading) {
      // Do nothing
    } else if (customLoadingState != null) {
      safeEmit(customLoadingState);
    } else if (mutationMode) {
      safeEmit(BaseState.submitting(data: currentData));
    } else if (isRefreshing) {
      safeEmit(BaseState.refreshing(currentData: currentData));
    } else {
      safeEmit(BaseState.loading(previousData: null));
    }

    try {
      final result = await action();

      // Kiểm tra nếu đã bị cancel (chỉ reset flag cho query)
      if (isCancelled && !mutationMode) return null;

      // 4. Handle success/failure
      return result.fold(
        onSuccess: (data) {
          if (mutationMode) {
            safeEmit(BaseState.success(data: data, message: successMessage ?? 'Thành công'));
          } else {
            if (data is List && (data as List).isEmpty) {
              safeEmit(BaseState.empty());
            } else {
              final newState = BaseState.loaded(data);
              safeEmit(isRefreshing ? newState.resetRetry() : newState);
            }
          }
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          safeEmit(
            BaseState.failure(
              error: failure.message,
              previousData: shouldPreserve ? currentData : null,
            ),
          );
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseCubit: Execute failed', error: e, stackTrace: stackTrace);

      safeEmit(
        BaseState.failure(
          error: e.toString(),
          previousData: shouldPreserve ? currentData : null,
          stackTrace: stackTrace,
        ),
      );
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      if (!mutationMode) _currentOperation = null;
    }
  }

  /// Thực thi pagination (load more)
  ///
  /// [action]: Phải trả về List đã được merge hoặc thông tin phân trang mới.
  Future<T?> executePagination({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    final currentData = state.data;
    if (currentData == null) return execute(action: action);

    safeEmit(BaseState.loadingMore(currentData: currentData));

    try {
      final result = await action();
      return result.fold(
        onSuccess: (data) {
          safeEmit(BaseState.loaded(data));
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          safeEmit(BaseState.failure(error: failure.message, previousData: currentData));
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e) {
      safeEmit(BaseState.failure(error: e.toString(), previousData: currentData));
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    }
  }

  // ════════════════════════════════════════════════════════════
  // Utility Methods
  // ════════════════════════════════════════════════════════════

  void reset() {
    cancelCurrentOperation();
    safeEmit(BaseState.initial());
  }

  void updateData(T data) => safeEmit(BaseState.loaded(data));
  void setEmpty({String? message}) => safeEmit(BaseState.empty(message: message));

  @override
  Future<void> close() {
    cancelCurrentOperation();
    return super.close();
  }

  // ════════════════════════════════════════════════════════════
  // 🔓 FLEXIBLE EXECUTE (No Rules)
  // ════════════════════════════════════════════════════════════

  /// [RUN] Execute any logic freely.
  Future<void> run({
    required Future<void> Function() action,
    BaseState<T>? loadingState,
    void Function()? onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool showLog = true,
  }) async {
    if (loadingState != null) safeEmit(loadingState);
    try {
      await action();
      onSuccess?.call();
    } catch (e, stackTrace) {
      if (showLog) {
        Logger.error('BaseCubit: execution failed', error: e, stackTrace: stackTrace);
      }
      onError?.call(e, stackTrace);
    }
  }
}
