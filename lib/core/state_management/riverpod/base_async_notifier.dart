import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🎯 MINIMAL BaseAsyncNotifier for Riverpod
abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  String? _message;

  String? get message => _message;
  bool get isLoading => state is AsyncLoading;

  T? get data => state.whenOrNull(data: (d) => d);
  Failure? get failure => state.whenOrNull(error: (e, _) => e is Failure ? e : null);

  BaseStatus get status {
    return state.when(
      data: (d) {
        if (d is List && d.isEmpty) return BaseStatus.empty;
        return BaseStatus.success;
      },
      error: (_, __) => BaseStatus.failure,
      loading: () => BaseStatus.loading,
    );
  }

  Completer<void>? _currentOperation;

  void cancel() {
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      _currentOperation!.complete();
    }
  }

  /// 🚀 Core Execute
  Future<T?> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
    String? successMessage,
  }) async {
    if (successMessage == null) cancel();
    _currentOperation = Completer<void>();

    _message = null;
    state = AsyncLoading<T>();

    try {
      final result = await action();
      if (_currentOperation?.isCompleted ?? false) return null;

      return result.fold(
        onSuccess: (data) {
          _message = successMessage;
          state = AsyncData(data);
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          state = AsyncError(failure, StackTrace.current);
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseAsyncNotifier: Execution error', error: e, stackTrace: stackTrace);
      final failure = UnknownFailure(message: e.toString());
      state = AsyncError(failure, stackTrace);
      onFailure?.call(failure);
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  void reset() {
    cancel();
    _message = null;
    ref.invalidateSelf();
  }
}
