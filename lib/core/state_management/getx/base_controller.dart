import 'dart:async';

import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:get/get.dart';

/// 🎯 MINIMAL BaseController for GetX
abstract class BaseController<T> extends GetxController {
  final Rx<BaseStatus> _status = BaseStatus.initial.obs;
  final Rx<T?> _data = Rx<T?>(null);
  final RxString _error = ''.obs;
  final RxString _message = ''.obs;

  BaseStatus get status => _status.value;
  T? get data => _data.value;
  String get error => _error.value;
  String get message => _message.value;

  bool get isLoading => status == BaseStatus.loading;
  bool get hasData => data != null;

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

    _status.value = loadingStatus ?? BaseStatus.loading;
    _error.value = '';
    _message.value = '';

    try {
      final result = await action();
      if (_currentOperation?.isCompleted ?? false) return null;

      return result.fold(
        onSuccess: (data) {
          if (data is List && data.isEmpty) {
            _status.value = BaseStatus.empty;
          } else {
            _status.value = BaseStatus.success;
          }
          _data.value = data;
          _message.value = successMessage ?? '';
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          _status.value = BaseStatus.failure;
          _error.value = failure.message;
          onFailure?.call(failure);
          return null;
        },
      );
    } catch (e, stackTrace) {
      Logger.error('BaseController: Execution error', error: e, stackTrace: stackTrace);
      _status.value = BaseStatus.failure;
      _error.value = e.toString();
      onFailure?.call(UnknownFailure(message: e.toString()));
      return null;
    } finally {
      _currentOperation = null;
    }
  }

  void reset() {
    cancel();
    _status.value = BaseStatus.initial;
    _data.value = null;
    _error.value = '';
    _message.value = '';
  }

  @override
  void onClose() {
    cancel();
    super.onClose();
  }
}
