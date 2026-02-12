// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/riverpod/riverpod_extensions.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🎯 Extension methods cho AsyncValue
///
/// Cung cấp các helper methods để làm việc với AsyncValue dễ dàng hơn
extension AsyncValueExtensions<T> on AsyncValue<T> {
  /// Kiểm tra xem có đang loading không (bao gồm cả refreshing)
  bool get isLoadingOrRefreshing => isLoading || isRefreshing;

  /// Kiểm tra xem có đang refresh không
  bool get isRefreshing => maybeWhen(data: (_) => isLoading, orElse: () => false);

  /// Lấy data hoặc giá trị mặc định
  ///
  /// Example:
  /// ```dart
  /// final items = state.dataOrDefault([]);
  /// ```
  T dataOrDefault(T defaultValue) {
    return when(data: (data) => data, loading: () => defaultValue, error: (_, _) => defaultValue);
  }

  /// Lấy data hoặc null
  T? get dataOrNull => whenOrNull(data: (data) => data);

  /// Lấy error hoặc null
  Object? get errorOrNull => whenOrNull(error: (error, _) => error);

  /// Map data nếu có
  ///
  /// Example:
  /// ```dart
  /// final names = state.mapData((users) => users.map((u) => u.name).toList());
  /// ```
  AsyncValue<R> mapData<R>(R Function(T data) mapper) {
    return when(
      data: (data) => AsyncData(mapper(data)),
      loading: () => const AsyncLoading(),
      error: (error, stack) => AsyncError(error, stack),
    );
  }

  /// Kiểm tra data có empty không (cho List)
  bool get isEmptyList {
    return when(
      data: (data) => data is List && data.isEmpty,
      loading: () => false,
      error: (_, _) => false,
    );
  }

  /// Execute callback khi có data
  ///
  /// Example:
  /// ```dart
  /// state.onData((data) => print('Got data: $data'));
  /// ```
  void onData(void Function(T data) callback) {
    whenData(callback);
  }

  /// Execute callback khi có error
  ///
  /// Example:
  /// ```dart
  /// state.onError((error, stack) => print('Error: $error'));
  /// ```
  void onError(void Function(Object error, StackTrace stack) callback) {
    whenOrNull(error: callback);
  }
}
