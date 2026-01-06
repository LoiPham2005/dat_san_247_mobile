// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/provider/base_provider.dart
// // ════════════════════════════════════════════════════════════════
// import 'package:flutter/foundation.dart';
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';

// /// BaseProvider cho Provider pattern
// class BaseProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   /// Thực thi UseCase với full Failure object
//   Future<void> execute<T>({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure, // ✅ Full Failure object
//     bool showLoading = true,
//   }) async {
//     try {
//       if (showLoading) {
//         _isLoading = true;
//         _errorMessage = null;
//         notifyListeners();
//       }

//       final result = await action();

//       result.fold(
//         onSuccess: (data) {
//           _errorMessage = null;
//           onSuccess?.call(data);
//         },
//         onFailure: (failure) {
//           _errorMessage = failure.message;
//           onFailure?.call(failure); // ✅ Pass Failure object
//         },
//       );
//     } catch (exception) {
//       const unknownFailure = UnknownFailure(
//         message: 'Đã xảy ra lỗi không xác định',
//       );
//       _errorMessage = unknownFailure.message;
//       onFailure?.call(unknownFailure);
//     } finally {
//       if (showLoading) {
//         _isLoading = false;
//         notifyListeners();
//       }
//     }
//   }

//   /// Version đơn giản với String message
//   Future<void> executeWithMessage<T>({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(String message)? onFailure, // ✅ Rõ ràng là message
//     bool showLoading = true,
//   }) async {
//     try {
//       if (showLoading) {
//         _isLoading = true;
//         _errorMessage = null;
//         notifyListeners();
//       }

//       final result = await action();

//       result.fold(
//         onSuccess: (data) {
//           _errorMessage = null;
//           onSuccess?.call(data);
//         },
//         onFailure: (failure) {
//           final message = failure.message;
//           _errorMessage = message;
//           onFailure?.call(message);
//         },
//       );
//     } catch (exception) {
//       const message = 'Đã xảy ra lỗi không xác định';
//       _errorMessage = message;
//       onFailure?.call(message);
//     } finally {
//       if (showLoading) {
//         _isLoading = false;
//         notifyListeners();
//       }
//     }
//   }

//   /// Clear error
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }

// bản 2

// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/providers/base_provider.dart (CLEAN)
// // ════════════════════════════════════════════════════════════════
// import 'package:flutter/foundation.dart';
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart';

// /// Status enum cho Provider
// enum ProviderStatus {
//   initial,
//   loading,
//   refreshing,
//   loaded,
//   empty,
//   failure,
//   submitting,
//   success,
// }

// /// Base Provider
// class BaseProvider<T> extends ChangeNotifier {
//   // ════════════════════════════════════════════════════════════
//   // States
//   // ════════════════════════════════════════════════════════════

//   ProviderStatus _status = ProviderStatus.initial;
//   T? _data;
//   String _error = '';
//   String _message = '';
//   Map<String, dynamic> _metadata = {};

//   // ════════════════════════════════════════════════════════════
//   // Getters
//   // ════════════════════════════════════════════════════════════

//   ProviderStatus get status => _status;
//   T? get data => _data;
//   String get error => _error;
//   String get message => _message;
//   Map<String, dynamic> get metadata => _metadata;

//   // ════════════════════════════════════════════════════════════
//   // Status Helpers
//   // ════════════════════════════════════════════════════════════

//   bool get isInitial => _status == ProviderStatus.initial;
//   bool get isLoading => _status == ProviderStatus.loading;
//   bool get isRefreshing => _status == ProviderStatus.refreshing;
//   bool get isLoaded => _status == ProviderStatus.loaded;
//   bool get isEmpty => _status == ProviderStatus.empty;
//   bool get isFailure => _status == ProviderStatus.failure;
//   bool get isSubmitting => _status == ProviderStatus.submitting;
//   bool get isSuccess => _status == ProviderStatus.success;

//   bool get isProcessing => isLoading || isSubmitting || isRefreshing;
//   bool get hasData => _data != null;
//   bool get hasError => _error.isNotEmpty;
//   bool get isInteractable => !isLoading && !isSubmitting;
//   bool get isCompleted => isLoaded || isEmpty || isSuccess;

//   // ════════════════════════════════════════════════════════════
//   // Display Message
//   // ════════════════════════════════════════════════════════════

//   String get displayMessage {
//     if (_message.isNotEmpty) return _message;
//     if (_error.isNotEmpty) return _error;

//     return switch (_status) {
//       ProviderStatus.initial => '',
//       ProviderStatus.loading => 'Đang tải...',
//       ProviderStatus.refreshing => 'Đang làm mới...',
//       ProviderStatus.submitting => 'Đang xử lý...',
//       ProviderStatus.empty => 'Không có dữ liệu',
//       ProviderStatus.failure => 'Đã xảy ra lỗi',
//       ProviderStatus.success => 'Thành công',
//       ProviderStatus.loaded => '',
//     };
//   }

//   // ════════════════════════════════════════════════════════════
//   // State Setters (Private)
//   // ════════════════════════════════════════════════════════════

//   void _setLoading({T? previousData, bool notify = true}) {
//     _status = ProviderStatus.loading;
//     _error = '';
//     if (previousData != null) _data = previousData;
//     if (notify) notifyListeners();
//   }

//   void _setRefreshing({bool notify = true}) {
//     _status = ProviderStatus.refreshing;
//     _error = '';
//     if (notify) notifyListeners();
//   }

//   void _setSubmitting({bool notify = true}) {
//     _status = ProviderStatus.submitting;
//     _error = '';
//     if (notify) notifyListeners();
//   }

//   void _setLoaded(T data, {String? message, bool notify = true}) {
//     _status = ProviderStatus.loaded;
//     _data = data;
//     _error = '';
//     if (message != null) _message = message;
//     if (notify) notifyListeners();
//   }

//   void _setEmpty({String? message, bool notify = true}) {
//     _status = ProviderStatus.empty;
//     _message = message ?? 'Không có dữ liệu';
//     if (notify) notifyListeners();
//   }

//   void _setSuccess({T? data, String? message, bool notify = true}) {
//     _status = ProviderStatus.success;
//     if (data != null) _data = data;
//     _message = message ?? 'Thành công';
//     _error = '';
//     if (notify) notifyListeners();
//   }

//   void _setFailure({required String error, T? previousData, bool notify = true}) {
//     _status = ProviderStatus.failure;
//     _error = error;
//     if (previousData != null) _data = previousData;
//     if (notify) notifyListeners();
//   }

//   // ════════════════════════════════════════════════════════════
//   // Execute Methods
//   // ════════════════════════════════════════════════════════════

//   Future<T?> execute({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     bool preserveDataOnError = false,
//   }) async {
//     _setLoading(previousData: preserveDataOnError ? _data : null);

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           _setLoaded(data);
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           _setFailure(
//             error: failure.message,
//             previousData: preserveDataOnError ? _data : null,
//           );
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Execute failed', error: e, stackTrace: stackTrace);

//       final unknownFailure = UnknownFailure(message: e.toString());
//       _setFailure(
//         error: unknownFailure.message,
//         previousData: preserveDataOnError ? _data : null,
//       );
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
//     _setSubmitting();

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           _setSuccess(data: data, message: successMessage);
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           _setFailure(error: failure.message, previousData: _data);
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Mutation failed', error: e, stackTrace: stackTrace);

//       final unknownFailure = UnknownFailure(message: e.toString());
//       _setFailure(error: unknownFailure.message, previousData: _data);
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   Future<T?> executeRefresh({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//   }) async {
//     if (_data == null) {
//       return execute(action: action, onSuccess: onSuccess, onFailure: onFailure);
//     }

//     _setRefreshing();

//     try {
//       final result = await action();

//       return result.fold(
//         onSuccess: (data) {
//           _setLoaded(data);
//           onSuccess?.call(data);
//           return data;
//         },
//         onFailure: (failure) {
//           _setFailure(error: failure.message, previousData: _data);
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Refresh failed', error: e, stackTrace: stackTrace);

//       final unknownFailure = UnknownFailure(message: e.toString());
//       _setFailure(error: unknownFailure.message, previousData: _data);
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   // ════════════════════════════════════════════════════════════
//   // Utility Methods
//   // ════════════════════════════════════════════════════════════

//   void reset() {
//     _status = ProviderStatus.initial;
//     _data = null;
//     _error = '';
//     _message = '';
//     _metadata = {};
//     notifyListeners();
//   }

//   void clearErrors() {
//     _error = '';
//     notifyListeners();
//   }

//   void clearMessage() {
//     _message = '';
//     notifyListeners();
//   }

//   void setData(T data) {
//     _data = data;
//     _status = ProviderStatus.loaded;
//     notifyListeners();
//   }

//   void setMetadata(Map<String, dynamic> metadata) {
//     _metadata = metadata;
//     notifyListeners();
//   }
// }

// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/cubit/base_cubit.dart (SMART AUTO)
// // ════════════════════════════════════════════════════════════════

// import 'dart:async';
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Smart BaseCubit - TỰ ĐỘNG phát hiện loại operation
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
//   // 🎯 SMART EXECUTE - TỰ ĐỘNG xử lý mọi trường hợp
//   // ════════════════════════════════════════════════════════════

//   Future<T?> execute({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//     String? successMessage,
//   }) async {
//     // ─────────────────────────────────────────────────────────
//     // 🤖 TỰ ĐỘNG phát hiện loại operation
//     // ─────────────────────────────────────────────────────────
//     final bool isRefreshing = state.data != null &&
//         !state.isSubmitting &&
//         !state.isLoading;
//     final bool isMutation = state.isSubmitting || successMessage != null;

//     // Cancel operation trước nếu đang query/refresh
//     if (!isMutation) {
//       cancelCurrentOperation();
//       _currentOperation = Completer<void>();
//     }

//     // ════════════════════════════════════════════════════════════
//     // 1️⃣ EMIT LOADING STATE
//     // ════════════════════════════════════════════════════════════
//     if (isMutation) {
//       safeEmit(BaseState.submitting(data: state.data));
//     } else if (isRefreshing) {
//       safeEmit(BaseState.refreshing(currentData: state.data));
//     } else {
//       safeEmit(BaseState.loading(previousData: null));
//     }

//     // ════════════════════════════════════════════════════════════
//     // 2️⃣ EXECUTE ACTION
//     // ════════════════════════════════════════════════════════════
//     try {
//       final result = await action();

//       if (isCancelled && !isMutation) return null;

//       // ════════════════════════════════════════════════════════════
//       // 3️⃣ HANDLE SUCCESS
//       // ════════════════════════════════════════════════════════════
//       return result.fold(
//         onSuccess: (data) {
//           if (isMutation) {
//             safeEmit(BaseState.success(data: data, message: successMessage ?? 'Thành công'));
//           } else {
//             if (data is List && (data as List).isEmpty) {
//               safeEmit(BaseState.empty());
//             } else {
//               final newState = BaseState.loaded(data);
//               safeEmit(isRefreshing ? newState.resetRetry() : newState);
//             }
//           }
//           onSuccess?.call(data);
//           return data;
//         },

//         onFailure: (failure) {
//           final shouldPreserve = isMutation || isRefreshing;
//           safeEmit(BaseState.failure(
//             error: failure.message,
//             previousData: shouldPreserve ? state.data : null,
//           ));
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Execute failed', error: e, stackTrace: stackTrace);

//       final shouldPreserve = isMutation || isRefreshing;
//       safeEmit(BaseState.failure(
//         error: e.toString(),
//         previousData: shouldPreserve ? state.data : null,
//         stackTrace: stackTrace,
//       ));
//       onFailure?.call(UnknownFailure(message: e.toString()));
//       return null;
//     } finally {
//       if (!isMutation) _currentOperation = null;
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

// // ════════════════════════════════════════════════════════════
// // 📘 USAGE EXAMPLE
// // ════════════════════════════════════════════════════════════

// /*

// class UserCubit extends BaseCubit<List<User>> {
//   final UserRepository _repository;

//   UserCubit(this._repository);

//   // ✅ Query - TỰ ĐỘNG loading
//   Future<void> fetchUsers() async {
//     await execute(action: () => _repository.getUsers());
//   }

//   // ✅ Mutation - TỰ ĐỘNG submitting
//   Future<void> createUser(User user) async {
//     await execute(
//       action: () => _repository.createUser(user),
//       successMessage: 'Tạo thành công!',
//     );
//   }

//   // ✅ Refresh - TỰ ĐỘNG refreshing
//   Future<void> refreshUsers() async {
//     await execute(action: () => _repository.getUsers());
//   }
// }

// */

// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/providers/base_provider.dart (SMART AUTO)
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter/foundation.dart';

enum ProviderStatus { initial, loading, refreshing, loaded, empty, failure, submitting, success }

/// Smart + Flexible BaseProvider
class BaseProvider<T> extends ChangeNotifier {
  ProviderStatus _status = ProviderStatus.initial;
  T? _data;
  String _error = '';
  String _message = '';

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  // Getters
  ProviderStatus get status => _status;
  T? get data => _data;
  String get error => _error;
  String get message => _message;

  bool get isLoading => _status == ProviderStatus.loading;
  bool get isRefreshing => _status == ProviderStatus.refreshing;
  bool get isSubmitting => _status == ProviderStatus.submitting;
  bool get hasData => _data != null;

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
    final bool isRefreshing = _data != null && !isSubmitting && !isLoading;

    final bool _isMutation = isMutation ?? (isSubmitting || successMessage != null);
    final bool _preserveData = preserveData ?? (_isMutation || isRefreshing);
    final bool _cancelPrevious = cancelPrevious ?? !_isMutation;

    if (_cancelPrevious) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    if (_isMutation) {
      _status = ProviderStatus.submitting;
    } else if (isRefreshing) {
      _status = ProviderStatus.refreshing;
    } else {
      _status = ProviderStatus.loading;
      _data = null;
    }
    _error = '';
    notifyListeners();

    try {
      final result = await action();

      if (isCancelled && !_isMutation) return null;

      return result.fold(
        onSuccess: (data) {
          if (_isMutation) {
            _status = ProviderStatus.success;
            _message = successMessage ?? 'Thành công';
          } else {
            if (data is List && (data as List).isEmpty) {
              _status = ProviderStatus.empty;
            } else {
              _status = ProviderStatus.loaded;
            }
          }
          _data = data;
          _error = '';
          notifyListeners();
          onSuccess?.call(data);
          return data;
        },

        onFailure: (failure) {
          _status = ProviderStatus.failure;
          _error = failure.message;
          if (!_preserveData) _data = null;
          notifyListeners();
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Execute failed', error: e, stackTrace: stackTrace);

      _status = ProviderStatus.failure;
      _error = e.toString();
      if (!_preserveData) _data = null;
      notifyListeners();
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      if (!_isMutation) _currentOperation = null;
    }
  }

  void reset() {
    cancelCurrentOperation();
    _status = ProviderStatus.initial;
    _data = null;
    _error = '';
    _message = '';
    notifyListeners();
  }

  @override
  void dispose() {
    cancelCurrentOperation();
    super.dispose();
  }
}
