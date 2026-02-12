// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/base_bloc.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// SMART & FLEXIBLE BaseBloc
abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc([BaseState? initialState]) : super(initialState ?? BaseState.initial());

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

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
  /// - Default: cancelPrevious = true (cancel old requests)
  /// - Default: isMutation = false
  Future<T?> onQuery<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    bool cancelPrevious = true, // Cancel old queries by default
    bool preserveData = false, // Show loading, hide old data (optional)
  }) {
    return execute<T>(
      emit: emit,
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
  Future<T?> onMutation<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,
    bool showLoading = true,
  }) {
    return execute<T>(
      emit: emit,
      action: action,
      onSuccess: onSuccess,
      onFailure: onFailure,
      successMessage: successMessage,
      isMutation: true,
      cancelPrevious: false,
      showLoading: showLoading,
    );
  }

  /// [CORE] Execute async action with full lifecycle management
  Future<T?> execute<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,
    bool? isMutation,
    bool? preserveData,
    bool? cancelPrevious,
    BaseState? customLoadingState,
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
      emit(customLoadingState);
    } else if (mutationMode) {
      emit(BaseState.submitting(data: currentData));
    } else if (isRefreshing) {
      emit(BaseState.refreshing(currentData: currentData));
    } else {
      emit(BaseState.loading(previousData: null));
    }

    try {
      final result = await action();

      // Kiểm tra nếu đã bị cancel
      if (isCancelled && !mutationMode) return null;

      // 4. Handle success/failure
      return result.fold(
        onSuccess: (data) {
          if (emit.isDone) return data;

          if (mutationMode) {
            emit(BaseState.success(data: data, message: successMessage ?? 'Thành công'));
          } else {
            if (data is List && (data as List).isEmpty) {
              emit(BaseState.empty());
            } else {
              final newState = BaseState.loaded(data);
              emit(isRefreshing ? newState.resetRetry() : newState);
            }
          }
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          if (!emit.isDone) {
            emit(
              BaseState.failure(
                error: failure.message,
                previousData: shouldPreserve ? currentData : null,
              ),
            );
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseBloc: Execute failed', error: e, stackTrace: stackTrace);

      if (!emit.isDone) {
        emit(
          BaseState.failure(
            error: e.toString(),
            previousData: shouldPreserve ? currentData : null,
            stackTrace: stackTrace,
          ),
        );
      }
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      if (!mutationMode) _currentOperation = null;
    }
  }

  /// Thực thi pagination (load more)
  Future<T?> executePagination<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    final currentData = state.data;
    if (currentData == null) {
      return execute(emit: emit, action: action);
    }

    emit(BaseState.loadingMore(currentData: currentData));

    try {
      final result = await action();
      return result.fold(
        onSuccess: (data) {
          if (!emit.isDone) emit(BaseState.loaded(data));
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          if (!emit.isDone) {
            emit(BaseState.failure(error: failure.message, previousData: currentData));
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(BaseState.failure(error: e.toString(), previousData: currentData));
      }
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    }
  }

  @override
  Future<void> close() {
    cancelCurrentOperation();
    return super.close();
  }

  // ════════════════════════════════════════════════════════════
  // 🔓 FLEXIBLE EXECUTE (No Rules)
  // ════════════════════════════════════════════════════════════

  /// [RUN] Execute any logic freely without [Result] pattern.
  /// Useful for complex scenarios where you want manual control.
  Future<void> run({
    required Emitter<BaseState> emit,
    required Future<void> Function() action,
    BaseState? loadingState,
    void Function()? onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool showLog = true,
  }) async {
    if (loadingState != null) emit(loadingState);
    try {
      await action();
      onSuccess?.call();
    } catch (e, stackTrace) {
      if (showLog) {
        Logger.error('BaseBloc: execution failed', error: e, stackTrace: stackTrace);
      }
      onError?.call(e, stackTrace);
    }
  }
}
