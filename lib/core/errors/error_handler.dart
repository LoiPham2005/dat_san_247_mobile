// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/error_handler.dart (PRODUCTION)
// ════════════════════════════════════════════════════════════════

import 'dart:io';

import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  // ════════════════════════════════════════════════════════════
  // Main Entry Point
  // ════════════════════════════════════════════════════════════

  /// Convert error to Failure + Log exception/stackTrace
  static Failure toFailure(Object error, [StackTrace? stackTrace]) {
    // ✅ LOG NGAY TẠI ĐÂY - Tách biệt logging và Failure
    _logError(error, stackTrace);

    return switch (error) {
      Failure() => error,
      DioException() => _fromDio(error),
      AppException() => _fromAppException(error),
      SocketException() => const NetworkFailure(message: 'Không có kết nối mạng'),
      Exception() => UnknownFailure(message: error.toString().replaceAll('Exception: ', '')),
      _ => UnknownFailure(message: error.toString()),
    };
  }

  // ════════════════════════════════════════════════════════════
  // Logging (Tách riêng)
  // ════════════════════════════════════════════════════════════

  static void _logError(Object error, [StackTrace? stackTrace]) {
    // Log error với đầy đủ context
    Logger.error('Error occurred: ${error.runtimeType}', error: error, stackTrace: stackTrace);

    // TODO: Thêm error tracking (Firebase Crashlytics, Sentry, etc.)
    // crashlytics.recordError(error, stackTrace);
  }

  // ════════════════════════════════════════════════════════════
  // Dio Exception → Failure
  // ════════════════════════════════════════════════════════════

  static Failure _fromDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutFailure(),

      DioExceptionType.connectionError => const NetworkFailure(),

      DioExceptionType.cancel => CancelledFailure(message: e.message ?? 'Đã hủy'),

      DioExceptionType.badCertificate => const NetworkFailure(
        message: 'Lỗi chứng chỉ bảo mật',
        code: 'SSL_ERROR',
      ),

      DioExceptionType.badResponse => _fromHttpResponse(e.response),

      DioExceptionType.unknown when e.error is SocketException => const NetworkFailure(),

      DioExceptionType.unknown => UnknownFailure(message: e.message ?? 'Lỗi không xác định'),
    };
  }

  // ════════════════════════════════════════════════════════════
  // HTTP Response → Failure
  // ════════════════════════════════════════════════════════════

  static Failure _fromHttpResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message = _extractMessage(data);

    return switch (statusCode) {
      // Auth
      401 => AuthFailure(
        message: message.ifEmpty('Phiên đăng nhập hết hạn'),
        type: _isTokenExpired(data)
            ? AuthFailureType.tokenExpired
            : AuthFailureType.unauthenticated,
        statusCode: 401,
      ),
      403 => AuthFailure(
        message: message.ifEmpty('Không có quyền truy cập'),
        type: AuthFailureType.unauthorized,
        statusCode: 403,
      ),

      // Data
      400 || 422 => DataFailure(
        message: message.ifEmpty('Dữ liệu không hợp lệ'),
        type: DataFailureType.validation,
        fieldErrors: _extractFieldErrors(data),
        globalErrors: _extractGlobalErrors(data),
        statusCode: statusCode,
      ),
      404 => DataFailure(
        message: message.ifEmpty('Không tìm thấy'),
        type: DataFailureType.notFound,
        statusCode: 404,
      ),
      409 => DataFailure(
        message: message.ifEmpty('Dữ liệu đã tồn tại'),
        type: DataFailureType.conflict,
        statusCode: 409,
      ),
      413 => DataFailure(
        message: message.ifEmpty('Dữ liệu quá lớn'),
        type: DataFailureType.payloadTooLarge,
        maxSize: _extractInt(data, ['maxSize', 'maxFileSize']),
        statusCode: 413,
      ),

      // Server
      429 => ServerFailure(
        message: message.ifEmpty('Quá nhiều yêu cầu'),
        retryAfter: _extractRetryAfter(response),
        statusCode: 429,
      ),
      500 ||
      502 ||
      504 => ServerFailure(message: 'Lỗi máy chủ, vui lòng thử lại', statusCode: statusCode),
      503 when _isMaintenance(data) => ServerFailure(
        message: message.ifEmpty('Hệ thống đang bảo trì'),
        maintenanceEndTime: _extractDateTime(data, ['estimatedEndTime', 'endTime']),
        statusCode: 503,
      ),
      503 => const ServerFailure(message: 'Dịch vụ tạm thời không khả dụng', statusCode: 503),

      _ => ServerFailure(message: message.ifEmpty('Đã xảy ra lỗi'), statusCode: statusCode),
    };
  }

  // ════════════════════════════════════════════════════════════
  // App Exception → Failure
  // ════════════════════════════════════════════════════════════

  static Failure _fromAppException(AppException e) {
    return switch (e) {
      NetworkException() => NetworkFailure(message: e.message),
      TimeoutException() => TimeoutFailure(message: e.message),
      ServerException() => ServerFailure(message: e.message, statusCode: e.statusCode),
      AuthException() => AuthFailure(
        message: e.message,
        type: _mapAuthType(e.type),
        statusCode: e.statusCode,
      ),
      DataException() => DataFailure(
        message: e.message,
        type: _mapDataType(e.type),
        fieldErrors: e.fieldErrors,
        statusCode: e.statusCode,
      ),
      StorageException() => StorageFailure(message: e.message, type: _mapStorageType(e.type)),
      _ => UnknownFailure(message: e.message),
    };
  }

  // ════════════════════════════════════════════════════════════
  // Extractors
  // ════════════════════════════════════════════════════════════

  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['msg']?.toString() ??
          '';
    }
    return data is String ? data : '';
  }

  static Map<String, String>? _extractFieldErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final errors = data['errors'] ?? data['fieldErrors'];
    if (errors is! Map<String, dynamic>) return null;
    return errors.map((k, v) => MapEntry(k, v is List ? v.first.toString() : v.toString()));
  }

  static List<String>? _extractGlobalErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final errors = data['globalErrors'];
    return errors is List ? errors.map((e) => e.toString()).toList() : null;
  }

  static int? _extractInt(dynamic data, List<String> keys) {
    if (data is! Map<String, dynamic>) return null;
    for (final key in keys) {
      final value = data[key];
      if (value is int) return value;
    }
    return null;
  }

  static DateTime? _extractDateTime(dynamic data, List<String> keys) {
    if (data is! Map<String, dynamic>) return null;
    for (final key in keys) {
      final value = data[key];
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static Duration? _extractRetryAfter(Response? response) {
    final retryAfter = response?.headers.value('retry-after');
    if (retryAfter == null) return null;
    final seconds = int.tryParse(retryAfter);
    return seconds != null ? Duration(seconds: seconds) : null;
  }

  static bool _isTokenExpired(dynamic data) {
    if (data is! Map<String, dynamic>) return false;
    final code = (data['code'] ?? data['errorCode'])?.toString().toLowerCase() ?? '';
    return code.contains('token_expired') || code.contains('jwt_expired');
  }

  static bool _isMaintenance(dynamic data) {
    if (data is! Map<String, dynamic>) return false;
    final code = (data['code'] ?? data['errorCode'])?.toString().toLowerCase() ?? '';
    return code.contains('maintenance');
  }

  // ════════════════════════════════════════════════════════════
  // Type Mappers
  // ════════════════════════════════════════════════════════════

  static AuthFailureType _mapAuthType(AuthExceptionType t) => switch (t) {
    AuthExceptionType.unauthenticated => AuthFailureType.unauthenticated,
    AuthExceptionType.unauthorized => AuthFailureType.unauthorized,
    AuthExceptionType.tokenExpired => AuthFailureType.tokenExpired,
    AuthExceptionType.refreshFailed => AuthFailureType.refreshFailed,
  };

  static DataFailureType _mapDataType(DataExceptionType t) => switch (t) {
    DataExceptionType.notFound => DataFailureType.notFound,
    DataExceptionType.validation => DataFailureType.validation,
    DataExceptionType.conflict => DataFailureType.conflict,
    DataExceptionType.payloadTooLarge => DataFailureType.payloadTooLarge,
    DataExceptionType.unknown => DataFailureType.unknown,
  };

  static StorageFailureType _mapStorageType(StorageExceptionType t) => switch (t) {
    StorageExceptionType.cache => StorageFailureType.cacheNotFound,
    StorageExceptionType.database => StorageFailureType.databaseError,
    StorageExceptionType.file => StorageFailureType.fileNotFound,
    StorageExceptionType.unknown => StorageFailureType.unknown,
  };

  // ════════════════════════════════════════════════════════════
  // Quick Checks
  // ════════════════════════════════════════════════════════════

  static bool isNetworkError(Object e) =>
      e is NetworkException ||
      e is NetworkFailure ||
      e is SocketException ||
      (e is DioException &&
          (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout));

  static bool isAuthError(Object e) =>
      e is AuthException ||
      e is AuthFailure ||
      (e is DioException && [401, 403].contains(e.response?.statusCode));

  static bool isRetryable(Object e) {
    if (e is Failure) return e.isRetryable;
    return isNetworkError(e) || (e is DioException && (e.response?.statusCode ?? 0) >= 500);
  }
}

// ════════════════════════════════════════════════════════════
// String Extension Helper
// ════════════════════════════════════════════════════════════

extension _StringX on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
