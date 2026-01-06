// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/riverpod/base_async_notifier.dart
// // ════════════════════════════════════════════════════════════════
// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';

// /// BaseAsyncNotifier cho Riverpod
// abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
//   /// Thực thi UseCase với full Failure object
//   ///
//   /// Example:
//   /// ```dart
//   /// await execute(
//   ///   action: () => getUserUseCase(userId),
//   ///   onSuccess: (user) => ref.read(routerProvider).go('/home'),
//   ///   onFailure: (failure) {
//   ///     if (failure is AuthenticationFailure) {
//   ///       ref.read(authProvider.notifier).logout();
//   ///     }
//   ///   },
//   /// );
//   /// ```
//   Future<void> execute({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure, // ✅ Full Failure object
//     bool showLoading = true,
//   }) async {
//     if (showLoading) {
//       state = const AsyncLoading();
//     }

//     try {
//       final result = await action();

//       result.fold(
//         onSuccess: (data) {
//           state = AsyncData(data);
//           onSuccess?.call(data);
//         },
//         onFailure: (failure) {
//           // ✅ Store failure as error in AsyncValue
//           state = AsyncError(failure, StackTrace.current);
//           onFailure?.call(failure); // ✅ Pass Failure object
//         },
//       );
//     } catch (exception, stackTrace) {
//       state = AsyncError(exception, stackTrace);
//       onFailure?.call(
//         const UnknownFailure(message: 'Đã xảy ra lỗi không xác định'),
//       );
//     }
//   }

//   /// Version đơn giản với String message
//   Future<void> executeWithMessage({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(String message)? onFailure, // ✅ Rõ ràng là message
//     bool showLoading = true,
//   }) async {
//     if (showLoading) {
//       state = const AsyncLoading();
//     }

//     try {
//       final result = await action();

//       result.fold(
//         onSuccess: (data) {
//           state = AsyncData(data);
//           onSuccess?.call(data);
//         },
//         onFailure: (failure) {
//           final message = failure.message;
//           state = AsyncError(message, StackTrace.current);
//           onFailure?.call(message);
//         },
//       );
//     } catch (exception, stackTrace) {
//       state = AsyncError(exception, stackTrace);
//       onFailure?.call('Đã xảy ra lỗi không xác định');
//     }
//   }

//   /// Helpers
//   bool get isLoading => state is AsyncLoading;
//   bool get hasError => state is AsyncError;
//   bool get hasData => state is AsyncData;

//   /// Get error as Failure if possible
//   Failure? get failure {
//     final error = state.error;
//     if (error is Failure) return error;
//     return null;
//   }
// }

// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/riverpod/base_async_notifier.dart (CLEAN)
// // ════════════════════════════════════════════════════════════════
// import 'dart:async';
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// Base AsyncNotifier cho Riverpod
// abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
//   // ════════════════════════════════════════════════════════════
//   // Additional State
//   // ════════════════════════════════════════════════════════════

//   String? _message;
//   bool _isRefreshing = false;
//   bool _isSubmitting = false;
//   Map<String, dynamic> _metadata = {};

//   String? get message => _message;
//   bool get isRefreshing => _isRefreshing;
//   bool get isSubmitting => _isSubmitting;
//   Map<String, dynamic> get metadata => _metadata;

//   // ════════════════════════════════════════════════════════════
//   // Status Helpers
//   // ════════════════════════════════════════════════════════════

//   bool get isLoading => state is AsyncLoading;
//   bool get hasError => state is AsyncError;
//   bool get hasData => state is AsyncData;
//   bool get isProcessing => isLoading || isSubmitting || isRefreshing;
//   bool get isInteractable => !isLoading && !isSubmitting;

//   T? get data => state.when(
//         loading: () => null,
//         error: (_, __) => null,
//         data: (data) => data,
//       );

//   Failure? get failure {
//     final error = state.error;
//     if (error is Failure) return error;
//     return null;
//   }

//   String? get errorMessage {
//     final error = state.error;
//     if (error is Failure) return error.message;
//     if (error != null) return error.toString();
//     return null;
//   }

//   // ════════════════════════════════════════════════════════════
//   // Execute Methods
//   // ════════════════════════════════════════════════════════════

//   Future<T?> execute({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     bool showLoading = true,
//   }) async {
//     if (showLoading) {
//       state = const AsyncLoading();
//     }
//     _message = null;

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           state = AsyncData(data);
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           state = AsyncError(failure, StackTrace.current);
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Execute failed', error: e, stackTrace: stackTrace);

//       final unknownFailure = UnknownFailure(message: e.toString());
//       state = AsyncError(unknownFailure, stackTrace);
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   Future<T?> executeMutation({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     String? successMessage,
//   }) async {
//     _isSubmitting = true;
//     _message = null;

//     final currentData = state.when(
//       loading: () => null,
//       error: (_, __) => null,
//       data: (data) => data,
//     );

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           _isSubmitting = false;
//           _message = successMessage ?? 'Thành công';
//           state = AsyncData(data);
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           _isSubmitting = false;
//           if (currentData != null) {
//             state = AsyncData(currentData);
//           } else {
//             state = AsyncError(failure, StackTrace.current);
//           }
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Mutation failed', error: e, stackTrace: stackTrace);

//       _isSubmitting = false;
//       final unknownFailure = UnknownFailure(message: e.toString());

//       if (currentData != null) {
//         state = AsyncData(currentData);
//       } else {
//         state = AsyncError(unknownFailure, stackTrace);
//       }
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   Future<T?> executeRefresh({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//   }) async {
//     if (!hasData) {
//       return execute(action: action, onSuccess: onSuccess, onFailure: onFailure);
//     }

//     _isRefreshing = true;
//     _message = null;

//     final currentData = state.when(
//       loading: () => null,
//       error: (_, __) => null,
//       data: (data) => data,
//     );

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           _isRefreshing = false;
//           state = AsyncData(data);
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           _isRefreshing = false;
//           if (currentData != null) {
//             state = AsyncData(currentData);
//           }
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Refresh failed', error: e, stackTrace: stackTrace);

//       _isRefreshing = false;
//       final unknownFailure = UnknownFailure(message: e.toString());

//       if (currentData != null) {
//         state = AsyncData(currentData);
//       } else {
//         state = AsyncError(unknownFailure, stackTrace);
//       }
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   // ════════════════════════════════════════════════════════════
//   // Utility Methods
//   // ════════════════════════════════════════════════════════════

//   void setData(T data) => state = AsyncData(data);
//   void setError(Failure failure) => state = AsyncError(failure, StackTrace.current);
//   void clearMessage() => _message = null;
//   void setMetadata(Map<String, dynamic> metadata) => _metadata = metadata;

//   void reset() {
//     _message = null;
//     _isRefreshing = false;
//     _isSubmitting = false;
//     _metadata = {};
//     ref.invalidateSelf();
//   }
// }

// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/base_async_notifier.dart (SMART AUTO)
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Smart + Flexible BaseAsyncNotifier
abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  String? _message;
  bool _isRefreshing = false;
  bool _isSubmitting = false;

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  // Getters
  String? get message => _message;
  bool get isRefreshing => _isRefreshing;
  bool get isSubmitting => _isSubmitting;
  bool get isLoading => state is AsyncLoading;
  bool get hasData => state is AsyncData;

  T? get data => state.when(loading: () => null, error: (_, __) => null, data: (data) => data);

  // ════════════════════════════════════════════════════════════
  // 🎯 SMART + FLEXIBLE EXECUTE
  // ════════════════════════════════════════════════════════════

  Future<T?> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,

    // ✅ FLEXIBLE PARAMS
    bool? isMutation,
    bool? preserveData,
    bool? cancelPrevious,
  }) async {
    final bool isRefreshingNow = hasData && !_isSubmitting && !isLoading;
    final currentData = data;

    final bool _isMutation = isMutation ?? (_isSubmitting || successMessage != null);
    final bool _preserveData = preserveData ?? (_isMutation || isRefreshingNow);
    final bool _cancelPrevious = cancelPrevious ?? !_isMutation;

    if (_cancelPrevious) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    if (_isMutation) {
      _isSubmitting = true;
    } else if (isRefreshingNow) {
      _isRefreshing = true;
    } else {
      state = const AsyncLoading();
    }
    _message = null;

    try {
      final result = await action();

      if (isCancelled && !_isMutation) return null;

      return result.fold(
        onSuccess: (data) {
          _isSubmitting = false;
          _isRefreshing = false;

          if (_isMutation) {
            _message = successMessage ?? 'Thành công';
          }

          state = AsyncData(data);
          onSuccess?.call(data);
          return data;
        },

        onFailure: (failure) {
          _isSubmitting = false;
          _isRefreshing = false;

          if (currentData != null && _preserveData) {
            state = AsyncData(currentData);
          } else {
            state = AsyncError(failure, StackTrace.current);
          }
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Execute failed', error: e, stackTrace: stackTrace);

      _isSubmitting = false;
      _isRefreshing = false;

      final unknownFailure = UnknownFailure(message: e.toString());

      if (currentData != null && _preserveData) {
        state = AsyncData(currentData);
      } else {
        state = AsyncError(unknownFailure, stackTrace);
      }
      onFailure?.call(unknownFailure);
      return null;
    } finally {
      if (!_isMutation) _currentOperation = null;
    }
  }

  void reset() {
    cancelCurrentOperation();
    _message = null;
    _isRefreshing = false;
    _isSubmitting = false;
    ref.invalidateSelf();
  }
}
