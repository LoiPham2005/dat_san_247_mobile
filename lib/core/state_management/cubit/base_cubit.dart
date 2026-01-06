// // ════════════════════════════════════════════════════════════════
// // 📁 Example: base_cubit.dart (SIMPLIFIED - Không cần exception)
// // ════════════════════════════════════════════════════════════════

// import 'dart:async';
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
//   BaseCubit([BaseState<T>? initialState])
//       : super(initialState ?? BaseState<T>.initial());

//   Completer<void>? _currentOperation;

//   bool get isCancelled => _currentOperation?.isCompleted ?? false;

//   void cancelCurrentOperation() {
//     if (_currentOperation != null && !_currentOperation!.isCompleted) {
//       _currentOperation!.complete();
//     }
//   }

//   void safeEmit(BaseState<T> newState) {
//     if (!isClosed) emit(newState);
//   }

//   // ════════════════════════════════════════════════════════════
//   // Execute Query (GET operations)
//   // ════════════════════════════════════════════════════════════

//   Future<T?> execute({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     bool preserveDataOnError = false,
//     bool cancelPrevious = false,
//   }) async {
//     if (cancelPrevious) cancelCurrentOperation();
//     _currentOperation = Completer<void>();

//     safeEmit(BaseState.loading(
//       previousData: preserveDataOnError ? state.data : null,
//     ));

//     try {
//       final result = await action();

//       if (isCancelled) return null;

//       return result.fold(
//         onSuccess: (data) {
//           if (data is List && (data as List).isEmpty) {
//             safeEmit(BaseState.empty());
//           } else {
//             safeEmit(BaseState.loaded(data));
//           }
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           // ✅ CHỈ LƯU MESSAGE - Không cần exception/stackTrace
//           safeEmit(
//             BaseState.failure(
//               error: failure.message,  // ← Chỉ lưu message
//               previousData: preserveDataOnError ? state.data : null,
//             ),
//           );
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       // ✅ LOG TẠI ĐÂY, nhưng State chỉ nhận message
//       Logger.error('Execute failed', error: e, stackTrace: stackTrace);

//       safeEmit(
//         BaseState.failure(
//           error: e.toString(),  // ← Chỉ message
//           previousData: preserveDataOnError ? state.data : null,
//         ),
//       );
//       onFailure?.call(UnknownFailure(message: e.toString()));
//       return null;
//     }
//   }

//   // ════════════════════════════════════════════════════════════
//   // Execute Mutation (POST/PUT/DELETE)
//   // ════════════════════════════════════════════════════════════

//   Future<T?> executeMutation({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     String? successMessage,
//   }) async {
//     safeEmit(BaseState.submitting(data: state.data));

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           safeEmit(BaseState.success(data: data, message: successMessage));
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           // ✅ Chỉ lưu message
//           safeEmit(
//             BaseState.failure(
//               error: failure.message,
//               previousData: state.data,
//             ),
//           );
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Mutation failed', error: e, stackTrace: stackTrace);

//       safeEmit(
//         BaseState.failure(
//           error: e.toString(),
//           previousData: state.data,
//         ),
//       );
//       onFailure?.call(UnknownFailure(message: e.toString()));
//       return null;
//     }
//   }

//   // ════════════════════════════════════════════════════════════
//   // Utility Methods
//   // ════════════════════════════════════════════════════════════

//   void reset() {
//     cancelCurrentOperation();
//     safeEmit(BaseState.initial());
//   }

//   void updateData(T data) => safeEmit(BaseState.loaded(data));

//   void setEmpty({String? message}) => safeEmit(BaseState.empty(message: message));

//   @override
//   Future<void> close() {
//     cancelCurrentOperation();
//     return super.close();
//   }
// }

import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Smart + Flexible BaseCubit
abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit([BaseState<T>? initialState]) : super(initialState ?? BaseState<T>.initial());

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  void safeEmit(BaseState<T> newState) {
    if (!isClosed) emit(newState);
  }

  // ════════════════════════════════════════════════════════════
  // 🎯 SMART + FLEXIBLE EXECUTE
  // ════════════════════════════════════════════════════════════

  Future<T?> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,

    // ✅ FLEXIBLE PARAMS - Null = Auto detect
    bool? isMutation, // null → auto detect, true/false → override
    bool? preserveData, // null → auto detect, true/false → override
    bool? cancelPrevious, // null → auto detect, true/false → override
  }) async {
    // ─────────────────────────────────────────────────────────
    // 🤖 AUTO DETECT hoặc OVERRIDE
    // ─────────────────────────────────────────────────────────
    final currentData = state.data; // ✅ Lưu lại data hiện tại
    final bool isRefreshing = currentData != null && !state.isSubmitting && !state.isLoading;

    // 1. Detect mutation (có thể override)
    final bool _isMutation = isMutation ?? (state.isSubmitting || successMessage != null);

    // 2. Detect preserve data (có thể override)
    final bool _preserveData = preserveData ?? (_isMutation || isRefreshing);

    // 3. Detect cancel previous (có thể override)
    final bool _cancelPrevious = cancelPrevious ?? !_isMutation;

    // Cancel nếu cần
    if (_cancelPrevious) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    // ════════════════════════════════════════════════════════════
    // 1️⃣ EMIT LOADING STATE
    // ════════════════════════════════════════════════════════════
    if (_isMutation) {
      safeEmit(BaseState.submitting(data: currentData));
    } else if (isRefreshing) {
      // ✅ FIX: Chỉ gọi refreshing khi có data
      safeEmit(BaseState.refreshing(currentData: currentData!)); // Safe vì đã check isRefreshing
    } else {
      safeEmit(BaseState.loading(previousData: null));
    }

    // ════════════════════════════════════════════════════════════
    // 2️⃣ EXECUTE ACTION
    // ════════════════════════════════════════════════════════════
    try {
      final result = await action();

      if (isCancelled && !_isMutation) return null;

      // ════════════════════════════════════════════════════════════
      // 3️⃣ HANDLE SUCCESS
      // ════════════════════════════════════════════════════════════
      return result.fold(
        onSuccess: (data) {
          if (_isMutation) {
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
              previousData: _preserveData ? currentData : null, // ✅ Dùng currentData
            ),
          );
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Execute failed', error: e, stackTrace: stackTrace);

      safeEmit(
        BaseState.failure(
          error: e.toString(),
          previousData: _preserveData ? currentData : null, // ✅ Dùng currentData
          stackTrace: stackTrace,
        ),
      );
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      if (!_isMutation) _currentOperation = null;
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
}
