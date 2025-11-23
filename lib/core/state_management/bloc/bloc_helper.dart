// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/bloc_helpers.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/errors/failures.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper function để xử lý UseCase calls trong BLoC
///
/// Example:
/// ```dart
/// await handleUseCaseRequest(
///   emit: emit,
///   useCaseCall: () => getUserUseCase(userId),
///   stateBuilder: (status, data, error) => UserState(
///     status: status ?? BlocStatus.initial,
///     user: data,
///     errorMessage: error,
///   ),
///   onSuccess: (user) => print('Got user: ${user.name}'),
///   onFailure: (failure) => showSnackBar(failure.message),
/// );
/// ```
Future<void> execute<T, S>({
  required Emitter<S> emit,
  required Future<Result<T>> Function() useCaseCall,
  required S Function({
    BlocStatus? status,
    T? data,
    String? errorMessage,
  }) stateBuilder,
  void Function(T data)? onSuccess,
  void Function(Failure failure)? onFailure,
}) async {
  // Emit loading state
  emit(stateBuilder(status: BlocStatus.loading));

  try {
    final result = await useCaseCall();

    result.fold(
      onSuccess: (data) {
        // Emit success state
        emit(stateBuilder(
          status: BlocStatus.success,
          data: data,
        ));

        // Execute success callback nếu có
        onSuccess?.call(data);
      },
      onFailure: (failure) {
        // Emit failure state
        emit(stateBuilder(
          status: BlocStatus.failure,
          errorMessage: failure.message,
        ));

        // Execute failure callback nếu có
        onFailure?.call(failure);
      },
    );
  } catch (exception) {
    // Handle unexpected errors
    const errorMessage = 'Đã xảy ra lỗi không xác định';

    emit(stateBuilder(
      status: BlocStatus.failure,
      errorMessage: errorMessage,
    ));

    // Log error for debugging
    // Logger.error('Unexpected error in BLoC', error: exception, stackTrace: stackTrace);

    // Call failure callback with unknown failure
    onFailure?.call(const UnknownFailure(message: errorMessage));
  }
}

// ════════════════════════════════════════════════════════════════
// 🎯 PHIÊN BẢN 2: Nếu muốn dùng String message thay vì Failure
// ════════════════════════════════════════════════════════════════

/// Helper function (String-based version)
/// Dùng khi bạn chỉ cần message string, không cần full Failure object
Future<void> executeWithMessage<T, S>({
  required Emitter<S> emit,
  required Future<Result<T>> Function() useCaseCall,
  required S Function({
    BlocStatus? status,
    T? data,
    String? errorMessage,
  }) stateBuilder,
  void Function(T data)? onSuccess,
  void Function(String message)? onFailure, // ✅ Rõ ràng là message
}) async {
  emit(stateBuilder(status: BlocStatus.loading));

  try {
    final result = await useCaseCall();

    result.fold(
      onSuccess: (data) {
        emit(stateBuilder(status: BlocStatus.success, data: data));
        onSuccess?.call(data);
      },
      onFailure: (failure) {
        final errorMessage = failure.message;
        emit(stateBuilder(status: BlocStatus.failure, errorMessage: errorMessage));
        onFailure?.call(errorMessage); // Pass message
      },
    );
  } catch (exception) {
    const errorMessage = 'Đã xảy ra lỗi không xác định';
    emit(stateBuilder(status: BlocStatus.failure, errorMessage: errorMessage));
    onFailure?.call(errorMessage);
  }
}
