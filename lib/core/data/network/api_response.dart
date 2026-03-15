// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/api_response.dart
// ════════════════════════════════════════════════════════════════

/// Standard API response wrapper
///
/// Hỗ trợ 2 dạng response phổ biến từ backend:
/// - `{ "success": true, "data": {...} }`
/// - `{ "result": true,  "data": {...} }`
class ApiResponse<T> {
  final bool isSuccess;
  final String? message;
  final T? data;
  final String? error;
  final int? code;

  const ApiResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.error,
    this.code,
  });

  /// Parse từ JSON — tự detect field `success` hoặc `result`
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    // Hỗ trợ cả "success" lẫn "result" từ các API khác nhau
    final rawSuccess = json['success'] ?? json['result'] ?? false;
    final isSuccess = rawSuccess is bool
        ? rawSuccess
        : rawSuccess.toString().toLowerCase() == 'true';

    return ApiResponse<T>(
      isSuccess: isSuccess,
      message: json['message']?.toString(),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error']?.toString(),
      code: json['code'] is int
          ? json['code']
          : int.tryParse('${json['code']}'),
    );
  }

  /// Convert thành JSON
  Map<String, dynamic> toJson(Object? Function(T value)? toJsonT) {
    return {
      'success': isSuccess,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'error': error,
      'code': code,
    };
  }
}
