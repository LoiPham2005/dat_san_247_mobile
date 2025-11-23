// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/dio_client.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../config/environment_config.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/smart_cache_interceptor.dart';

/// 🔧 Low-level Dio wrapper
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor order matters!
    _dio.interceptors.addAll([
      cacheInterceptor,      // 1. Cache
      authInterceptor,       // 2. Auth
      errorInterceptor,      // 3. Error handling
      loggingInterceptor,    // 4. Logging
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
  }) =>
      _dio.get<T>(
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
  }) =>
      _dio.post<T>(
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
  }) =>
      _dio.put<T>(
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
  }) =>
      _dio.patch<T>(
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
  }) =>
      _dio.delete<T>(
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

    return _dio.post<T>(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response> downloadFile(
    String url,
    String savePath, {
    Options? options,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) =>
      _dio.download(
        url,
        savePath,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
}
