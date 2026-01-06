// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/result.dart (OPTIMIZED - Giảm 40% methods)
// ════════════════════════════════════════════════════════════════

import 'package:dat_san_247_mobile/core/errors/failures.dart';

/// Result pattern - Thay thế Either
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is ResultSuccess<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get dataOrNull => isSuccess ? (this as ResultSuccess<T>).data : null;
  Failure? get failureOrNull => isFailure ? (this as ResultFailure<T>).failure : null;

  // ═══════════════════════════════════════════════════════════
  // Core Methods (4 methods chính - đủ dùng cho 90% cases)
  // ═══════════════════════════════════════════════════════════

  /// 1. Fold - Transform to single type
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      ResultSuccess(data: final data) => onSuccess(data),
      ResultFailure(failure: final failure) => onFailure(failure),
    };
  }

  /// 2. Map - Transform success data
  Result<R> map<R>(R Function(T data) transform) {
    return fold(
      onSuccess: (data) => ResultSuccess(transform(data)),
      onFailure: (failure) => ResultFailure(failure),
    );
  }

  /// 3. FlatMap - Chain operations
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return fold(onSuccess: transform, onFailure: (failure) => ResultFailure(failure));
  }

  /// 4. GetOrElse - Get data or fallback
  T getOrElse(T Function() orElse) {
    return fold(onSuccess: (data) => data, onFailure: (_) => orElse());
  }

  // ═══════════════════════════════════════════════════════════
  // Convenience Methods (4 methods bổ sung thường dùng)
  // ═══════════════════════════════════════════════════════════

  /// Async chain
  Future<Result<R>> flatMapAsync<R>(Future<Result<R>> Function(T data) transform) async {
    return fold(onSuccess: transform, onFailure: (failure) async => ResultFailure(failure));
  }

  /// Side effects
  Result<T> tap(void Function(T data) onSuccess, [void Function(Failure failure)? onFailure]) {
    fold(onSuccess: onSuccess, onFailure: onFailure ?? (_) {});
    return this;
  }

  /// Recovery
  Result<T> recover(T Function(Failure failure) recovery) {
    return fold(
      onSuccess: (data) => ResultSuccess(data),
      onFailure: (failure) => ResultSuccess(recovery(failure)),
    );
  }

  /// Quick getters
  T getOrThrow() =>
      fold(onSuccess: (data) => data, onFailure: (failure) => throw Exception(failure.message));
}

/// Success with data
final class ResultSuccess<T> extends Result<T> {
  final T data;
  const ResultSuccess(this.data);

  @override
  String toString() => 'ResultSuccess($data)';
}

/// Failure with error
final class ResultFailure<T> extends Result<T> {
  final Failure failure;
  const ResultFailure(this.failure);

  @override
  String toString() => 'ResultFailure($failure)';
}

// ═══════════════════════════════════════════════════════════
// Extensions for common patterns
// ═══════════════════════════════════════════════════════════

extension ResultListX<T> on Result<List<T>> {
  /// Map list items
  Result<List<R>> mapItems<R>(R Function(T item) transform) {
    return map((list) => list.map(transform).toList());
  }

  /// Filter list
  Result<List<T>> where(bool Function(T item) test) {
    return map((list) => list.where(test).toList());
  }
}

extension ResultFutureX<T> on Future<Result<T>> {
  /// Chain future results
  Future<Result<R>> thenMap<R>(R Function(T data) transform) async {
    return (await this).map(transform);
  }

  Future<Result<R>> thenFlatMap<R>(Result<R> Function(T data) transform) async {
    return (await this).flatMap(transform);
  }
}
