// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/exceptions.dart (OPTIMIZED - Giảm 60%)
// ════════════════════════════════════════════════════════════════

/// Base exception cho toàn bộ app
class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;

  const AppException({
    required this.message,
    this.code,
    this.statusCode,
    this.originalError,
    this.stackTrace,
    this.metadata,
  });

  @override
  String toString() =>
      '$runtimeType: $message${code != null ? ' ($code)' : ''}';
}

// ════════════════════════════════════════════════════════════════
// Network Exceptions
// ════════════════════════════════════════════════════════════════

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Không có kết nối mạng',
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

class TimeoutException extends AppException {
  final Duration? timeout;

  const TimeoutException({
    super.message = 'Hết thời gian chờ',
    super.code = 'TIMEOUT',
    this.timeout,
    super.originalError,
    super.stackTrace,
  });
}

// ════════════════════════════════════════════════════════════════
// Server Exceptions
// ════════════════════════════════════════════════════════════════

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

// ════════════════════════════════════════════════════════════════
// Auth Exceptions
// ════════════════════════════════════════════════════════════════

class AuthException extends AppException {
  final AuthExceptionType type;

  const AuthException({
    required super.message,
    this.type = AuthExceptionType.unauthenticated,
    super.code,
    super.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

enum AuthExceptionType {
  unauthenticated, // 401
  unauthorized, // 403
  tokenExpired,
  refreshFailed,
}

// ════════════════════════════════════════════════════════════════
// Data Exceptions
// ════════════════════════════════════════════════════════════════

class DataException extends AppException {
  final DataExceptionType type;
  final Map<String, String>? fieldErrors;

  const DataException({
    required super.message,
    this.type = DataExceptionType.unknown,
    this.fieldErrors,
    super.code,
    super.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

enum DataExceptionType {
  notFound, // 404
  validation, // 400, 422
  conflict, // 409
  payloadTooLarge, // 413
  unknown,
}

// ════════════════════════════════════════════════════════════════
// Storage Exceptions
// ════════════════════════════════════════════════════════════════

class StorageException extends AppException {
  final StorageExceptionType type;

  const StorageException({
    super.message = 'Lỗi lưu trữ',
    this.type = StorageExceptionType.unknown,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

enum StorageExceptionType { cache, database, file, unknown }
