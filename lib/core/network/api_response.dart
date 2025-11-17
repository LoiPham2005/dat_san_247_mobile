// lib/core/network/api_response.dart
class ApiResponse<T> {
  /// Một số API trả "success", số khác trả "result"
  final bool success;
  final bool result;
  final String? message;
  final T? data;
  final String? error;
  final int? code;
  final bool? tokenExpired; // ✅ Token hết hạn

  const ApiResponse({
    required this.success,
    required this.result,
    this.message,
    this.data,
    this.error,
    this.code,
    this.tokenExpired,
  });

  /// ✅ Getter tiện lợi (nếu API có thể trả `success` hoặc `result`)
  bool get isSuccess => success || result;

  /// ✅ Parse từ JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    final successValue = json['success'] ?? false;
    final resultValue = json['result'] ?? successValue; // fallback

    bool? tokenExpiredValue;
    if (json['tokenExpired'] != null) {
      final val = json['tokenExpired'];
      tokenExpiredValue = val is bool
          ? val
          : val.toString().toLowerCase() == 'true';
    }

    return ApiResponse<T>(
      success: successValue is bool
          ? successValue
          : successValue.toString().toLowerCase() == 'true',
      result: resultValue is bool
          ? resultValue
          : resultValue.toString().toLowerCase() == 'true',
      message: json['message']?.toString(),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error']?.toString(),
      code: json['code'] is int ? json['code'] : int.tryParse('${json['code']}'),
      tokenExpired: tokenExpiredValue,
    );
  }

  /// ✅ Convert lại thành JSON
  Map<String, dynamic> toJson(Object? Function(T value)? toJsonT) {
    return {
      'success': success,
      'result': result,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'error': error,
      'code': code,
      'tokenExpired': tokenExpired,
    };
  }
}
