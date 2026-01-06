// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/base_state.dart (FINAL UPDATED)
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/core/state_management/bloc/bloc_status.dart';
import 'package:equatable/equatable.dart';

/// Base State cho tất cả BLoCs
class BaseState<T> extends Equatable {
  final BlocStatus status;
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

  factory BaseState.initial() => const BaseState(status: BlocStatus.initial);

  factory BaseState.loading({T? previousData}) =>
      BaseState(status: BlocStatus.loading, data: previousData);

  factory BaseState.loaded(T data, {Map<String, dynamic>? metadata}) =>
      BaseState(status: BlocStatus.loaded, data: data, metadata: metadata);

  factory BaseState.empty({String? message}) =>
      BaseState(status: BlocStatus.empty, message: message ?? 'Không có dữ liệu');

  factory BaseState.failure({
    required String error,
    StackTrace? stackTrace, // ✅ NEW
    T? previousData,
  }) => BaseState(
    status: BlocStatus.failure,
    error: error,
    stackTrace: stackTrace, // ✅ NEW
    data: previousData,
  );

  factory BaseState.success({T? data, String? message}) =>
      BaseState(status: BlocStatus.success, data: data, message: message);

  factory BaseState.submitting({T? data}) => BaseState(status: BlocStatus.submitting, data: data);

  factory BaseState.refreshing({required T currentData}) =>
      BaseState(status: BlocStatus.refreshing, data: currentData);

  // ════════════════════════════════════════════════════════════
  // Getters
  // ════════════════════════════════════════════════════════════

  bool get isInitial => status == BlocStatus.initial;
  bool get isLoading => status == BlocStatus.loading;
  bool get isLoaded => status == BlocStatus.loaded;
  bool get isEmpty => status == BlocStatus.empty;
  bool get isFailure => status == BlocStatus.failure;
  bool get isSuccess => status == BlocStatus.success;
  bool get isSubmitting => status == BlocStatus.submitting;
  bool get isRefreshing => status == BlocStatus.refreshing;

  bool get hasData => data != null;
  bool get hasError => error != null && error!.isNotEmpty;
  bool get isProcessing => isLoading || isSubmitting || isRefreshing;
  bool get canRetry => isFailure && retryCount < 3;

  // ════════════════════════════════════════════════════════════
  // Display Message
  // ════════════════════════════════════════════════════════════

  String get displayMessage {
    if (message != null) return message!;
    if (error != null) return error!;

    return switch (status) {
      BlocStatus.initial => '',
      BlocStatus.loading => 'Đang tải...',
      BlocStatus.refreshing => 'Đang làm mới...',
      BlocStatus.submitting => 'Đang xử lý...',
      BlocStatus.empty => 'Không có dữ liệu',
      BlocStatus.failure => 'Đã xảy ra lỗi',
      BlocStatus.success => 'Thành công',
      BlocStatus.loaded => '',
      BlocStatus.loadingMore => 'Đang tải thêm...',
    };
  }

  // ════════════════════════════════════════════════════════════
  // CopyWith
  // ════════════════════════════════════════════════════════════

  BaseState<T> copyWith({
    BlocStatus? status,
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
