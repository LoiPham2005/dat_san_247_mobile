// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/exceptions.dart
// ════════════════════════════════════════════════════════════════

/// Base Exception for the app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final String? requestId;
  final Map<String, dynamic>? extras;

  AppException({
    required this.message,
    this.code,
    this.statusCode,
    this.requestId,
    this.extras,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({super.message = 'No Internet Connection', super.code = 'NETWORK_ERROR'});
}

class TimeoutException extends AppException {
  TimeoutException({super.message = 'Request Timeout', super.code = 'TIMEOUT'});
}

class ServerException extends AppException {
  ServerException({
    super.message = 'Server Error',
    super.code,
    super.statusCode,
    super.requestId,
    super.extras,
  });
}

class AuthException extends AppException {
  final AuthExceptionType type;
  AuthException({
    required super.message,
    this.type = AuthExceptionType.unauthenticated,
    super.code,
    super.statusCode,
    super.requestId,
  });
}

enum AuthExceptionType { unauthenticated, unauthorized, tokenExpired, refreshFailed }

class DataException extends AppException {
  final DataExceptionType type;
  final Map<String, String>? fieldErrors;

  DataException({
    required super.message,
    this.type = DataExceptionType.unknown,
    this.fieldErrors,
    super.code,
    super.statusCode,
    super.requestId,
  });
}

enum DataExceptionType { notFound, validation, conflict, payloadTooLarge, unknown }

class StorageException extends AppException {
  final StorageExceptionType type;
  StorageException({
    super.message = 'Storage Error',
    this.type = StorageExceptionType.unknown,
    super.code,
  });
}

enum StorageExceptionType { cache, database, file, unknown }

class CacheException extends StorageException {
  CacheException({super.message = 'Cache Error'}) : super(type: StorageExceptionType.cache);
}
