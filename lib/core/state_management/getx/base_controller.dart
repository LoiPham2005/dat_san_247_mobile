// ════════════════════════════════════════════════════════════════
// 📁 lib/core/state_management/getx/base_controller.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter_base_template/core/errors/failures.dart';
import 'package:flutter_base_template/core/errors/result.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  void showLoading() => isLoading.value = true;
  void hideLoading() => isLoading.value = false;

  /// Thực thi UseCase theo Result pattern
  /// 
  /// Example:
  /// ```dart
  /// await executeUseCase(
  ///   action: () => loginUseCase(email, password),
  ///   onSuccess: (user) => Get.offAllNamed(Routes.HOME),
  ///   onFailure: (failure) => showErrorSnackBar(failure.message),
  /// );
  /// ```
  Future<void> execute<T>({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure, // ✅ Pass full Failure object
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) this.showLoading();

      final result = await action();

      result.fold(
        onSuccess: (data) {
          errorMessage.value = '';
          onSuccess?.call(data);
        },
        onFailure: (failure) {
          errorMessage.value = failure.message;
          onFailure?.call(failure); // ✅ Pass Failure object
        },
      );
    } catch (exception) {
      const unknownFailure = UnknownFailure(message: 'Đã xảy ra lỗi không xác định');
      errorMessage.value = unknownFailure.message;
      onFailure?.call(unknownFailure);
    } finally {
      if (showLoading) hideLoading();
    }
  }

  /// Version đơn giản chỉ cần String message
  Future<void> executeWithMessage<T>({
    required Future<Result<T>> Function() action,
    void Function(T data)? onSuccess,
    void Function(String message)? onFailure, // ✅ Rõ ràng là message
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) this.showLoading();

      final result = await action();

      result.fold(
        onSuccess: (data) {
          errorMessage.value = '';
          onSuccess?.call(data);
        },
        onFailure: (failure) {
          final message = failure.message;
          errorMessage.value = message;
          onFailure?.call(message);
        },
      );
    } catch (exception) {
      const message = 'Đã xảy ra lỗi không xác định';
      errorMessage.value = message;
      onFailure?.call(message);
    } finally {
      if (showLoading) hideLoading();
    }
  }

  /// Clear error message
  void clearError() => errorMessage.value = '';
}