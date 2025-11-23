// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/error_handler.dart
// ════════════════════════════════════════════════════════════════
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Convert Exception thành Failure (để dùng trong UI)
  static Failure exceptionToFailure(Object exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message, code: exception.code);
    }

    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message, code: exception.code);
    }

    if (exception is CacheException) {
      return CacheFailure(message: exception.message, code: exception.code);
    }

    if (exception is AuthenticationException) {
      return AuthenticationFailure(message: exception.message, code: exception.code);
    }

    if (exception is UnauthorizedException) {
      return UnauthorizedFailure(message: exception.message, code: exception.code);
    }

    if (exception is NotFoundException) {
      return NotFoundFailure(message: exception.message, code: exception.code);
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        errors: exception.errors,
      );
    }

    if (exception is TimeoutException) {
      return TimeoutFailure(message: exception.message, code: exception.code);
    }

    return UnknownFailure(message: exception.toString());
  }

  /// Parse DioException thành AppException
  static AppException parseDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Hết thời gian chờ kết nối');

      case DioExceptionType.badResponse:
        return _parseHttpStatusCode(
          error.response?.statusCode,
          error.response?.data,
        );

      case DioExceptionType.cancel:
        return AppException(message: 'Yêu cầu đã bị hủy');

      case DioExceptionType.connectionError:
        return NetworkException(message: 'Không có kết nối mạng');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException(message: 'Không có kết nối mạng');
        }
        return AppException(message: 'Đã xảy ra lỗi không xác định');

      default:
        return AppException(message: 'Đã xảy ra lỗi không xác định');
    }
  }

  /// Parse HTTP status code thành Exception tương ứng
  static AppException _parseHttpStatusCode(int? statusCode, dynamic responseData) {
    final message = _extractErrorMessage(responseData);

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message,
          code: '400',
          errors: _extractValidationErrors(responseData),
        );

      case 401:
        return AuthenticationException(
          message: message.isNotEmpty ? message : 'Phiên đăng nhập hết hạn',
        );

      case 403:
        return UnauthorizedException(
          message: message.isNotEmpty ? message : 'Bạn không có quyền truy cập',
        );

      case 404:
        return NotFoundException(
          message: message.isNotEmpty ? message : 'Không tìm thấy dữ liệu',
        );

      case 422:
        return ValidationException(
          message: message,
          code: '422',
          errors: _extractValidationErrors(responseData),
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Lỗi máy chủ, vui lòng thử lại sau',
          code: statusCode.toString(),
        );

      default:
        return ServerException(
          message: message.isNotEmpty ? message : 'Đã xảy ra lỗi',
          code: statusCode?.toString(),
        );
    }
  }

  /// Trích xuất error message từ response
  static String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Thử các key phổ biến
      return data['message']?.toString() ??
             data['error']?.toString() ??
             data['msg']?.toString() ??
             '';
    }
    return '';
  }

  /// Trích xuất validation errors từ response
  static Map<String, String>? _extractValidationErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final errors = data['errors'];
    if (errors is! Map<String, dynamic>) return null;

    return errors.map((key, value) {
      if (value is List && value.isNotEmpty) {
        return MapEntry(key, value.first.toString());
      }
      return MapEntry(key, value.toString());
    });
  }

  /// Log error cho debugging
  static void logError(Object error, [StackTrace? stackTrace]) {
    Logger.error('Unhandled error: $error', error: error, stackTrace: stackTrace);
  }
}
