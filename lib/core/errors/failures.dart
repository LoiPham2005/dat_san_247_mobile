// ════════════════════════════════════════════════════════════════
// 📁 lib/core/errors/failures.dart
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';

/// Base Failure - Dùng cho UI layer (presentation)
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
  
  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Không có kết nối mạng',
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Lỗi lưu trữ dữ liệu',
    super.code,
  });
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Xác thực thất bại',
    super.code = '401',
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Bạn không có quyền truy cập',
    super.code = '403',
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Không tìm thấy dữ liệu',
    super.code = '404',
  });
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  
  const ValidationFailure({
    super.message = 'Dữ liệu không hợp lệ',
    super.code,
    this.errors,
  });
  
  @override
  List<Object?> get props => [message, code, errors];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Hết thời gian chờ',
    super.code,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Đã xảy ra lỗi không xác định',
    super.code,
  });
}