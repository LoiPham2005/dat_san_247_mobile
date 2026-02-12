// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/bloc_extensions.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/state_management/base_status.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';

/// 🎯 Extension methods cho BaseState
///
/// Cung cấp các helper methods để làm việc với BaseState dễ dàng hơn
extension BaseStateExtensions<T> on BaseState<T> {
  /// Lấy data hoặc giá trị mặc định
  ///
  /// Example:
  /// ```dart
  /// final items = state.dataOrDefault([]);
  /// ```
  T dataOrDefault(T defaultValue) {
    return data ?? defaultValue;
  }

  /// Kiểm tra có đang process không (loading, submitting, refreshing, loadingMore)
  bool get isAnyLoading => isProcessing;

  /// Kiểm tra có thể retry không
  bool get shouldRetry => isFailure && canRetry;

  /// Kiểm tra data có empty không (cho List)
  bool get isEmptyList => data is List && (data as List).isEmpty;

  /// Kiểm tra data có empty không (cho Map)
  bool get isEmptyMap => data is Map && (data as Map).isEmpty;

  /// Kiểm tra data có empty không (cho String)
  bool get isEmptyString => data is String && (data as String).isEmpty;

  /// Execute callback khi có data
  ///
  /// Example:
  /// ```dart
  /// state.onData((data) => print('Got data: $data'));
  /// ```
  void onData(void Function(T data) callback) {
    if (hasData) callback(data as T);
  }

  /// Execute callback khi có error
  ///
  /// Example:
  /// ```dart
  /// state.onError((error) => print('Error: $error'));
  /// ```
  void onError(void Function(String error) callback) {
    if (hasError) callback(error!);
  }

  /// Execute callback khi success
  ///
  /// Example:
  /// ```dart
  /// state.onSuccess((message) => showSnackBar(message));
  /// ```
  void onSuccess(void Function(String? message) callback) {
    if (isSuccess) callback(message);
  }

  /// Map data nếu có
  ///
  /// Example:
  /// ```dart
  /// final names = state.mapData((users) => users.map((u) => u.name).toList());
  /// ```
  BaseState<R> mapData<R>(R Function(T data) mapper) {
    if (!hasData) {
      return BaseState<R>(status: status, error: error, message: message);
    }

    return BaseState<R>(status: status, data: mapper(data as T), error: error, message: message);
  }

  /// Kiểm tra status cụ thể
  bool isStatus(BaseStatus targetStatus) => status == targetStatus;

  /// Kiểm tra nhiều status
  bool isAnyStatus(List<BaseStatus> statuses) => statuses.contains(status);

  /// Kiểm tra có phải final state không (loaded, empty, failure, success)
  bool get isFinalState => isLoaded || isEmpty || isFailure || isSuccess;

  /// Kiểm tra có phải loading state không (loading, refreshing, submitting, loadingMore)
  bool get isLoadingState => isLoading || isRefreshing || isSubmitting || isLoadingMore;
}

/// 🎯 Extension methods cho BaseStatus
extension BaseStatusExtensions on BaseStatus {
  /// Kiểm tra có phải loading state không
  bool get isLoadingState {
    return this == BaseStatus.loading ||
        this == BaseStatus.refreshing ||
        this == BaseStatus.submitting ||
        this == BaseStatus.loadingMore;
  }

  /// Kiểm tra có phải final state không
  bool get isFinalState {
    return this == BaseStatus.loaded ||
        this == BaseStatus.empty ||
        this == BaseStatus.failure ||
        this == BaseStatus.success;
  }

  /// Lấy display name
  String get displayName {
    return switch (this) {
      BaseStatus.initial => 'Khởi tạo',
      BaseStatus.loading => 'Đang tải',
      BaseStatus.loaded => 'Đã tải',
      BaseStatus.empty => 'Trống',
      BaseStatus.failure => 'Lỗi',
      BaseStatus.success => 'Thành công',
      BaseStatus.submitting => 'Đang gửi',
      BaseStatus.refreshing => 'Đang làm mới',
      BaseStatus.loadingMore => 'Đang tải thêm',
    };
  }
}
