// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/api_response.dart
// ════════════════════════════════════════════════════════════════

/// Standard API response wrapper
/// Khớp hoàn toàn với TransformInterceptor của Backend NestJS
class ApiResponse<T> {
  final bool isSuccess;
  final String? message;
  final T? data;
  final int? statusCode;
  final dynamic meta;

  const ApiResponse({
    required this.isSuccess,
    this.message,
    this.data,
    this.statusCode,
    this.meta,
  });

  /// Parse từ JSON với generic T
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      isSuccess: json['success'] ?? false,
      message: json['message']?.toString(),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      statusCode: json['statusCode'] as int?,
      meta: json['meta'],
    );
  }

  /// Tiện ích bóc tách dữ liệu an toàn
  T get unwrappedData {
    if (data == null) {
      throw Exception('Response data is null');
    }
    return data!;
  }
}
