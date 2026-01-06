// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/getx/base_controller.dart
// // ════════════════════════════════════════════════════════════════
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:get/get.dart';

// class BaseController extends GetxController {
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;

//   void showLoading() => isLoading.value = true;
//   void hideLoading() => isLoading.value = false;

//   /// Thực thi UseCase theo Result pattern
//   ///
//   /// Example:
//   /// ```dart
//   /// await execute(
//   ///   action: () => loginUseCase(email, password),
//   ///   onSuccess: (user) => Get.offAllNamed(Routes.HOME),
//   ///   onFailure: (failure) => showErrorSnackBar(failure.message),
//   /// );
//   /// ```
//   Future<void> execute<T>({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure, // ✅ Pass full Failure object
//     bool showLoading = true,
//   }) async {
//     try {
//       if (showLoading) this.showLoading();

//       final result = await action();

//       result.fold(
//         onSuccess: (data) {
//           errorMessage.value = '';
//           onSuccess?.call(data);
//         },
//         onFailure: (failure) {
//           errorMessage.value = failure.message;
//           onFailure?.call(failure); // ✅ Pass Failure object
//         },
//       );
//     } catch (exception) {
//       const unknownFailure = UnknownFailure(
//         message: 'Đã xảy ra lỗi không xác định',
//       );
//       errorMessage.value = unknownFailure.message;
//       onFailure?.call(unknownFailure);
//     } finally {
//       if (showLoading) hideLoading();
//     }
//   }

//   /// Version đơn giản chỉ cần String message
//   Future<void> executeWithMessage<T>({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(String message)? onFailure, // ✅ Rõ ràng là message
//     bool showLoading = true,
//   }) async {
//     try {
//       if (showLoading) this.showLoading();

//       final result = await action();

//       result.fold(
//         onSuccess: (data) {
//           errorMessage.value = '';
//           onSuccess?.call(data);
//         },
//         onFailure: (failure) {
//           final message = failure.message;
//           errorMessage.value = message;
//           onFailure?.call(message);
//         },
//       );
//     } catch (exception) {
//       const message = 'Đã xảy ra lỗi không xác định';
//       errorMessage.value = message;
//       onFailure?.call(message);
//     } finally {
//       if (showLoading) hideLoading();
//     }
//   }

//   /// Clear error message
//   void clearError() => errorMessage.value = '';
// }

// // bản 2

// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/state_management/getx/base_controller.dart (CLEAN)
// // ════════════════════════════════════════════════════════════════
// import 'package:dat_san_247_mobile/core/errors/failures.dart';
// import 'package:dat_san_247_mobile/core/errors/result.dart';
// import 'package:dat_san_247_mobile/core/utils/logger.dart';
// import 'package:get/get.dart';

// /// Status enum cho GetX
// enum GetXStatus {
//   initial,
//   loading,
//   refreshing,
//   loaded,
//   empty,
//   failure,
//   submitting,
//   success
// }

// /// Base Controller cho GetX
// class BaseController<T> extends GetxController {
//   // ════════════════════════════════════════════════════════════
//   // Reactive States
//   // ════════════════════════════════════════════════════════════

//   final Rx<GetXStatus> _status = GetXStatus.initial.obs;
//   final Rx<T?> _data = Rx<T?>(null);
//   final RxString _error = ''.obs;
//   final RxString _message = ''.obs;
//   final RxMap<String, dynamic> _metadata = RxMap<String, dynamic>({});

//   // ════════════════════════════════════════════════════════════
//   // Getters
//   // ════════════════════════════════════════════════════════════

//   GetXStatus get status => _status.value;
//   T? get data => _data.value;
//   String get error => _error.value;
//   String get message => _message.value;
//   Map<String, dynamic> get metadata => _metadata;

//   // ════════════════════════════════════════════════════════════
//   // Status Helpers
//   // ════════════════════════════════════════════════════════════

//   bool get isInitial => _status.value == GetXStatus.initial;
//   bool get isLoading => _status.value == GetXStatus.loading;
//   bool get isRefreshing => _status.value == GetXStatus.refreshing;
//   bool get isLoaded => _status.value == GetXStatus.loaded;
//   bool get isEmpty => _status.value == GetXStatus.empty;
//   bool get isFailure => _status.value == GetXStatus.failure;
//   bool get isSubmitting => _status.value == GetXStatus.submitting;
//   bool get isSuccess => _status.value == GetXStatus.success;

//   bool get isProcessing => isLoading || isSubmitting || isRefreshing;
//   bool get hasData => _data.value != null;
//   bool get hasError => _error.value.isNotEmpty;
//   bool get isInteractable => !isLoading && !isSubmitting;
//   bool get isCompleted => isLoaded || isEmpty || isSuccess;

//   // ════════════════════════════════════════════════════════════
//   // Display Message
//   // ════════════════════════════════════════════════════════════

//   String get displayMessage {
//     if (_message.value.isNotEmpty) return _message.value;
//     if (_error.value.isNotEmpty) return _error.value;

//     return switch (_status.value) {
//       GetXStatus.initial => '',
//       GetXStatus.loading => 'Đang tải...',
//       GetXStatus.refreshing => 'Đang làm mới...',
//       GetXStatus.submitting => 'Đang xử lý...',
//       GetXStatus.empty => 'Không có dữ liệu',
//       GetXStatus.failure => 'Đã xảy ra lỗi',
//       GetXStatus.success => 'Thành công',
//       GetXStatus.loaded => '',
//     };
//   }

//   // ════════════════════════════════════════════════════════════
//   // State Setters (Private)
//   // ════════════════════════════════════════════════════════════

//   void _setLoading({T? previousData}) {
//     _status.value = GetXStatus.loading;
//     _error.value = '';
//     if (previousData != null) _data.value = previousData;
//   }

//   void _setRefreshing() {
//     _status.value = GetXStatus.refreshing;
//     _error.value = '';
//   }

//   void _setSubmitting() {
//     _status.value = GetXStatus.submitting;
//     _error.value = '';
//   }

//   void _setLoaded(T data, {String? message}) {
//     _status.value = GetXStatus.loaded;
//     _data.value = data;
//     _error.value = '';
//     if (message != null) _message.value = message;
//   }

//   void _setEmpty({String? message}) {
//     _status.value = GetXStatus.empty;
//     _message.value = message ?? 'Không có dữ liệu';
//   }

//   void _setSuccess({T? data, String? message}) {
//     _status.value = GetXStatus.success;
//     if (data != null) _data.value = data;
//     _message.value = message ?? 'Thành công';
//     _error.value = '';
//   }

//   void _setFailure({required String error, T? previousData}) {
//     _status.value = GetXStatus.failure;
//     _error.value = error;
//     if (previousData != null) _data.value = previousData;
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
//     _setLoading(previousData: preserveDataOnError ? _data.value : null);

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
//             previousData: preserveDataOnError ? _data.value : null,
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
//         previousData: preserveDataOnError ? _data.value : null,
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
//           _setFailure(error: failure.message, previousData: _data.value);
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Mutation failed', error: e, stackTrace: stackTrace);

//       final unknownFailure = UnknownFailure(message: e.toString());
//       _setFailure(error: unknownFailure.message, previousData: _data.value);
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   Future<T?> executeRefresh({
//     required Future<Result<T>> Function() action,
//     void Function(T data)? onSuccess,
//     void Function(Failure failure)? onFailure,
//   }) async {
//     if (_data.value == null) {
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
//           _setFailure(error: failure.message, previousData: _data.value);
//           onFailure?.call(failure);
//           return null;
//         },
//       );
//     } catch (e, stackTrace) {
//       Logger.error('Refresh failed', error: e, stackTrace: stackTrace);

//       final unknownFailure = UnknownFailure(message: e.toString());
//       _setFailure(error: unknownFailure.message, previousData: _data.value);
//       onFailure?.call(unknownFailure);
//       return null;
//     }
//   }

//   // ════════════════════════════════════════════════════════════
//   // Utility Methods
//   // ════════════════════════════════════════════════════════════

//   void reset() {
//     _status.value = GetXStatus.initial;
//     _data.value = null;
//     _error.value = '';
//     _message.value = '';
//     _metadata.clear();
//   }

//   void clearErrors() => _error.value = '';
//   void clearMessage() => _message.value = '';
//   void setData(T data) {
//     _data.value = data;
//     _status.value = GetXStatus.loaded;
//   }

//   void setMetadata(Map<String, dynamic> metadata) {
//     _metadata.assignAll(metadata);
//   }
// }

import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:get/get.dart';

enum GetXStatus { initial, loading, refreshing, loaded, empty, failure, submitting, success }

/// Smart + Flexible BaseController
class BaseController<T> extends GetxController {
  final Rx<GetXStatus> _status = GetXStatus.initial.obs;
  final Rx<T?> _data = Rx<T?>(null);
  final RxString _error = ''.obs;
  final RxString _message = ''.obs;

  Completer<void>? _currentOperation;
  bool get isCancelled => _currentOperation?.isCompleted ?? false;

  void cancelCurrentOperation() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  // Getters
  GetXStatus get status => _status.value;
  T? get data => _data.value;
  String get error => _error.value;
  String get message => _message.value;

  bool get isLoading => _status.value == GetXStatus.loading;
  bool get isRefreshing => _status.value == GetXStatus.refreshing;
  bool get isSubmitting => _status.value == GetXStatus.submitting;
  bool get hasData => _data.value != null;

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
    final bool isRefreshing = _data.value != null && !isSubmitting && !isLoading;

    final bool _isMutation = isMutation ?? (isSubmitting || successMessage != null);
    final bool _preserveData = preserveData ?? (_isMutation || isRefreshing);
    final bool _cancelPrevious = cancelPrevious ?? !_isMutation;

    if (_cancelPrevious) {
      cancelCurrentOperation();
      _currentOperation = Completer<void>();
    }

    if (_isMutation) {
      _status.value = GetXStatus.submitting;
    } else if (isRefreshing) {
      _status.value = GetXStatus.refreshing;
    } else {
      _status.value = GetXStatus.loading;
      _data.value = null;
    }
    _error.value = '';

    try {
      final result = await action();

      if (isCancelled && !_isMutation) return null;

      return result.fold(
        onSuccess: (data) {
          if (_isMutation) {
            _status.value = GetXStatus.success;
            _message.value = successMessage ?? 'Thành công';
          } else {
            if (data is List && (data as List).isEmpty) {
              _status.value = GetXStatus.empty;
            } else {
              _status.value = GetXStatus.loaded;
            }
          }
          _data.value = data;
          onSuccess?.call(data);
          return data;
        },

        onFailure: (failure) {
          _status.value = GetXStatus.failure;
          _error.value = failure.message;
          if (!_preserveData) _data.value = null;
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Execute failed', error: e, stackTrace: stackTrace);

      _status.value = GetXStatus.failure;
      _error.value = e.toString();
      if (!_preserveData) _data.value = null;
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      if (!_isMutation) _currentOperation = null;
    }
  }

  void reset() {
    cancelCurrentOperation();
    _status.value = GetXStatus.initial;
    _data.value = null;
    _error.value = '';
    _message.value = '';
  }

  @override
  void onClose() {
    cancelCurrentOperation();
    super.onClose();
  }
}
