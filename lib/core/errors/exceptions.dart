// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/exceptions.dart
// ════════════════════════════════════════════════════════════════

/// Base exception cho toàn bộ app
class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server trả về lỗi (5xx)
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'ServerException: $message';
}

/// Lỗi kết nối mạng
class NetworkException extends AppException {
  NetworkException({
    super.message = 'Lỗi kết nối mạng',
    super.code,
  });
  
  @override
  String toString() => 'NetworkException: $message';
}

/// Lỗi cache/storage
class CacheException extends AppException {
  CacheException({
    super.message = 'Lỗi cache',
    super.code,
  });
  
  @override
  String toString() => 'CacheException: $message';
}

/// Lỗi xác thực (401)
class AuthenticationException extends AppException {
  AuthenticationException({
    super.message = 'Lỗi xác thực',
    super.code = '401',
  });
  
  @override
  String toString() => 'AuthenticationException: $message';
}

/// Không có quyền (403)
class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Không có quyền truy cập',
    super.code = '403',
  });
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Không tìm thấy (404)
class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'Không tìm thấy dữ liệu',
    super.code = '404',
  });
  
  @override
  String toString() => 'NotFoundException: $message';
}

/// Lỗi validation (400, 422)
class ValidationException extends AppException {
  final Map<String, String>? errors;
  
  ValidationException({
    super.message = 'Dữ liệu không hợp lệ',
    super.code,
    this.errors,
  });
  
  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return 'ValidationException: $message\nErrors: $errors';
    }
    return 'ValidationException: $message';
  }
}

/// Lỗi timeout
class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Hết thời gian chờ',
    super.code,
  });
  
  @override
  String toString() => 'TimeoutException: $message';
}