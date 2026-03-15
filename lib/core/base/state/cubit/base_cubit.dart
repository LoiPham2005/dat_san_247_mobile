import 'dart:async';

import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../errors/failures.dart';
import '../../errors/result.dart';
import '../bloc/base_state.dart';

/// 🎯 MINIMAL & POWERFUL BaseCubit
///
/// Hỗ trợ:
/// - Auto cancel operation cũ khi là Mutation (successMessage != null)
/// - safeEmit() — không emit khi đã closed
/// - run<R>() — core method với loading/success/failure handling
/// - runPagination() — giữ data cũ khi loading trang mới
/// - reset() — về initial state
abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit([BaseState<T>? initialState])
    : super(initialState ?? BaseState<T>.initial());

  Completer<void>? _currentOperation;

  /// Hủy operation đang chạy (nếu có)
  void cancel() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  /// Emit an toàn — bỏ qua nếu cubit đã closed
  void safeEmit(BaseState<T> newState) {
    if (!isClosed) emit(newState);
  }

  /// 🚀 Core run
  ///
  /// - [R] — kiểu dữ liệu trả về từ API (Response)
  /// - [T] — kiểu dữ liệu state của Cubit
  /// - [successMessage] != null → Mutation (create/update/delete): cancel operation cũ
  /// - [successMessage] == null → Query (fetch data): không cancel, override tự nhiên
  Future<T?> run<R>({
    required Future<Result<R>> Function() action,
    T Function(R data)? mapper,
    void Function(R data)? onSuccess,
    void Function(Failure failure)? onFailure,
    BaseState<T>? loadingState,
    String? successMessage,
  }) async {
    // Cancel operation cũ nếu là Mutation
    if (successMessage != null || loadingState != null) cancel();
    _currentOperation = Completer<void>();

    safeEmit(loadingState ?? BaseState.loading(previousData: state.data));

    try {
      final result = await action();

      // Nếu đã bị cancel → bỏ qua kết quả
      if (_currentOperation?.isCompleted ?? false) return null;

      return result.fold(
        onSuccess: (rawData) {
          // 1. Map dữ liệu nếu có mapper
          final T data = mapper != null ? mapper(rawData) : (rawData as T);

          // 2. Emit state success
          if (data is List && data.isEmpty) {
            safeEmit(BaseState.empty());
          } else {
            safeEmit(BaseState.success(data: data, message: successMessage));
          }

          // 3. Side effects (toast, navigate…)
          onSuccess?.call(rawData);
          return data;
        },
        onFailure: (failure) {
          safeEmit(
            BaseState.failure(error: failure.message, previousData: state.data),
          );
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error(
        'BaseCubit: Execution error',
        error: e,
        stackTrace: stackTrace,
      );
      safeEmit(
        BaseState.failure(error: e.toString(), previousData: state.data),
      );
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  /// 📥 Pagination Helper — không cancel, giữ data cũ khi loading trang mới
  Future<T?> runPagination({required Future<Result<T>> Function() action}) {
    return run<T>(action: action);
  }

  /// 🔄 Reset về initial state
  void reset() {
    cancel();
    safeEmit(BaseState.initial());
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }
}
