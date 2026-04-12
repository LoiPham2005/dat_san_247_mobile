// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/failures.dart (PRODUCTION READY)
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

/// Base Failure - CHỈ chứa thông tin cho UI
/// Exception/StackTrace được log riêng, KHÔNG lưu trong Failure
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final int? statusCode;
  final String? requestId; // ✨ Dùng để trace log trên Backend
  final Map<String, dynamic>? extras; // ✨ Chứa dữ liệu thêm nếu cần

  const Failure({
    required this.message,
    this.code,
    this.statusCode,
    this.requestId,
    this.extras,
  });

  @override
  List<Object?> get props => [message, code, statusCode, requestId, extras];

  @override
  String toString() => message;
}

// ════════════════════════════════════════════════════════════════
// Network Failures
// ════════════════════════════════════════════════════════════════

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Không có kết nối mạng',
    super.code = 'NETWORK_ERROR',
    super.requestId,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Yêu cầu đã hết thời gian',
    super.code = 'TIMEOUT',
    super.requestId,
  });
}

class CancelledFailure extends Failure {
  const CancelledFailure({
    super.message = 'Yêu cầu đã bị hủy',
    super.code = 'CANCELLED',
    super.requestId,
  });
}

// ════════════════════════════════════════════════════════════════
// Server Failures
// ════════════════════════════════════════════════════════════════

class ServerFailure extends Failure {
  final DateTime? maintenanceEndTime;
  final Duration? retryAfter;

  const ServerFailure({
    super.message = 'Lỗi máy chủ',
    super.code,
    super.statusCode,
    super.requestId,
    super.extras,
    this.maintenanceEndTime,
    this.retryAfter,
  });

  bool get isMaintenance => maintenanceEndTime != null;
  bool get isRateLimited => retryAfter != null;

  @override
  List<Object?> get props => [...super.props, maintenanceEndTime, retryAfter];
}

// ════════════════════════════════════════════════════════════════
// Auth Failures
// ════════════════════════════════════════════════════════════════

class AuthFailure extends Failure {
  final AuthFailureType type;

  const AuthFailure({
    required super.message,
    this.type = AuthFailureType.unauthenticated,
    super.code,
    super.statusCode,
    super.requestId,
    super.extras,
  });

  bool get needsReLogin => type != AuthFailureType.unauthorized;

  @override
  List<Object?> get props => [...super.props, type];
}

enum AuthFailureType {
  unauthenticated, // 401
  unauthorized, // 403
  tokenExpired,
  refreshFailed,
}

// ════════════════════════════════════════════════════════════════
// Data Failures
// ════════════════════════════════════════════════════════════════

class DataFailure extends Failure {
  final DataFailureType type;
  final Map<String, String>? fieldErrors;
  final List<String>? globalErrors;
  final int? maxSize;

  const DataFailure({
    required super.message,
    this.type = DataFailureType.unknown,
    this.fieldErrors,
    this.globalErrors,
    this.maxSize,
    super.code,
    super.statusCode,
    super.requestId,
    super.extras,
  });

  String get firstError {
    if (fieldErrors?.isNotEmpty == true) return fieldErrors!.values.first;
    if (globalErrors?.isNotEmpty == true) return globalErrors!.first;
    return message;
  }

  String? fieldError(String field) => fieldErrors?[field];

  @override
  List<Object?> get props => [
        ...super.props,
        type,
        fieldErrors,
        globalErrors,
        maxSize,
      ];
}

enum DataFailureType {
  notFound, // 404
  validation, // 400, 422
  conflict, // 409
  payloadTooLarge, // 413
  unknown,
}

// ════════════════════════════════════════════════════════════════
// Storage Failures
// ════════════════════════════════════════════════════════════════

class StorageFailure extends Failure {
  final StorageFailureType type;

  const StorageFailure({
    super.message = 'Lỗi lưu trữ',
    this.type = StorageFailureType.unknown,
    super.code,
    super.requestId,
  });

  @override
  List<Object?> get props => [...super.props, type];
}

enum StorageFailureType { cacheNotFound, databaseError, fileNotFound, unknown }

// ════════════════════════════════════════════════════════════════
// Unknown Failure
// ════════════════════════════════════════════════════════════════

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Đã xảy ra lỗi không xác định',
    super.code = 'UNKNOWN',
    super.requestId,
  });
}

// ════════════════════════════════════════════════════════════════
// Extension - Helpers
// ════════════════════════════════════════════════════════════════

extension FailureX on Failure {
  // Type checks
  bool get isNetwork => this is NetworkFailure || this is TimeoutFailure;
  bool get isAuth => this is AuthFailure;
  bool get isServer => this is ServerFailure;
  bool get isCancelled => this is CancelledFailure;
  bool get isValidation => this is DataFailure && (this as DataFailure).type == DataFailureType.validation;

  // Behavior
  bool get isRetryable {
    return switch (this) {
      NetworkFailure() || TimeoutFailure() => true,
      ServerFailure(:final isRateLimited, :final statusCode) =>
        isRateLimited || (statusCode ?? 0) >= 500,
      _ => false,
    };
  }

  bool get needsReLogin {
    return switch (this) {
      AuthFailure(:final needsReLogin) => needsReLogin,
      _ => false,
    };
  }

  Duration? get retryAfter {
    return switch (this) {
      ServerFailure(:final retryAfter) => retryAfter,
      NetworkFailure() || TimeoutFailure() => const Duration(seconds: 3),
      _ => null,
    };
  }

  // User-friendly message
  String get userMessage {
    return switch (this) {
      NetworkFailure() || TimeoutFailure() => 'Vui lòng kiểm tra kết nối mạng',
      AuthFailure(needsReLogin: true) => 'Vui lòng đăng nhập lại',
      ServerFailure(isMaintenance: true) => 'Hệ thống đang bảo trì',
      DataFailure(type: DataFailureType.validation, :final firstError) =>
        firstError,
      _ => message,
    };
  }

  // Debug info
  String get debugInfo {
    final sb = StringBuffer();
    sb.writeln('Failure: ${runtimeType}');
    sb.writeln('Message: $message');
    if (code != null) sb.writeln('Code: $code');
    if (statusCode != null) sb.writeln('Status: $statusCode');
    if (requestId != null) sb.writeln('Request ID: $requestId');
    return sb.toString();
  }

  // Suggested action
  FailureAction get action {
    return switch (this) {
      AuthFailure(needsReLogin: true) => FailureAction.reLogin,
      _ when isRetryable || isNetwork => FailureAction.retry,
      DataFailure(type: DataFailureType.validation) => FailureAction.fixInput,
      CancelledFailure() => FailureAction.none,
      _ => FailureAction.showError,
    };
  }
}

enum FailureAction { showError, retry, reLogin, fixInput, none }
