// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/bloc/base_bloc.dart (WITH REQUIRED)
// // ════════════════════════════════════════════════════════════════
//
// import 'dart:async';
//
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
// import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// /// Base BLoC với helper methods tái sử dụng
// // handleRequest
// abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
//   BaseBloc([BaseState? initialState]) : super(initialState ?? BaseState.initial());
//
//   // ════════════════════════════════════════════════════════════
//   // Cancellation Support
//   // ════════════════════════════════════════════════════════════
//
//   Completer<void>? _currentOperation;
//
//   bool get isCancelled => _currentOperation?.isCompleted ?? false;
//
//   void cancelCurrentOperation() {
//     if (_currentOperation != null && !_currentOperation!.isCompleted) {
//       _currentOperation!.complete();
//     }
//   }
//
//   // ════════════════════════════════════════════════════════════
//   // Execute Query (GET operations)
//   // ════════════════════════════════════════════════════════════
//
//   Future<T?> execute<T>({
//     required BaseEvent event,
//     required Emitter<BaseState> emit,
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     bool preserveDataOnError = false,
//     bool cancelPrevious = false,
//   }) async {
//     if (cancelPrevious) cancelCurrentOperation();
//     _currentOperation = Completer<void>();
//
//     emit(BaseState.loading(previousData: preserveDataOnError ? state.data : null));
//
//     try {
//       final result = await action();
//
//       if (isCancelled) return null;
//
//       return result.fold(
//         onSuccess: (data) {
//           if (!emit.isDone) {
//             if (data is List && (data as List).isEmpty) {
//               emit(BaseState.empty());
//             } else {
//               emit(BaseState.loaded(data));
//             }
//           }
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           if (!emit.isDone) {
//             emit(BaseState.failure(
//               error: failure.message,
//               previousData: state.data,
//             ));
//           }
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       if (!emit.isDone) {
//         emit(BaseState.failure(
//           error: e.toString(),
//           previousData: state.data,
//           stackTrace: stackTrace
//         ));
//       }
//       onFailure?.call(UnknownFailure(message: e.toString()));
//       return null;
//     }
//   }
//
//   // ════════════════════════════════════════════════════════════
//   // Execute Mutation (POST/PUT/DELETE)
//   // ════════════════════════════════════════════════════════════
//
//   Future<T?> executeMutation<T>({
//     required BaseEvent event,
//     required Emitter<BaseState> emit,
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     String? successMessage,
//   }) async {
//     emit(BaseState.submitting(data: state.data));
//
//     try {
//       final result = await action();
//
//       return result.fold(
//         onSuccess: (data) {
//           if (!emit.isDone) {
//             emit(BaseState.success(data: data, message: successMessage));
//           }
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           if (!emit.isDone) {
//             emit(BaseState.failure(
//               error: failure.message,
//               previousData: state.data,
//             ));
//           }
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       if (!emit.isDone) {
//         emit(BaseState.failure(
//           error: e.toString(),
//           previousData: state.data,
//           stackTrace: stackTrace
//         ));
//       }
//       onFailure?.call(UnknownFailure(message: e.toString(), ));
//       return null;
//     }
//   }
//
//   // ════════════════════════════════════════════════════════════
//   // Execute Refresh (pull-to-refresh)
//   // ════════════════════════════════════════════════════════════
//
//   Future<T?> executeRefresh<T>({
//     required BaseEvent event,
//     required Emitter<BaseState> emit,
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//   }) async {
//     if (state.data == null) {
//       return execute(
//         event: event,
//         emit: emit,
//         action: action,
//         onSuccess: onSuccess,
//         onFailure: onFailure,
//       );
//     }
//
//     emit(BaseState.refreshing(currentData: state.data));
//
//     try {
//       final result = await action();
//
//       return result.fold(
//         onSuccess: (data) {
//           if (!emit.isDone) {
//             if (data is List && (data as List).isEmpty) {
//               emit(BaseState.empty());
//             } else {
//               emit(BaseState.loaded(data).resetRetry());
//             }
//           }
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           if (!emit.isDone) {
//             emit(BaseState.failure(
//               error: failure.message,
//               previousData: state.data,
//             ));
//           }
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       if (!emit.isDone) {
//         emit(BaseState.failure(
//           error: e.toString(),
//           previousData: state.data,
//           stackTrace: stackTrace
//         ));
//       }
//       onFailure?.call(UnknownFailure(message: e.toString()));
//       return null;
//     }
//   }
//
//   @override
//   Future<void> close() {
//     cancelCurrentOperation();
//     return super.close();
//   }
// }

// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/base_bloc.dart (SMART AUTO)
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Smart + Flexible BaseBloc
abstract class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc([BaseState? initialState]) : super(initialState ?? BaseState.initial());

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  // ════════════════════════════════════════════════════════════
  // 🎯 SMART + FLEXIBLE EXECUTE
  // ════════════════════════════════════════════════════════════

  Future<T?> execute<T>({
    required Emitter<BaseState> emit,
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,

    // ✅ FLEXIBLE PARAMS - Null = Auto detect
    bool? isMutation,
    bool? preserveData,
    bool? cancelPrevious,
  }) async {
    // ─────────────────────────────────────────────────────────
    // 🤖 AUTO DETECT hoặc OVERRIDE
    // ─────────────────────────────────────────────────────────
    final bool isRefreshing = state.data != null && !state.isSubmitting && !state.isLoading;

    final bool _isMutation = isMutation ?? (state.isSubmitting || successMessage != null);
    final bool _preserveData = preserveData ?? (_isMutation || isRefreshing);
    final bool _cancelPrevious = cancelPrevious ?? !_isMutation;

    if (_cancelPrevious) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    // ════════════════════════════════════════════════════════════
    // 1️⃣ EMIT LOADING STATE
    // ════════════════════════════════════════════════════════════
    if (_isMutation) {
      emit(BaseState.submitting(data: state.data));
    } else if (isRefreshing) {
      emit(BaseState.refreshing(currentData: state.data));
    } else {
      emit(BaseState.loading(previousData: null));
    }

    // ════════════════════════════════════════════════════════════
    // 2️⃣ EXECUTE ACTION
    // ════════════════════════════════════════════════════════════
    try {
      final result = await action();

      if (isCancelled && !_isMutation) return null;

      return result.fold(
        onSuccess: (data) {
          if (emit.isDone) return data;

          if (_isMutation) {
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
                previousData: _preserveData ? state.data : null,
              ),
            );
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Execute failed', error: e, stackTrace: stackTrace);

      if (!emit.isDone) {
        emit(
          BaseState.failure(
            error: e.toString(),
            previousData: _preserveData ? state.data : null,
            stackTrace: stackTrace,
          ),
        );
      }
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      if (!_isMutation) _currentOperation = null;
    }
  }

  @override
  Future<void> close() {
    cancelCurrentOperation();
    return super.close();
  }
}
