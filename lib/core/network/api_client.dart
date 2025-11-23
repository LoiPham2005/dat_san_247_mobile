// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/api_client.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:dat_san_247_mobile/core/cache/cache_strategy.dart';
import 'package:dat_san_247_mobile/core/network/interceptors/smart_cache_interceptor.dart';
import 'package:injectable/injectable.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../errors/result.dart';
import 'api_response.dart';
import 'dio_client.dart';
import 'network_info.dart';

typedef JsonParser<T> = T Function(dynamic json);

/// 🎯 Production-ready API client with error handling, retry, and caching
@LazySingleton()
class ApiClient {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;

  ApiClient(this._dioClient, this._networkInfo);

  // ═══════════════════════════════════════════════════════════════
  // Core Request Method (DRY principle)
  // ═══════════════════════════════════════════════════════════════

  /// Generic request handler with retry and network check
  Future<Result<T>> _request<T>(
    Future<Response> Function() request,
    JsonParser<T> fromJson, {
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    // 1. Check network
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }

    // 2. Execute with retry
    int attempt = 0;
    while (true) {
      try {
        final response = await request();
        final data = unwrap
            ? _unwrapApiResponse<T>(response.data, fromJson)
            : fromJson(response.data);
        return ResultSuccess(data);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          return _handleError<T>(e);
        }
        await Future.delayed(Duration(seconds: attempt));
      }
    }
  }

  /// Unwrap standard API response format
  T _unwrapApiResponse<T>(dynamic data, JsonParser<T> fromJson) {
    if (data is! Map<String, dynamic>) {
      return fromJson(data);
    }

    final response = ApiResponse<T>.fromJson(
      data,
      (json) => json == null ? fromJson(data) : fromJson(json),
    );

    if (response.isSuccess) {
      return response.data ?? fromJson(data);
    }

    throw ServerException(
      message: response.error ?? response.message ?? 'Request failed',
      code: response.code?.toString(),
    );
  }

  /// Handle errors and convert to Result
  Result<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      return ResultFailure(_mapDioError(error));
    }
    if (error is ServerException) {
      return ResultFailure(ServerFailure(message: error.message, code: error.code));
    }
    return ResultFailure(UnknownFailure(message: error.toString()));
  }

  /// Map Dio errors to Failures
  Failure _mapDioError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const TimeoutFailure(),
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.badResponse => _mapStatusCodeError(error.response),
      _ => UnknownFailure(message: error.message ?? 'Unknown error'),
    };
  }

  /// Map HTTP status codes to Failures
  // ✅ Alternative: More elegant with pattern matching
  Failure _mapStatusCodeError(Response? response) {
    return switch (response?.statusCode) {
      null => const UnknownFailure(message: 'No response from server'),
      401 => const AuthenticationFailure(),
      403 => const UnauthorizedFailure(),
      404 => const NotFoundFailure(),
      408 => const TimeoutFailure(),
      422 => ValidationFailure(
        message: response?.data?['message'] ?? 'Validation failed',
        errors: response?.data?['errors'],
      ),
      >= 500 => ServerFailure(
        message: response?.data?['message'] ?? 'Server error',
        code: response?.statusCode?.toString(),
      ),
      _ => UnknownFailure(message: response?.data?['message'] ?? 'Request failed'),
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // HTTP Methods
  // ═══════════════════════════════════════════════════════════════

  /// GET request
  Future<Result<T>> get<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _request(
      () => _dioClient.get(path, queryParameters: queryParameters, options: options),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// POST request
  Future<Result<T>> post<T>(
    String path,
    JsonParser<T> fromJson, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _request(
      () => _dioClient.post(path, data: data, queryParameters: queryParameters, options: options),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// PUT request
  Future<Result<T>> put<T>(
    String path,
    JsonParser<T> fromJson, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _request(
      () => _dioClient.put(path, data: data, queryParameters: queryParameters, options: options),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// PATCH request
  Future<Result<T>> patch<T>(
    String path,
    JsonParser<T> fromJson, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _request(
      () => _dioClient.patch(path, data: data, queryParameters: queryParameters, options: options),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// DELETE request
  Future<Result<bool>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 1,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }

    int attempt = 0;
    while (true) {
      try {
        final response = await _dioClient.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );

        // Check success from response
        if (response.data is Map<String, dynamic>) {
          final success =
              response.data['success'] ??
              response.data['result'] ??
              (response.statusCode == 200 || response.statusCode == 204);
          if (!success) {
            throw ServerException(message: response.data['message'] ?? 'Delete failed');
          }
        }

        return const ResultSuccess(true);
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          return _handleError<bool>(e);
        }
        await Future.delayed(Duration(seconds: attempt));
      }
    }
  }

  /// Upload file with progress
  Future<Result<T>> uploadFile<T>(
    String path,
    String filePath, {
    JsonParser<T>? fromJson,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Options? options,
    ProgressCallback? onProgress,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure()) as Result<T>;
    }

    try {
      final response = await _dioClient.uploadFile(
        path,
        filePath,
        fieldName: fieldName,
        data: data,
        options: options,
        onSendProgress: onProgress,
      );

      if (fromJson != null) {
        final result = _unwrapApiResponse<T>(response.data, fromJson);
        return ResultSuccess(result);
      }

      return const ResultSuccess(true) as Result<T>;
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Download file with progress
  Future<Result<String>> downloadFile(
    String urlPath,
    String savePath, {
    Options? options,
    ProgressCallback? onProgress,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }

    try {
      await _dioClient.downloadFile(
        urlPath,
        savePath,
        options: options,
        onReceiveProgress: onProgress,
      );
      return ResultSuccess(savePath);
    } catch (e) {
      return _handleError<String>(e);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Convenience Methods
  // ═══════════════════════════════════════════════════════════════

  /// GET with custom cache strategy
  Future<Result<T>> getWithCache<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    CacheStrategy? strategy,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return get(
      path,
      fromJson,
      queryParameters: queryParameters,
      options: strategy != null ? SmartCacheInterceptor.withStrategy(strategy) : null,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// GET and force refresh (bypass cache)
  Future<Result<T>> getForceRefresh<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return get(
      path,
      fromJson,
      queryParameters: queryParameters,
      options: SmartCacheInterceptor.forceRefresh(),
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }
}
