// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/result.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter_base_template/core/errors/failures.dart';

/// Result pattern - Thay thế Either trong functional programming
sealed class Result<T> {
  const Result();

  /// Check if result is success
  bool get isSuccess => this is ResultSuccess<T>;

  /// Check if result is failure
  bool get isFailure => this is ResultFailure<T>;

  /// Get data (null if failure)
  T? get dataOrNull => isSuccess ? (this as ResultSuccess<T>).data : null;

  /// Get failure (null if success)
  Failure? get failureOrNull =>
      isFailure ? (this as ResultFailure<T>).failure : null;

  /// Fold pattern - Transform result to single type
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      ResultSuccess(data: final data) => onSuccess(data),
      ResultFailure(failure: final failure) => onFailure(failure),
    };
  }

  /// Map success data to another type
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      ResultSuccess(data: final data) => ResultSuccess(transform(data)),
      ResultFailure(failure: final failure) => ResultFailure(failure),
    };
  }

  /// FlatMap - Chain multiple Result operations
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return switch (this) {
      ResultSuccess(data: final data) => transform(data),
      ResultFailure(failure: final failure) => ResultFailure(failure),
    };
  }

  /// Get data or throw exception
  T getOrThrow() {
    return switch (this) {
      ResultSuccess(data: final data) => data,
      ResultFailure(failure: final failure) => throw Exception(failure.message),
    };
  }

  /// Get data or return default value
  T getOrDefault(T defaultValue) {
    return switch (this) {
      ResultSuccess(data: final data) => data,
      ResultFailure() => defaultValue,
    };
  }

  /// Execute side effect if success
  Result<T> onSuccess(void Function(T data) action) {
    if (this is ResultSuccess<T>) {
      action((this as ResultSuccess<T>).data);
    }
    return this;
  }

  /// Execute side effect if failure
  Result<T> onFailure(void Function(Failure failure) action) {
    if (this is ResultFailure<T>) {
      action((this as ResultFailure<T>).failure);
    }
    return this;
  }

  /// Map List<T> to List<R>
  Result<List<R>> mapList<R>(R Function(dynamic) transform) {
    return switch (this) {
      ResultSuccess(data: final data) =>
        data is List
            ? ResultSuccess(data.map((item) => transform(item)).toList())
            : const ResultFailure(
                UnknownFailure(message: 'Data is not a List'),
              ),
      ResultFailure(failure: final failure) => ResultFailure(failure),
    };
  }
}

/// Success result with data
final class ResultSuccess<T> extends Result<T> {
  final T data;
  const ResultSuccess(this.data);

  @override
  String toString() => 'ResultSuccess(data: $data)';
}

/// Failure result with error
final class ResultFailure<T> extends Result<T> {
  final Failure failure;
  const ResultFailure(this.failure);

  @override
  String toString() => 'ResultFailure(failure: $failure)';
}
