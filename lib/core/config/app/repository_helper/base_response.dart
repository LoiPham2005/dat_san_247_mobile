import 'package:dio/dio.dart';

class BaseResponse<T> {
  final String? userId;
  final bool? result;
  final bool? success;
  final int? status;
  final String? message;
  final T? data;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final String? expiresAt;

  const BaseResponse({
    this.userId,
    this.result,
    this.success,
    this.status,
    this.message,
    this.data,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresAt,
  });

  bool get isSuccess =>
      result == true || success == true || status == 200 || status == 201;

  factory BaseResponse.success({
    required T data,
    String? message,
    String? accessToken,
    String? refreshToken,
  }) {
    return BaseResponse(
      result: true,
      success: true,
      status: 200,
      data: data,
      message: message,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  factory BaseResponse.error({required String message, int? status}) {
    return BaseResponse(
      result: false,
      success: false,
      message: message,
      status: status,
    );
  }

  BaseResponse<T> copyWith({
    String? userId,
    bool? result,
    bool? success,
    int? status,
    String? message,
    T? data,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? expiresAt,
  }) {
    return BaseResponse<T>(
      userId: userId ?? this.userId,
      result: result ?? this.result,
      success: success ?? this.success,
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// ✅ Parse 1 object từ Dio Response
  static BaseResponse<T> fromResponse<T>(
    Response response,
    //  {
    // required T Function(Map<String, dynamic>) fromJson,
    T Function(Map<String, dynamic>) fromJson,{
    String dataKey = 'data',
    dynamic Function(Map<String, dynamic> map)? extract,
  }) {
    try {
      final map = response.data;
      final dynamic rawData = extract != null ? extract(map) : map[dataKey];
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          map['result'] == true ||
          map['success'] == true ||
          map['status'] == 200) {
        return BaseResponse<T>(
          result: map['result'] ?? true,
          success: map['success'] ?? true,
          status: response.statusCode,
          message: map['message'],
          data: rawData != null ? fromJson(rawData) : null,
          accessToken: map['accessToken'],
          refreshToken: map['refreshToken'],
          tokenType: map['token_type'],
          expiresAt: map['expires_at'],
        );
      } else {
        return BaseResponse<T>(
          result: false,
          success: false,
          status: response.statusCode,
          message: map['message'] ?? 'Request failed',
        );
      }
    } catch (e) {
      // return BaseResponse<T>(
      //   result: false,
      //   success: false,
      //   message: 'Failed to parse response: ${e.toString()}',
      // );
      return BaseResponse.handleError<T>(e);
    }
  }

  /// ✅ Parse danh sách object
  static BaseResponse<List<T>> listFromResponse<T>(
    Response response, 
    // {
    // required T Function(Map<String, dynamic>) fromJson,
    T Function(Map<String, dynamic>) fromJson,{
    String dataKey = 'data',
    dynamic Function(Map<String, dynamic> map)? extract,
  }) {
    try {
      final map = response.data;
      final dynamic rawData = extract != null ? extract(map) : map[dataKey];
      if (response.statusCode == 200) {
        if (rawData is List) {
          final list = rawData
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();

          return BaseResponse<List<T>>(
            result: true,
            success: true,
            status: response.statusCode,
            message: map['message'],
            data: list,
          );
        } else {
          return BaseResponse<List<T>>(
            result: false,
            success: false,
            message: 'Invalid data format: expected List',
          );
        }
      } else {
        return BaseResponse<List<T>>(
          result: false,
          success: false,
          status: response.statusCode,
          message: map['message'] ?? 'Request failed',
        );
      }
    } catch (e) {
      // return BaseResponse<List<T>>(
      //   result: false,
      //   success: false,
      //   message: 'Failed to parse list response: ${e.toString()}',
      // );
      return BaseResponse.handleError(e);
    }
  }

  /// ✅ Chuyển lỗi DioException thành BaseResponse
  static BaseResponse<T> handleError<T>(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return BaseResponse<T>.error(message: '⏱ Timeout, try again later');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final msg = error.response?.data?['message'] ?? 'Server error';
          // prettyPrintJson(error.response?.data);
          return BaseResponse<T>.error(message: msg, status: statusCode);
        case DioExceptionType.cancel:
          return BaseResponse<T>.error(message: '❌ Request was cancelled');
        case DioExceptionType.connectionError:
          return BaseResponse<T>.error(message: '⚠ No internet connection');
        default:
          return BaseResponse<T>.error(message: '❓ Unknown Dio error');
      }
    }

    return BaseResponse<T>.error(message: '❗ Unexpected error: $error');
  }
}
