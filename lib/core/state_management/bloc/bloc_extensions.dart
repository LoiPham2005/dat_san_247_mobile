import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';

/// 🎯 Extension methods cho BaseState
extension BaseStateExtensions<T> on BaseState<T> {
  /// Map data nếu đã load thành công
  BaseState<R> mapData<R>(R Function(T data) mapper) {
    if (data == null) {
      return BaseState<R>(status: status, error: error, message: message);
    }
    return BaseState<R>(status: status, data: mapper(data as T), error: error, message: message);
  }

  bool get isProcessing => isLoading;
}

/// 🎯 Extension methods cho BaseStatus
extension BaseStatusExtensions on BaseStatus {
  bool get isLoadingState => this == BaseStatus.loading;
  bool get isSuccessState => this == BaseStatus.success;
  bool get isFailureState => this == BaseStatus.failure;
}
