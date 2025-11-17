// lib/core/state_management/base_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_base_template/core/state_management/bloc/bloc_status.dart';

/// BaseState dùng chung cho tất cả Cubit.
/// Tối ưu cho khả năng tái sử dụng, mở rộng, và clean architecture.
class BaseState<T> extends Equatable {
  const BaseState({
    required this.status,
    this.data,
    this.error,
    this.message,
  });

  /// Trạng thái khởi tạo ban đầu
  factory BaseState.initial({T? data}) =>
      BaseState(status: BlocStatus.initial, data: data, message: 'Chưa có dữ liệu');

  /// Trạng thái hiện tại của Cubit
  final BlocStatus status;

  /// Dữ liệu (có thể là model, danh sách, primitive...)
  final T? data;

  /// Lỗi (nếu có)
  final String? error;

  /// Message hiển thị cho UI (ví dụ: "Lưu thành công", "Đăng nhập thất bại")
  final String? message;

  /// === Helper getter cho dễ dùng trong Cubit hoặc UI ===
  bool get isInitial => status == BlocStatus.initial;
  bool get isLoading => status == BlocStatus.loading;
  bool get isSuccess => status == BlocStatus.success;
  bool get isFailure => status == BlocStatus.failure;

  /// === Message helpers ===
  /// Trả về message hiển thị phù hợp với trạng thái hiện tại
  String get displayMessage {
    if (isLoading) return message ?? 'Đang tải dữ liệu...';
    if (isFailure) return error ?? message ?? 'Đã xảy ra lỗi';
    if (isSuccess) return message ?? 'Thao tác thành công';
    return message ?? '';
  }

  /// === CopyWith để cập nhật state mới mà không mất dữ liệu cũ ===
  BaseState<T> copyWith({
    BlocStatus? status,
    T? data,
    String? error,
    String? message,
  }) {
    return BaseState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, data, error, message];

  @override
  String toString() {
    return 'BaseState(status: $status, data: $data, error: $error, message: $message)';
  }
}
