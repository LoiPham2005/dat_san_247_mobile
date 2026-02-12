// // ════════════════════════════════════════════════════════════════
// // 📁 lib/core/usecases/usecase.dart
// // ════════════════════════════════════════════════════════════════
// import 'package:dat_san_247_mobile/core/errors/result.dart';

// /// Base UseCase với params
// abstract class UseCase<Type, Params> {
//   Future<Result<Type>> call(Params params);
// }

// /// UseCase không cần params
// abstract class UseCaseNoParams<Type> {
//   Future<Result<Type>> call();
// }

// /// UseCase đồng bộ (Synchronous) với params
// abstract class SyncUseCase<Type, Params> {
//   Result<Type> call(Params params);
// }

// /// UseCase đồng bộ không params
// abstract class SyncUseCaseNoParams<Type> {
//   Result<Type> call();
// }

// /// Stream UseCase - Dùng cho realtime data
// abstract class StreamUseCase<Type, Params> {
//   Stream<Result<Type>> call(Params params);
// }

// /// Stream UseCase không params
// abstract class StreamUseCaseNoParams<Type> {
//   Stream<Result<Type>> call();
// }

import 'package:dat_san_247_mobile/core/errors/result.dart';

/// 🎯 WORLD-CLASS USECASE PATTERN (Dart 3.x)
/// Provides a clear contract and excellent type safety.

/// Base class for all Async UseCases with input parameters.
abstract class UseCase<Output, Input> {
  const UseCase();
  Future<Result<Output>> execute(Input input);

  /// Allows calling the useCase like a function: `useCase(input)`
  Future<Result<Output>> call(Input input) => execute(input);
}

/// Base class for all Async UseCases without input parameters.
abstract class UseCaseNoParams<Output> {
  const UseCaseNoParams();
  Future<Result<Output>> execute();

  /// Allows calling the useCase like a function: `useCase()`
  Future<Result<Output>> call() => execute();
}

/// Base class for Sync UseCases.
abstract class SyncUseCase<Output, Input> {
  const SyncUseCase();
  Result<Output> execute(Input input);
  Result<Output> call(Input input) => execute(input);
}

/// Type aliases for easier reading
typedef FutureResult<T> = Future<Result<T>>;
typedef StreamResult<T> = Stream<Result<T>>;
typedef FutureVoidResult = Future<Result<void>>;
typedef FutureBoolResult = Future<Result<bool>>;
