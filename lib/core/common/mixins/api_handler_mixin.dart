// ════════════════════════════════════════════════════════════════
// 📁 lib/core/mixins/api_handler_mixin.dart
// ════════════════════════════════════════════════════════════════

import '../../base/errors/error_handler.dart';
import '../../base/errors/result.dart';

/// 🎯 Mixin giúp thực thi các lệnh gọi API một cách an toàn.
/// Tự động xử lý try-catch, bắt lỗi qua ErrorHandler và trả về [Result].
mixin ApiHandlerMixin {
  /// Thực thi một request API và trả về Result<T>
  Future<Result<T>> safeCall<T>(Future<T> Function() action) async {
    try {
      final response = await action();
      return ResultSuccess(response);
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.toFailure(e, stackTrace));
    }
  }

  /// Thực thi một request API trả về thành công/thất bại (bool)
  Future<Result<bool>> safeCallBool(Future<dynamic> Function() action) async {
    try {
      await action();
      return const ResultSuccess(true);
    } catch (e, stackTrace) {
      return ResultFailure(ErrorHandler.toFailure(e, stackTrace));
    }
  }
}
