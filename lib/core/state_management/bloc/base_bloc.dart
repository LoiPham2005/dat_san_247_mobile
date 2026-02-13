import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🎯 MINIMAL & POWERFUL BaseBloc
abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc([BaseState? initialState]) : super(initialState ?? BaseState.initial());

  Completer<void>? _currentOperation;

  /// Hủy operation hiện tại
  void cancel() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  /// 🚀 Core Execute
  Future<T?> execute<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    BaseState? loadingState,
    String? successMessage,
  }) async {
    // Tự động cancel nếu là Query (không có successMessage)
    if (successMessage == null) cancel();
    _currentOperation = Completer<void>();

    // Emit Loading
    emit(loadingState ?? BaseState.loading(previousData: state.data));

    try {
      final result = await action();
      if (_currentOperation?.isCompleted ?? false) return null;

      return result.fold(
        onSuccess: (data) {
          if (emit.isDone) return data;

          if (data is List && data.isEmpty) {
            emit(BaseState.empty());
          } else {
            emit(BaseState.success(data: data, message: successMessage));
          }

          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          if (!emit.isDone) {
            emit(BaseState.failure(error: failure.message, previousData: state.data));
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseBloc: Execution error', error: e, stackTrace: stackTrace);
      if (!emit.isDone) {
        emit(BaseState.failure(error: e.toString(), previousData: state.data));
      }
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  /// 📥 Pagination Helper
  Future<T?> executePagination<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
  }) {
    return execute(emit: emit, action: action);
  }

  @override
  Future<void> close() {
    cancel();
    return super.close();
  }
}
