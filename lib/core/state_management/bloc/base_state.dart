import 'package:equatable/equatable.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';

/// 🎯 Unified Base State for BLoCs/Cubits
class BaseState<T> extends Equatable {
  final BaseStatus status;
  final T? data;
  final String? error;
  final String? message;

  const BaseState({required this.status, this.data, this.error, this.message});

  // Factories
  factory BaseState.initial() => const BaseState(status: BaseStatus.initial);

  factory BaseState.loading({T? previousData}) =>
      BaseState(status: BaseStatus.loading, data: previousData);

  factory BaseState.success({T? data, String? message}) =>
      BaseState(status: BaseStatus.success, data: data, message: message);

  factory BaseState.loaded(T data, [String? message]) =>
      BaseState.success(data: data, message: message);

  factory BaseState.empty({String? message}) =>
      BaseState(status: BaseStatus.empty, message: message);

  factory BaseState.failure({required String error, T? previousData}) =>
      BaseState(status: BaseStatus.failure, error: error, data: previousData);

  // Status Checkers
  bool get isInitial => status == BaseStatus.initial;
  bool get isLoading => status == BaseStatus.loading;
  bool get isSuccess => status == BaseStatus.success;
  bool get isLoaded => isSuccess;
  bool get isEmpty => status == BaseStatus.empty;
  bool get isFailure => status == BaseStatus.failure;

  bool get hasData => data != null;
  bool get hasError => error != null;

  // Helpers
  bool get isRefreshing => isLoading && hasData;

  String get displayMessage {
    if (error != null) return error!;
    if (message != null) return message!;
    return switch (status) {
      BaseStatus.initial => '',
      BaseStatus.loading => hasData ? 'Đang cập nhật...' : 'Đang tải...',
      BaseStatus.success => 'Thành công',
      BaseStatus.empty => 'Không có dữ liệu',
      BaseStatus.failure => 'Đã xảy ra lỗi',
    };
  }

  BaseState<T> copyWith({BaseStatus? status, T? data, String? error, String? message}) {
    return BaseState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, data, error, message];
}
