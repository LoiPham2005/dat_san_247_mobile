import 'dart:convert';

import 'package:dat_san_247_mobile/core/lang/locale_keys.dart';
import 'package:dat_san_247_mobile/core/localization/app_localization.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dat_san_247_mobile/core/api/api_path.dart';
import 'package:dat_san_247_mobile/core/api/check_auth_service.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:dat_san_247_mobile/core/lang/locale_keys.dart';

// === Hằng số lỗi mạng ===
abstract class NetworkConstants {
  NetworkConstants._();

  // static const ERROR_TITLE = LocaleKeys.error_unknown;
  // static const ERROR_NETWORK = LocaleKeys.error_network;
  // static const ERROR_BAD_REQUEST = LocaleKeys.error_bad_request;
  // static const ERROR_UNAUTHORIZED = LocaleKeys.error_unauthorized;
  // static const ERROR_FORBIDDEN = LocaleKeys.error_forbidden;
  // static const ERROR_NOT_FOUND = LocaleKeys.error_not_found;
  // static const ERROR_METHOD_NOT_ALLOWED = LocaleKeys.error_method_not_allowed;
  // static const ERROR_REQUEST_TIMEOUT = LocaleKeys.error_request_timeout;
  // static const ERROR_CONFLICT = LocaleKeys.error_conflict;
  // static const ERROR_INTERNAL_SERVER_ERROR =
  //     LocaleKeys.error_internal_server_error;
  // static const ERROR_SERVER_UNAVAILABLE = LocaleKeys.error_server_unavailable;
  // static const ERROR_GATEWAY_TIMEOUT = LocaleKeys.error_gateway_timeout;
  // static const ERROR_UNKNOWN = LocaleKeys.error_unknown;


  static final ERROR_TITLE = Language.current.errorUnknown;
  static final ERROR_NETWORK = Language.current.errorNetwork;
  static final ERROR_BAD_REQUEST = Language.current.errorBadRequest;
  static final ERROR_UNAUTHORIZED = Language.current.errorUnauthorized;
  static final ERROR_FORBIDDEN = Language.current.errorForbidden;
  static final ERROR_NOT_FOUND = Language.current.errorNotFound;
  static final ERROR_METHOD_NOT_ALLOWED = Language.current.errorMethodNotAllowed;
  static final ERROR_REQUEST_TIMEOUT = Language.current.errorRequestTimeout;
  static final ERROR_CONFLICT = Language.current.errorConflict;
  static final ERROR_INTERNAL_SERVER_ERROR =
      Language.current.errorInternalServerError;
  static final ERROR_SERVER_UNAVAILABLE = Language.current.errorServerUnavailable;
  static final ERROR_GATEWAY_TIMEOUT = Language.current.errorGatewayTimeout;
  static final ERROR_UNKNOWN = Language.current.errorUnknown;
}

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiPath.domain,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );

    // Sửa lại cấu hình PrettyDioLogger
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 150, // Tăng độ rộng tối đa để tránh ngắt dòng
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        // onResponse: _onResponse, // Thêm onResponse interceptor
        onError: _onError,
      ),
    );
  }

  /// Gắn token & in log request
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {

      // Không check refresh token cho API refresh và login
      if (options.path == '/auth/refresh-token' || 
          options.path == '/auth/login') {
        return handler.next(options);
      }

      // check & refresh token trước khi gắn vào header
      await CheckAuthService.instance.checkAndRefreshToken();

      final token = await SharedPrefs.getString(DbKeysLocal.accessToken);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Token error: $e");
      }
    }

    handler.next(options);
  }

  // Thêm method xử lý response
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      if (response.data is Map) {
        final data = response.data as Map;
        if (data['data'] is Map && data['data']['accessToken'] != null) {
          // Đảm bảo token được xử lý đúng
          final accessToken = data['data']['accessToken'] as String;
          final refreshToken = data['data']['refreshToken'] as String;

          // Lưu token ngay khi nhận được
          SharedPrefs.setString(DbKeysLocal.accessToken, accessToken);
          SharedPrefs.setString(DbKeysLocal.refreshToken, refreshToken);
        }
      }
    } catch (e) {
      print('Error processing response: $e');
    }

    handler.next(response);
  }

  /// Xử lý lỗi chung
  void _onError(DioException error, ErrorInterceptorHandler handler) {
    final res = error.response;
    String message = "Lỗi không xác định";

    if (res != null) {
      switch (res.statusCode) {
        case 400:
          message = NetworkConstants.ERROR_BAD_REQUEST;
          break;
        case 401:
          message = NetworkConstants.ERROR_UNAUTHORIZED;
          break;
        case 403:
          message = NetworkConstants.ERROR_FORBIDDEN;
          break;
        case 404:
          message = NetworkConstants.ERROR_NOT_FOUND;
          break;
        case 405:
          message = NetworkConstants.ERROR_METHOD_NOT_ALLOWED;
          break;
        case 408:
          message = NetworkConstants.ERROR_REQUEST_TIMEOUT;
          break;
        case 409:
          message = NetworkConstants.ERROR_CONFLICT;
          break;
        case 500:
          message = NetworkConstants.ERROR_INTERNAL_SERVER_ERROR;
          break;
        case 502:
          message = NetworkConstants.ERROR_SERVER_UNAVAILABLE;
          break;
        case 504:
          message = NetworkConstants.ERROR_GATEWAY_TIMEOUT;
          break;
        default:
          message = res.data?['message'] ?? NetworkConstants.ERROR_UNKNOWN;
      }
    } else {
      message = NetworkConstants.ERROR_NETWORK;
    }

    if (kDebugMode) {
      print("❌ ERROR [${res?.statusCode}]: $message");
    }

    handler.next(
      DioException(
        requestOptions: error.requestOptions,
        response: res,
        type: error.type,
        message: message,
        error: message,
      ),
    );
  }

  // === Method wrapper chuẩn ===

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}
