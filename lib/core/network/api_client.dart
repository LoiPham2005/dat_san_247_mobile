// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/api_client.dart (ULTIMATE)
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/cache/cache_strategy.dart';
import 'package:dat_san_247_mobile/core/network/interceptors/smart_cache_interceptor.dart';
import 'package:dio/dio.dart';
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

  // ✅ THÊM: Global cancel token management
  final Map<String, CancelToken> _cancelTokens = {};

  ApiClient(this._dioClient, this._networkInfo);

  // ═══════════════════════════════════════════════════════════════
  // Cancel Token Management
  // ═══════════════════════════════════════════════════════════════

  /// ✅ THÊM: Get or create cancel token for a request
  CancelToken getCancelToken(String tag) {
    _cancelTokens[tag]?.cancel('Cancelled by new request');
    _cancelTokens[tag] = CancelToken();
    return _cancelTokens[tag]!;
  }

  /// ✅ THÊM: Cancel a specific request
  void cancelRequest(String tag, [String? reason]) {
    _cancelTokens[tag]?.cancel(reason ?? 'Request cancelled');
    _cancelTokens.remove(tag);
  }

  /// ✅ THÊM: Cancel all pending requests
  void cancelAllRequests([String? reason]) {
    for (final token in _cancelTokens.values) {
      token.cancel(reason ?? 'All requests cancelled');
    }
    _cancelTokens.clear();
  }

  // ═══════════════════════════════════════════════════════════════
  // Core Request Method (DRY principle)
  // ═══════════════════════════════════════════════════════════════

  Future<Result<T>> _request<T>(
    Future<Response> Function() request,
    JsonParser<T> fromJson, {
    int maxRetries = 1,
    bool unwrap = true,
    Duration? retryDelay,
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
      } on DioException catch (e) {
        // ✅ THÊM: Don't retry on cancel
        if (e.type == DioExceptionType.cancel) {
          return ResultFailure(CancelledFailure(message: e.message ?? 'Request cancelled'));
        }

        attempt++;
        if (attempt >= maxRetries || !_isRetryable(e)) {
          return _handleError<T>(e);
        }

        // ✅ THÊM: Exponential backoff
        final delay = retryDelay ?? Duration(seconds: attempt * 2);
        await Future.delayed(delay);
      } catch (e) {
        return _handleError<T>(e);
      }
    }
  }

  /// ✅ THÊM: Check if error is retryable
  bool _isRetryable(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse =>
        e.response?.statusCode != null && e.response!.statusCode! >= 500,
      _ => false,
    };
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
      DioExceptionType.cancel => CancelledFailure(message: error.message ?? 'Cancelled'),
      DioExceptionType.badResponse => _mapStatusCodeError(error.response),
      _ => UnknownFailure(message: error.message ?? 'Unknown error'),
    };
  }

  /// Map HTTP status codes to Failures
  Failure _mapStatusCodeError(Response? response) {
    final data = response?.data;
    final message = _extractErrorMessage(data);

    return switch (response?.statusCode) {
      null => const UnknownFailure(message: 'No response from server'),

      // Validation errors (400, 422)
      400 || 422 => DataFailure(
        message: message ?? 'Dữ liệu không hợp lệ',
        type: DataFailureType.validation,
        fieldErrors: _extractFieldErrors(data),
        globalErrors: _extractGlobalErrors(data),
        statusCode: response?.statusCode,
      ),

      // Auth errors (401)
      401 => AuthFailure(
        message: message ?? 'Phiên đăng nhập hết hạn',
        type: AuthFailureType.unauthenticated,
        statusCode: 401,
      ),

      // Unauthorized (403)
      403 => AuthFailure(
        message: message ?? 'Không có quyền truy cập',
        type: AuthFailureType.unauthorized,
        statusCode: 403,
      ),

      // Not found (404)
      404 => DataFailure(
        message: message ?? 'Không tìm thấy',
        type: DataFailureType.notFound,
        statusCode: 404,
      ),

      // Timeout (408)
      408 => const TimeoutFailure(),

      // Conflict (409)
      409 => DataFailure(
        message: message ?? 'Dữ liệu đã tồn tại',
        type: DataFailureType.conflict,
        statusCode: 409,
      ),

      // Rate limit (429)
      429 => ServerFailure(
        message: message ?? 'Quá nhiều yêu cầu',
        retryAfter: _extractRetryAfter(response),
        statusCode: 429,
      ),

      // Server errors (5xx)
      >= 500 => ServerFailure(
        message: message ?? 'Lỗi máy chủ',
        code: response?.statusCode?.toString(),
        statusCode: response?.statusCode,
      ),

      // Unknown
      _ => UnknownFailure(message: message ?? 'Yêu cầu thất bại'),
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // Error Extraction Helpers
  // ═══════════════════════════════════════════════════════════════

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString() ?? data['msg']?.toString();
    }
    if (data is String) return data;
    return null;
  }

  Map<String, String>? _extractFieldErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final errors = data['errors'] ?? data['fieldErrors'] ?? data['fields'];
    if (errors is! Map<String, dynamic>) return null;
    return errors.map((key, value) {
      if (value is List && value.isNotEmpty) {
        return MapEntry(key, value.first.toString());
      }
      return MapEntry(key, value.toString());
    });
  }

  List<String>? _extractGlobalErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final errors = data['globalErrors'] ?? data['nonFieldErrors'];
    if (errors is List) {
      return errors.map((e) => e.toString()).toList();
    }
    return null;
  }

  Duration? _extractRetryAfter(Response? response) {
    final retryAfter = response?.headers.value('retry-after');
    if (retryAfter == null) return null;
    final seconds = int.tryParse(retryAfter);
    if (seconds != null) return Duration(seconds: seconds);
    return null;
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
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    final token = cancelTag != null ? getCancelToken(cancelTag) : cancelToken;

    return _request(
      () => _dioClient.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      ),
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
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    final token = cancelTag != null ? getCancelToken(cancelTag) : cancelToken;

    return _request(
      () => _dioClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      ),
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
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    final token = cancelTag != null ? getCancelToken(cancelTag) : cancelToken;

    return _request(
      () => _dioClient.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      ),
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
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    final token = cancelTag != null ? getCancelToken(cancelTag) : cancelToken;

    return _request(
      () => _dioClient.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
      ),
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
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }

    final token = cancelTag != null ? getCancelToken(cancelTag) : cancelToken;

    int attempt = 0;
    while (true) {
      try {
        final response = await _dioClient.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: token,
        );

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
      } on DioException catch (e) {
        if (e.type == DioExceptionType.cancel) {
          return ResultFailure(CancelledFailure(message: e.message ?? 'Cancelled'));
        }
        attempt++;
        if (attempt >= maxRetries || !_isRetryable(e)) {
          return _handleError<bool>(e);
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      } catch (e) {
        return _handleError<bool>(e);
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
    CancelToken? cancelToken,
    String? cancelTag,
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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return ResultFailure(CancelledFailure(message: e.message ?? 'Upload cancelled'));
      }
      return _handleError<T>(e);
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
    CancelToken? cancelToken,
    String? cancelTag,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }

    final token = cancelTag != null ? getCancelToken(cancelTag) : cancelToken;

    try {
      await _dioClient.downloadFile(
        urlPath,
        savePath,
        options: options,
        onReceiveProgress: onProgress,
        cancelToken: token,
      );
      return ResultSuccess(savePath);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return ResultFailure(CancelledFailure(message: e.message ?? 'Download cancelled'));
      }
      return _handleError<String>(e);
    } catch (e) {
      return _handleError<String>(e);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Batch Requests
  // ═══════════════════════════════════════════════════════════════

  /// ✅ THÊM: Execute multiple requests in parallel
  Future<List<Result<T>>> batchGet<T>(
    List<String> paths,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxConcurrent = 3,
  }) async {
    if (!await _networkInfo.isConnected) {
      return paths.map((_) => ResultFailure<T>(const NetworkFailure()) as Result<T>).toList();
    }

    final results = <Result<T>>[];

    // Process in batches
    for (var i = 0; i < paths.length; i += maxConcurrent) {
      final batch = paths.skip(i).take(maxConcurrent);
      final batchResults = await Future.wait(
        batch.map(
          (path) => get<T>(path, fromJson, queryParameters: queryParameters, options: options),
        ),
      );
      results.addAll(batchResults);
    }

    return results;
  }

  /// ✅ THÊM: Execute request with automatic retry on specific errors
  Future<Result<T>> getWithAutoRetry<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    return _request(
      () => _dioClient.get(path, queryParameters: queryParameters, options: options),
      fromJson,
      maxRetries: maxRetries,
      retryDelay: initialDelay,
      unwrap: true,
    );
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
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return get(
      path,
      fromJson,
      queryParameters: queryParameters,
      options: strategy != null ? SmartCacheInterceptor.withStrategy(strategy) : null,
      cancelToken: cancelToken,
      cancelTag: cancelTag,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// GET and force refresh (bypass cache)
  Future<Result<T>> getForceRefresh<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return get(
      path,
      fromJson,
      queryParameters: queryParameters,
      options: SmartCacheInterceptor.forceRefresh(),
      cancelToken: cancelToken,
      cancelTag: cancelTag,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }
}
