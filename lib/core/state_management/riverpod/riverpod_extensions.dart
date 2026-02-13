import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🎯 Extension methods cho AsyncValue
extension AsyncValueExtensions<T> on AsyncValue<T> {
  /// Lấy data hoặc giá trị mặc định
  T dataOrDefault(T defaultValue) {
    return value ?? defaultValue;
  }

  /// Map data nếu đã load thành công
  AsyncValue<R> mapData<R>(R Function(T data) mapper) {
    return when(
      data: (data) => AsyncData(mapper(data)),
      loading: () => const AsyncLoading(),
      error: (error, stack) => AsyncError(error, stack),
    );
  }

  /// Trạng thái loading (bao gồm cả refreshing)
  bool get isLoadingOrRefreshing => isLoading;
}
