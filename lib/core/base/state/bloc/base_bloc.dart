import 'dart:async';

import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../errors/failures.dart';
import '../../errors/result.dart';
import 'base_event.dart';
import 'base_state.dart';

/// 🎯 MINIMAL & POWERFUL BaseBloc
abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc([BaseState? initialState])
    : super(initialState ?? BaseState.initial());

  Completer<void>? _currentOperation;

  /// Hủy operation đang chạy (nếu có)
  void cancel() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  /// 🚀 Core run
  ///
  /// - [R] — kiểu dữ liệu trả về từ API (Response)
  /// - [T] — kiểu dữ liệu state của Bloc (thường là List hoặc Object)
  /// - [successMessage] != null → Mutation (create/update/delete): cancel operation cũ
  /// - [successMessage] == null → Query (fetch data): không cancel, tự nhiên override
  Future<T?> run<T, R>({
    required Emitter<BaseState> emit,
    required Future<Result<R>> Function() action,
    T Function(R data)? mapper,
    void Function(R data)? onSuccess,
    void Function(Failure failure)? onFailure,
    BaseState? loadingState,
    String? successMessage,
  }) async {
    // Cancel operation cũ nếu là Mutation (có successMessage hoặc custom loadingState)
    if (successMessage != null || loadingState != null) cancel();
    _currentOperation = Completer<void>();

    // Emit Loading
    emit(loadingState ?? BaseState.loading(previousData: state.data));

    try {
      final result = await action();

      // Nếu đã bị cancel → bỏ qua kết quả
      if (_currentOperation?.isCompleted ?? false) return null;

      return result.fold(
        onSuccess: (rawData) {
          if (emit.isDone) return null;

          // 1. Map dữ liệu nếu có mapper
          final T data = mapper != null ? mapper(rawData) : (rawData as T);

          // 2. Emit Success
          if (data is List && data.isEmpty) {
            emit(BaseState.empty());
          } else {
            emit(BaseState.success(data: data, message: successMessage));
          }

          // 3. Side effects (toast, navigate…)
          onSuccess?.call(rawData);
          return data;
        },
        onFailure: (failure) {
          if (!emit.isDone) {
            emit(
              BaseState.failure(
                error: failure.message,
                previousData: state.data,
              ),
            );
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error(
        'BaseBloc: Execution error',
        error: e,
        stackTrace: stackTrace,
      );
      if (!emit.isDone) {
        emit(BaseState.failure(error: e.toString(), previousData: state.data));
      }
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  /// 📥 Pagination Helper — không cancel, giữ data cũ khi loading
  Future<T?> runPagination<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
  }) {
    return run<T, T>(emit: emit, action: action);
  }

  /// 🔄 Reset về initial state
  void reset(Emitter<BaseState> emit) {
    cancel();
    emit(BaseState.initial());
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }
}
