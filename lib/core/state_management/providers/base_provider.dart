import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';

/// 🎯 MINIMAL BaseProvider
abstract class BaseProvider<T> extends ChangeNotifier {
  BaseStatus _status = BaseStatus.initial;
  T? _data;
  String _error = '';
  String _message = '';

  BaseStatus get status => _status;
  T? get data => _data;
  String get error => _error;
  String get message => _message;

  bool get isLoading => _status == BaseStatus.loading;
  bool get hasData => _data != null;

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
    BaseStatus? loadingStatus,
    String? successMessage,
  }) async {
    if (successMessage == null) cancel();
    _currentOperation = Completer<void>();

    _status = loadingStatus ?? BaseStatus.loading;
    _error = '';
    _message = '';
    notifyListeners();

    try {
      final result = await action();
      if (_currentOperation?.isCompleted ?? false) return null;

      return result.fold(
        onSuccess: (data) {
          if (data is List && data.isEmpty) {
            _status = BaseStatus.empty;
          } else {
            _status = BaseStatus.success;
          }
          _data = data;
          _message = successMessage ?? '';
          notifyListeners();
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          _status = BaseStatus.failure;
          _error = failure.message;
          notifyListeners();
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseProvider: Execution error', error: e, stackTrace: stackTrace);
      _status = BaseStatus.failure;
      _error = e.toString();
      notifyListeners();
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  void reset() {
    cancel();
    _status = BaseStatus.initial;
    _data = null;
    _error = '';
    _message = '';
    notifyListeners();
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }
}
