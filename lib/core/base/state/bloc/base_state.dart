import 'package:equatable/equatable.dart';

import '../base_status.dart';

// Sentinel để phân biệt "không truyền" vs "truyền null" trong copyWith
const _$sentinel = Object();

/// 🎯 Unified Base State for BLoCs/Cubits
class BaseState<T> extends Equatable {
  final BaseStatus status;
  final T? data;
  final String? error;
  final String? message;

  const BaseState({required this.status, this.data, this.error, this.message});

  // ── Factories ──────────────────────────────────────────────────

  factory BaseState.initial() => const BaseState(status: BaseStatus.initial);

  factory BaseState.loading({T? previousData}) =>
      BaseState(status: BaseStatus.loading, data: previousData);

  factory BaseState.success({T? data, String? message}) =>
      BaseState(status: BaseStatus.success, data: data, message: message);

  /// Alias cho success — dùng khi data không thể null
  factory BaseState.loaded(T data, [String? message]) =>
      BaseState.success(data: data, message: message);

  factory BaseState.empty({String? message}) =>
      BaseState(status: BaseStatus.empty, message: message);

  factory BaseState.failure({required String error, T? previousData}) =>
      BaseState(status: BaseStatus.failure, error: error, data: previousData);

  // ── Status Checkers ────────────────────────────────────────────

  bool get isInitial => status == BaseStatus.initial;
  bool get isLoading => status == BaseStatus.loading;
  bool get isSuccess => status == BaseStatus.success;
  bool get isLoaded => isSuccess;
  bool get isEmpty => status == BaseStatus.empty;
  bool get isFailure => status == BaseStatus.failure;

  bool get hasData => data != null;
  bool get hasError => error != null;

  /// true khi đang refresh (loading nhưng vẫn còn data cũ)
  bool get isRefreshing => isLoading && hasData;

  // ── Display ────────────────────────────────────────────────────

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

  // ── copyWith — Dùng sentinel để có thể set field về null ───────

  BaseState<T> copyWith({
    BaseStatus? status,
    Object? data = _$sentinel,
    Object? error = _$sentinel,
    Object? message = _$sentinel,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      data: data == _$sentinel ? this.data : (data as T?),
      error: error == _$sentinel ? this.error : (error as String?),
      message: message == _$sentinel ? this.message : (message as String?),
    );
  }

  // ── Functional Pattern Matching (Freezed-style) ────────────────

  /// Exhaustive matching — bắt buộc xử lý tất cả trường hợp
  R when<R>({
    required R Function() initial,
    required R Function(T? data) loading,
    required R Function(T data, String? message) success,
    required R Function(String error, T? data) failure,
    R Function(String? message)? empty,
  }) {
    if (isInitial) return initial();
    if (isLoading) return loading(data);
    if (isSuccess) {
      if (data != null) return success(data as T, message);
      return (empty ?? (_) => initial())(message);
    }
    if (isFailure) return failure(error ?? 'Unknown Error', data);
    if (isEmpty) return (empty ?? (_) => initial())(message);
    return initial();
  }

  /// 🎯 Xử lý State mà không cần 'initial'.
  /// Nếu ở trạng thái initial, nó sẽ tự động chạy logic của [loading].
  R whenReady<R>({
    required R Function(T? data) loading,
    required R Function(T data, String? message) success,
    required R Function(String error, T? data) failure,
    R Function(String? message)? empty,
  }) {
    if (isInitial || isLoading) return loading(data);
    if (isSuccess) {
      if (data != null) return success(data as T, message);
      return (empty ?? (_) => loading(data))(message);
    }
    if (isFailure) return failure(error ?? 'Unknown Error', data);
    if (isEmpty) return (empty ?? (_) => loading(data))(message);
    return loading(data);
  }

  /// Non-exhaustive matching — có fallback qua [orElse]
  R maybeWhen<R>({
    R Function()? initial,
    R Function(T? data)? loading,
    R Function(T data, String? message)? success,
    R Function(String error, T? data)? failure,
    R Function(String? message)? empty,
    required R Function() orElse,
  }) {
    if (isInitial && initial != null) return initial();
    if (isLoading && loading != null) return loading(data);
    if (isSuccess && success != null) {
      if (data != null) return success(data as T, message);
      if (empty != null) return empty(message);
    }
    if (isFailure && failure != null) {
      return failure(error ?? 'Unknown Error', data);
    }
    if (isEmpty && empty != null) return empty(message);
    return orElse();
  }

  /// Map chỉ khi success
  BaseState<T> mapSuccess(BaseState<T> Function(T data) fn) {
    if (isSuccess && data != null) return fn(data as T);
    return this;
  }

  /// 🎯 Only handle Success state
  R? whenSuccess<R>(R Function(T data, String? message) onSuccess) {
    if (isSuccess && data != null) {
      return onSuccess(data as T, message);
    }
    return null;
  }

  @override
  List<Object?> get props => [status, data, error, message];

  @override
  String toString() =>
      'BaseState(status: $status, hasData: $hasData, error: $error, message: $message)';
}
