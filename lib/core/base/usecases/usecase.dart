// 📁 lib/core/usecases/usecase.dart
import '../errors/result.dart';

// ── Type aliases ──────────────────────────────────────────────
typedef FutureResult<T> = Future<Result<T>>;
typedef StreamResult<T> = Stream<Result<T>>;
typedef FutureVoidResult = Future<Result<void>>;
typedef FutureBoolResult = Future<Result<bool>>;

// ── Async ─────────────────────────────────────────────────────

/// UseCase có input: `final result = await useCase(params);`
abstract class UseCase<Output, Input> {
  const UseCase();
  FutureResult<Output> call(Input input);
}

/// UseCase không input: `final result = await useCase();`
abstract class UseCaseNoParams<Output> {
  const UseCaseNoParams();
  FutureResult<Output> call();
}

// ── Sync ──────────────────────────────────────────────────────

/// UseCase đồng bộ: `final result = useCase(input);`
abstract class SyncUseCase<Output, Input> {
  const SyncUseCase();
  Result<Output> call(Input input);
}

// ── Stream ────────────────────────────────────────────────────

/// Stream UseCase — realtime data (chat, notifications, live feed)
/// Usage: `useCase(params).listen((result) { ... });`
abstract class StreamUseCase<Output, Input> {
  const StreamUseCase();
  StreamResult<Output> call(Input input);
}

/// Stream UseCase không input
abstract class StreamUseCaseNoParams<Output> {
  const StreamUseCaseNoParams();
  StreamResult<Output> call();
}
