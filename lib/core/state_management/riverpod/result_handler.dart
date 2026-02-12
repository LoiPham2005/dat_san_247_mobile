// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/result_handler.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🎯 Helper functions để xử lý Result một cách ngắn gọn
///
/// Sử dụng trong AsyncNotifier để giảm boilerplate code

/// Handle Result và tự động cập nhật AsyncValue state
///
/// Example:
/// ```dart
/// state = const AsyncLoading();
/// final result = await repository.getItems();
/// state = handleResultToAsyncValue(result);
/// ```
AsyncValue<T> handleResultToAsyncValue<T>(Result<T> result) {
  return result.fold(
    onSuccess: (data) => AsyncData(data),
    onFailure: (failure) => AsyncError(failure, StackTrace.current),
  );
}

/// Execute action và tự động chuyển Result thành AsyncValue
///
/// Example:
/// ```dart
/// state = await executeToAsyncValue(() => repository.getItems());
/// ```
Future<AsyncValue<T>> executeToAsyncValue<T>(Future<Result<T>> Function() action) async {
  final result = await action();
  return handleResultToAsyncValue(result);
}

/// Execute action với loading state
///
/// Example:
/// ```dart
/// state = await executeWithLoading(() => repository.getItems());
/// ```
Future<AsyncValue<T>> executeWithLoading<T>(Future<Result<T>> Function() action) async {
  try {
    final result = await action();
    return handleResultToAsyncValue(result);
  } catch (e, stackTrace) {
    Logger.error('Execute failed', error: e, stackTrace: stackTrace);
    return AsyncError(e, stackTrace);
  }
}

/// Handle Result với callback
///
/// Example:
/// ```dart
/// final result = await repository.createItem(item);
/// handleResultWithCallback(
///   result,
///   onSuccess: (data) => print('Success: $data'),
///   onFailure: (failure) => print('Error: ${failure.message}'),
/// );
/// ```
T? handleResultWithCallback<T>(
  Result<T> result, {
  void Function(T data)? onSuccess,
  void Function(Failure failure)? onFailure,
}) {
  return result.fold(
    onSuccess: (data) {
      onSuccess?.call(data);
      return data;
    },
    onFailure: (failure) {
      onFailure?.call(failure);
      Logger.error('Operation failed', error: failure);
      return null;
    },
  );
}

/// Execute action và handle với callback
///
/// Example:
/// ```dart
/// await executeWithCallback(
///   () => repository.deleteItem(id),
///   onSuccess: (_) => loadItems(),
/// );
/// ```
Future<R?> executeWithCallback<R>(
  Future<Result<R>> Function() action, {
  void Function(R data)? onSuccess,
  void Function(Failure failure)? onFailure,
}) async {
  try {
    final result = await action();
    return handleResultWithCallback(result, onSuccess: onSuccess, onFailure: onFailure);
  } catch (e, stackTrace) {
    Logger.error('Execute failed', error: e, stackTrace: stackTrace);
    onFailure?.call(UnknownFailure(message: e.toString()));
    return null;
  }
}
