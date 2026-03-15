// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state/riverpod/result_handler.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/common/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../errors/failures.dart';
import '../../errors/result.dart';

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

/// run action và tự động chuyển Result thành AsyncValue
///
/// Example:
/// ```dart
/// state = await runToAsyncValue(() => repository.getItems());
/// ```
Future<AsyncValue<T>> runToAsyncValue<T>(
  Future<Result<T>> Function() action,
) async {
  final result = await action();
  return handleResultToAsyncValue(result);
}

/// run action với loading state
///
/// Example:
/// ```dart
/// state = await runWithLoading(() => repository.getItems());
/// ```
Future<AsyncValue<T>> runWithLoading<T>(
  Future<Result<T>> Function() action,
) async {
  try {
    final result = await action();
    return handleResultToAsyncValue(result);
  } catch (e, stackTrace) {
    Logger.error('run failed', error: e, stackTrace: stackTrace);
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

/// run action và handle với callback
///
/// Example:
/// ```dart
/// await runWithCallback(
///   () => repository.deleteItem(id),
///   onSuccess: (_) => loadItems(),
/// );
/// ```
Future<R?> runWithCallback<R>(
  Future<Result<R>> Function() action, {
  void Function(R data)? onSuccess,
  void Function(Failure failure)? onFailure,
}) async {
  try {
    final result = await action();
    return handleResultWithCallback(
      result,
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  } catch (e, stackTrace) {
    Logger.error('run failed', error: e, stackTrace: stackTrace);
    onFailure?.call(UnknownFailure(message: e.toString()));
    return null;
  }
}
