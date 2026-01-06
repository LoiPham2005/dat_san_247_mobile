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

// ════════════════════════════════════════════════════════════════
// 📁 lib/core/usecases/usecase.dart (ULTIMATE - Pragmatic)
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/errors/result.dart';

// ════════════════════════════════════════════════════════════════
// BASE USE CASES (Optional - dùng khi cần)
// ════════════════════════════════════════════════════════════════

/// Base UseCase với params - Dùng khi muốn enforce signature
///
/// Example:
/// ```dart
/// class GetUserById implements UseCase<UserEntity, int> {
///   @override
///   Future<Result<UserEntity>> call(int userId) => ...
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// UseCase không cần params
///
/// Example:
/// ```dart
/// class GetCurrentUser implements UseCaseNoParams<UserEntity> {
///   @override
///   Future<Result<UserEntity>> call() => ...
/// }
/// ```
abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}

/// UseCase đồng bộ với params (validation, transform)
abstract class SyncUseCase<Type, Params> {
  Result<Type> call(Params params);
}

/// UseCase đồng bộ không params
abstract class SyncUseCaseNoParams<Type> {
  Result<Type> call();
}

/// Stream UseCase - Dùng cho realtime data (WebSocket, Firebase)
abstract class StreamUseCase<Type, Params> {
  Stream<Result<Type>> call(Params params);
}

/// Stream UseCase không params
abstract class StreamUseCaseNoParams<Type> {
  Stream<Result<Type>> call();
}

// ════════════════════════════════════════════════════════════════
// CALLABLE USE CASE (Flexible - Recommended!)
// ════════════════════════════════════════════════════════════════

/// Callable UseCase base - Linh hoạt, dễ dùng
///
/// Dùng khi:
/// - Cần named parameters
/// - Cần multiple parameters
/// - Không muốn tạo Params class riêng
///
/// Example:
/// ```dart
/// @injectable
/// class LoginUseCase extends CallableUseCase<AuthResponse> {
///   final AuthRepository _repository;
///   LoginUseCase(this._repository);
///
///   Future<Result<AuthResponse>> call({
///     required String email,
///     required String password,
///   }) => _repository.login(email: email, password: password);
/// }
/// ```
abstract class CallableUseCase<Type> {
  // Subclass sẽ override call() với signature tùy ý
}

// ════════════════════════════════════════════════════════════════
// TYPE ALIASES (Convenience)
// ════════════════════════════════════════════════════════════════

/// Future Result type alias
typedef FutureResult<T> = Future<Result<T>>;

/// Stream Result type alias
typedef StreamResult<T> = Stream<Result<T>>;

/// Void Result (for mutations that don't return data)
typedef FutureVoidResult = Future<Result<void>>;

/// Bool Result (for success/failure operations)
typedef FutureBoolResult = Future<Result<bool>>;
