// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/dio_client.dart (UPDATED)
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/environment_config.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/smart_cache_interceptor.dart';

@LazySingleton()
class DioClient {
  late final Dio _dio;

  DioClient(
    AuthInterceptor authInterceptor,
    ErrorInterceptor errorInterceptor,
    LoggingInterceptor loggingInterceptor,
    SmartCacheInterceptor cacheInterceptor,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig.apiBaseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // ✅ UPDATED: Thứ tự interceptors rất quan trọng!
    _dio.interceptors.addAll([
      cacheInterceptor,      // 1. Cache
      authInterceptor,       // 2. Auth (token + 401 refresh)
      errorInterceptor,      // 3. Error logging
      loggingInterceptor,    // 4. Request/Response logging


      // PrettyDioLogger(
      //   requestHeader: false,
      //   requestBody: true,
      //   responseBody: true,
      //   responseHeader: false,
      //   error: true,
      //   compact: true,
      //   maxWidth: 90,
      //   logPrint: (log) {
      //     final msg = log.toString(); // ép Object -> String
      //     if (msg.startsWith('Request:')) {
      //       print('🚀 $msg');
      //     } else if (msg.startsWith('│ Body:') || msg.contains('"')) {
      //       print('📦 $msg');
      //     } else if (msg.startsWith('Response:')) {
      //       print('📥 $msg');
      //     } else if (msg.startsWith('Error:') || msg.contains('DioError')) {
      //       print('❌ $msg');
      //     } else {
      //       print('🔎 $msg');
      //     }
      //   },
      // )


    ]);
  }

  Dio get dio => _dio;

  // ═══════════════════════════════════════════════════════════════
  // HTTP Methods (Simple wrappers)
  // ═══════════════════════════════════════════════════════════════

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.get<T>(
    path,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) => _dio.post<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
  );

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.put<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.patch<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => _dio.delete<T>(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );

  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath),
      ...?data,
    });

    return _dio.post<T>(path, data: formData, options: options, onSendProgress: onSendProgress);
  }

  Future<Response> downloadFile(
    String url,
    String savePath, {
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) => _dio.download(
    url,
    savePath,
    options: options,
    onReceiveProgress: onReceiveProgress,
    cancelToken: cancelToken,
  );
}
