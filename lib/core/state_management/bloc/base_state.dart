// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/base_state.dart (FINAL UPDATED)
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';

/// Base State cho tất cả BLoCs
class BaseState<T> extends Equatable {
  final BaseStatus status;
  final T? data;
  final String? error;
  final String? message;
  final int retryCount;
  final Map<String, dynamic>? metadata;
  final StackTrace? stackTrace; // ✅ NEW: debug lỗi

  const BaseState({
    required this.status,
    this.data,
    this.error,
    this.message,
    this.retryCount = 0,
    this.metadata,
    this.stackTrace,
  });

  // ════════════════════════════════════════════════════════════
  // Factories
  // ════════════════════════════════════════════════════════════

  factory BaseState.initial() => const BaseState(status: BaseStatus.initial);

  factory BaseState.loading({T? previousData}) =>
      BaseState(status: BaseStatus.loading, data: previousData);

  factory BaseState.loaded(T data, {Map<String, dynamic>? metadata}) =>
      BaseState(status: BaseStatus.loaded, data: data, metadata: metadata);

  factory BaseState.empty({String? message}) =>
      BaseState(status: BaseStatus.empty, message: message ?? 'Không có dữ liệu');

  factory BaseState.failure({
    required String error,
    StackTrace? stackTrace, // ✅ NEW
    T? previousData,
  }) => BaseState(
    status: BaseStatus.failure,
    error: error,
    stackTrace: stackTrace, // ✅ NEW
    data: previousData,
  );

  factory BaseState.success({T? data, String? message}) =>
      BaseState(status: BaseStatus.success, data: data, message: message);

  factory BaseState.submitting({T? data}) => BaseState(status: BaseStatus.submitting, data: data);

  factory BaseState.refreshing({required T currentData}) =>
      BaseState(status: BaseStatus.refreshing, data: currentData);

  factory BaseState.loadingMore({required T currentData}) =>
      BaseState(status: BaseStatus.loadingMore, data: currentData);

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════

  bool get isInitial => status == BaseStatus.initial;
  bool get isLoading => status == BaseStatus.loading;
  bool get isLoaded => status == BaseStatus.loaded;
  bool get isEmpty => status == BaseStatus.empty;
  bool get isFailure => status == BaseStatus.failure;
  bool get isSuccess => status == BaseStatus.success;
  bool get isSubmitting => status == BaseStatus.submitting;
  bool get isRefreshing => status == BaseStatus.refreshing;
  bool get isLoadingMore => status == BaseStatus.loadingMore;

  bool get hasData => data != null;
  bool get hasError => error != null && error!.isNotEmpty;
  bool get isProcessing => isLoading || isSubmitting || isRefreshing || isLoadingMore;
  bool get canRetry => isFailure && retryCount < 3;

  // ════════════════════════════════════════════════════════════
  // Display Message
  // ════════════════════════════════════════════════════════════

  String get displayMessage {
    if (message != null) return message!;
    if (error != null) return error!;

    return switch (status) {
      BaseStatus.initial => '',
      BaseStatus.loading => 'Đang tải...',
      BaseStatus.refreshing => 'Đang làm mới...',
      BaseStatus.submitting => 'Đang xử lý...',
      BaseStatus.empty => 'Không có dữ liệu',
      BaseStatus.failure => 'Đã xảy ra lỗi',
      BaseStatus.success => 'Thành công',
      BaseStatus.loaded => '',
      BaseStatus.loadingMore => 'Đang tải thêm...',
    };
  }

  // ════════════════════════════════════════════════════════════
  // CopyWith
  // ════════════════════════════════════════════════════════════

  BaseState<T> copyWith({
    BaseStatus? status,
    T? data,
    String? error,
    String? message,
    int? retryCount,
    Map<String, dynamic>? metadata,
    StackTrace? stackTrace, // ✅ NEW
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: clearError ? null : (error ?? this.error),
      message: clearMessage ? null : (message ?? this.message),
      retryCount: retryCount ?? this.retryCount,
      metadata: metadata ?? this.metadata,
      stackTrace: stackTrace ?? this.stackTrace, // ✅ NEW
    );
  }

  // ════════════════════════════════════════════════════════════
  // Retry Helper
  // ════════════════════════════════════════════════════════════

  BaseState<T> incrementRetry() => copyWith(retryCount: retryCount + 1);
  BaseState<T> resetRetry() => copyWith(retryCount: 0);

  @override
  List<Object?> get props => [
    status,
    data,
    error,
    message,
    retryCount,
    metadata,
    stackTrace, // ✅ NEW
  ];

  @override
  String toString() =>
      'BaseState(status: $status, hasData: $hasData, error: $error, stackTrace: $stackTrace)';
}
