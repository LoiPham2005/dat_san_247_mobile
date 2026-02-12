import '../errors/error_handler.dart';
import '../errors/result.dart';

/// 🎯 Mixin cung cấp helper cho RemoteDataSources để xử lý try-catch và ErrorHandler tự động.
mixin RemoteDataSourceMixin {
  /// Thực thi một request API an toàn, tự động bắt lỗi và chuyển đổi sang [Result].
  Future<Result<T>> call<T>(Future<T> Function() action) async {
    try {
      final response = await action();
      return ResultSuccess(response);
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.toFailure(e, stackTrace));
    }
  }

  /// Thực thi một request API an toàn cho kiểu [bool] (thường dùng cho delete/update không data).
  Future<Result<bool>> callBool(Future<dynamic> Function() action) async {
    try {
      await action();
      return const ResultSuccess(true);
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.toFailure(e, stackTrace));
    }
  }
}
