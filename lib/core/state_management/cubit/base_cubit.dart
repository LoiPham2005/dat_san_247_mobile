// import 'dart:async';

// import 'package:flutter_base_template/core/errors/failures.dart';
// import 'package:flutter_base_template/core/errors/result.dart';
// import 'package:flutter_base_template/core/state_management/bloc/base_state.dart';
// import 'package:flutter_base_template/core/utils/logger.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// 🎯 MINIMAL & POWERFUL BaseCubit
// abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
//   BaseCubit([BaseState<T>? initialState]) : super(initialState ?? BaseState<T>.initial());

//   Completer<void>? _currentOperation;

//   void cancel() {
//     if (_currentOperation != null && !_currentOperation!.isCompleted) {
//       _currentOperation!.complete();
//     }
//   }

//   void safeEmit(BaseState<T> newState) {
//     if (!isClosed) emit(newState);
//   }

//   /// 🚀 Core Execute
//   Future<T?> execute({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     BaseState<T>? loadingState,
//     String? successMessage,
//   }) async {
//     if (successMessage == null) cancel();
//     _currentOperation = Completer<void>();

//     safeEmit(loadingState ?? BaseState.loading(previousData: state.data));

//     try {
//       final result = await action();
//       if (_currentOperation?.isCompleted ?? false) return null;

//       return result.fold(
//         onSuccess: (data) {
//           if (data is List && data.isEmpty) {
//             safeEmit(BaseState.empty());
//           } else {
//             safeEmit(BaseState.success(data: data, message: successMessage));
//           }

//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('BaseCubit: Execution error', error: e, stackTrace: stackTrace);
//       safeEmit(BaseState.failure(error: e.toString(), previousData: state.data));
//       onFailure?.call(UnknownFailure(message: e.toString()));
//       return null;
//     } finally {
//       _currentOperation = null;
//     }
//   }

//   /// 📥 Pagination Helper
//   Future<T?> executePagination({required Future<Result<T>> Function() action}) {
//     return execute(action: action);
//   }

//   void reset() {
//     cancel();
//     safeEmit(BaseState.initial());
//   }

//   @override
//   Future<void> close() {
//     cancel();
//     return super.close();
//   }
// }

import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🎯 MINIMAL & POWERFUL BaseCubit
abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit([BaseState<T>? initialState]) : super(initialState ?? BaseState<T>.initial());

  Completer<void>? _currentOperation;

  void cancel() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  void safeEmit(BaseState<T> newState) {
    if (!isClosed) emit(newState);
  }

  /// 🚀 Core Execute
  /// [R] là kiểu dữ liệu trả về từ API (Response)
  /// [T] là kiểu dữ liệu state của Cubit
  Future<T?> execute<R>({
    required Future<Result<R>> Function() action,
    T Function(R data)? mapper,
    void Function(R data)? onSuccess,
    void Function(Failure failure)? onFailure,
    BaseState<T>? loadingState,
    String? successMessage,
  }) async {
    if (successMessage != null || loadingState != null) cancel();
    _currentOperation = Completer<void>();

    safeEmit(loadingState ?? BaseState.loading(previousData: state.data));

    try {
      final result = await action();
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

          // 3. Side effects
          onSuccess?.call(rawData);
          return data;
        },
        onFailure: (failure) {
          safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseCubit: Execution error', error: e, stackTrace: stackTrace);
      safeEmit(BaseState.failure(error: e.toString(), previousData: state.data));
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  /// 📥 Pagination Helper
  Future<T?> executePagination({required Future<Result<T>> Function() action}) {
    return execute(action: action);
  }

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
