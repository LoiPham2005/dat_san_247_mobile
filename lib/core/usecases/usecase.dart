// ════════════════════════════════════════════════════════════════
// 📁 lib/core/usecases/usecase.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/errors/result.dart';

/// Base UseCase với params
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// UseCase không cần params
abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}

/// UseCase đồng bộ (Synchronous) với params
abstract class SyncUseCase<Type, Params> {
  Result<Type> call(Params params);
}

/// UseCase đồng bộ không params
abstract class SyncUseCaseNoParams<Type> {
  Result<Type> call();
}

/// Stream UseCase - Dùng cho realtime data
abstract class StreamUseCase<Type, Params> {
  Stream<Result<Type>> call(Params params);
}

/// Stream UseCase không params
abstract class StreamUseCaseNoParams<Type> {
  Stream<Result<Type>> call();
}
