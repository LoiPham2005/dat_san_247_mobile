// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/bloc/base_cubit.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter_base_template/core/errors/failures.dart';
import 'package:flutter_base_template/core/errors/result.dart';
import 'package:flutter_base_template/core/state_management/bloc/base_state.dart';
import 'package:flutter_base_template/core/state_management/bloc/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit([BaseState<T>? initialState])
      : super(initialState ?? BaseState<T>.initial());

  /// Emit an toàn (tránh lỗi khi Cubit đã đóng)
  void safeEmit(BaseState<T> newState) {
    if (!isClosed) emit(newState);
  }

  /// Thực thi UseCase với full Failure object
  /// 
  /// Example:
  /// ```dart
  /// await executeUseCase(
  ///   action: () => getUserUseCase(userId),
  ///   onSuccess: (user) => print('User: ${user.name}'),
  ///   onFailure: (failure) {
  ///     if (failure is NetworkFailure) {
  ///       showSnackBar('Không có mạng');
  ///     }
  ///   },
  /// );
  /// ```
  Future<T?> execute({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure, // ✅ Full Failure object
  }) async {
    safeEmit(state.copyWith(
      status: BlocStatus.loading,
      error: null,
    ));

    try {
      final result = await action();

      return result.fold(
        onSuccess: (data) {
          safeEmit(state.copyWith(
            status: BlocStatus.success,
            data: data,
          ));
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          safeEmit(state.copyWith(
            status: BlocStatus.failure,
            error: failure.message,
          ));
          onFailure?.call(failure); // ✅ Pass Failure object
          return null;
        },
      );
    } catch (exception) {
      const unknownFailure = UnknownFailure(message: 'Đã xảy ra lỗi không xác định');
      safeEmit(state.copyWith(
        status: BlocStatus.failure,
        error: unknownFailure.message,
      ));
      onFailure?.call(unknownFailure);
      return null;
    }
  }

  /// Version đơn giản chỉ dùng String message
  Future<T?> executeWithMessage({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(String message)? onFailure, // ✅ Rõ ràng là message
  }) async {
    safeEmit(state.copyWith(status: BlocStatus.loading, error: null));

    try {
      final result = await action();

      return result.fold(
        onSuccess: (data) {
          safeEmit(state.copyWith(status: BlocStatus.success, data: data));
          onSuccess?.call(data);
          return data;
        },
        onFailure: (failure) {
          final message = failure.message;
          safeEmit(state.copyWith(status: BlocStatus.failure, error: message));
          onFailure?.call(message);
          return null;
        },
      );
    } catch (exception) {
      const message = 'Đã xảy ra lỗi không xác định';
      safeEmit(state.copyWith(status: BlocStatus.failure, error: message));
      onFailure?.call(message);
      return null;
    }
  }
}