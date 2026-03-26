// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/api_client.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:dat_san_247_mobile/core/data/cache/cache_strategy.dart';
import 'package:dat_san_247_mobile/core/data/network/interceptors/smart_cache_interceptor.dart';
import 'package:injectable/injectable.dart';

import '../../base/errors/error_handler.dart';
import '../../base/errors/exceptions.dart';
import '../../base/errors/failures.dart';
import '../../base/errors/result.dart';
import 'api_response.dart';
import 'dio_client.dart';
import 'network_info.dart';

typedef JsonParser<T> = T Function(dynamic json);

/// 🎯 Production-ready API client
/// - Network check trước mỗi request
/// - Auto retry với exponential backoff
/// - Cancel token management
/// - Cache strategy support
@LazySingleton()
class ApiClient {
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;

  // Global cancel token management
  final Map<String, CancelToken> _cancelTokens = {};

  ApiClient(this._dioClient, this._networkInfo);

  // ═══════════════════════════════════════════════════════════════
  // Cancel Token Management
  // ═══════════════════════════════════════════════════════════════

  /// Lấy (hoặc tạo mới) cancel token theo tag
  /// Token cũ cùng tag sẽ bị cancel tự động
  CancelToken getCancelToken(String tag) {
    _cancelTokens[tag]?.cancel('Cancelled by new request');
    _cancelTokens[tag] = CancelToken();
    return _cancelTokens[tag]!;
  }

  void cancelRequest(String tag, [String? reason]) {
    _cancelTokens[tag]?.cancel(reason ?? 'Request cancelled');
    _cancelTokens.remove(tag);
  }

  void cancelAllRequests([String? reason]) {
    for (final token in _cancelTokens.values) {
      token.cancel(reason ?? 'All requests cancelled');
    }
    _cancelTokens.clear();
  }

  // ═══════════════════════════════════════════════════════════════
  // Core Request Engine (DRY — dùng cho tất cả HTTP methods)
  // ═══════════════════════════════════════════════════════════════

  Future<Result<T>> _request<T>(
    Future<Response> Function() request,
    JsonParser<T> fromJson, {
    int maxRetries = 1,
    bool unwrap = true,
    Duration? retryDelay,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }

    int attempt = 0;
    while (true) {
      try {
        final response = await request();
        final data = unwrap
            ? _unwrapApiResponse<T>(response.data, fromJson)
            : fromJson(response.data);
        return ResultSuccess(data);
      } on DioException catch (e) {
        if (e.type == DioExceptionType.cancel) {
          return ResultFailure(
            CancelledFailure(message: e.message ?? 'Request cancelled'),
          );
        }
        attempt++;
        if (attempt >= maxRetries || !_isRetryable(e)) {
          return _handleError<T>(e);
        }
        // Exponential backoff
        await Future.delayed(retryDelay ?? Duration(seconds: attempt * 2));
      } catch (e) {
        return _handleError<T>(e);
      }
    }
  }

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
      message: response.message ?? 'Request failed',
      code: response.statusCode?.toString(),
    );
  }

  Result<T> _handleError<T>(dynamic error) {
    return ResultFailure(ErrorHandler.toFailure(error));
  }

  CancelToken? _resolveToken(String? cancelTag, CancelToken? cancelToken) {
    if (cancelTag != null) return getCancelToken(cancelTag);
    return cancelToken;
  }

  // ═══════════════════════════════════════════════════════════════
  // HTTP Methods
  // ═══════════════════════════════════════════════════════════════

  Future<Result<T>> get<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
    bool unwrap = true,
  }) {
    return _request(
      () => _dioClient.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _resolveToken(cancelTag, cancelToken),
      ),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

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
  }) {
    return _request(
      () => _dioClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _resolveToken(cancelTag, cancelToken),
      ),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

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
  }) {
    return _request(
      () => _dioClient.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _resolveToken(cancelTag, cancelToken),
      ),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

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
  }) {
    return _request(
      () => _dioClient.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _resolveToken(cancelTag, cancelToken),
      ),
      fromJson,
      maxRetries: maxRetries,
      unwrap: unwrap,
    );
  }

  /// DELETE request
  /// Dùng `_request()` giống các method khác — DRY, không duplicate logic
  Future<Result<bool>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
  }) {
    return _request<bool>(
      () => _dioClient.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _resolveToken(cancelTag, cancelToken),
      ),
      (response) {
        // Nếu response là Map, parse success field
        if (response is Map<String, dynamic>) {
          final success =
              response['success'] ??
              response['result'] ??
              true; // 204 No Content → mặc định success
          if (success == false) {
            throw ServerException(
              message: response['message']?.toString() ?? 'Delete failed',
            );
          }
        }
        return true;
      },
      maxRetries: maxRetries,
      unwrap: false, // Không unwrap qua ApiResponse — tự handle ở fromJson
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // File Operations
  // ═══════════════════════════════════════════════════════════════

  /// Upload file với progress callback
  /// Dùng _request() → có network check + retry tự động
  Future<Result<T>> uploadFile<T>(
    String path,
    String filePath, {
    required JsonParser<T> fromJson,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Options? options,
    ProgressCallback? onProgress,
    int maxRetries = 1,
  }) {
    return _request(
      () => _dioClient.uploadFile(
        path,
        filePath,
        fieldName: fieldName,
        data: data,
        options: options,
        onSendProgress: onProgress,
      ),
      fromJson,
      maxRetries: maxRetries,
    );
  }

  /// Download file với progress callback
  /// Dùng _request() → có network check + retry tự động
  /// fromJson bỏ qua response.data, luôn trả về savePath
  Future<Result<String>> downloadFile(
    String urlPath,
    String savePath, {
    Options? options,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
  }) {
    return _request<String>(
      () => _dioClient.downloadFile(
        urlPath,
        savePath,
        options: options,
        onReceiveProgress: onProgress,
        cancelToken: _resolveToken(cancelTag, cancelToken),
      ),
      (_) => savePath, // Response body không quan trọng — trả về savePath
      maxRetries: maxRetries,
      unwrap: false, // Không parse qua ApiResponse wrapper
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Batch & Cache Helpers
  // ═══════════════════════════════════════════════════════════════

  /// GET nhiều endpoints cùng lúc theo batch (tránh quá tải server)
  /// Network check không cần thiết ở đây vì mỗi get() đã check bên trong _request()
  Future<List<Result<T>>> batchGet<T>(
    List<String> paths,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxConcurrent = 3,
  }) async {
    final results = <Result<T>>[];
    for (var i = 0; i < paths.length; i += maxConcurrent) {
      final batch = paths.skip(i).take(maxConcurrent);
      final batchResults = await Future.wait(
        batch.map(
          (p) => get<T>(
            p,
            fromJson,
            queryParameters: queryParameters,
            options: options,
          ),
        ),
      );
      results.addAll(batchResults);
    }
    return results;
  }

  /// GET với cache strategy tùy chỉnh
  Future<Result<T>> getWithCache<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    CacheStrategy? strategy,
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
  }) {
    return get(
      path,
      fromJson,
      queryParameters: queryParameters,
      options: strategy != null
          ? SmartCacheInterceptor.withStrategy(strategy)
          : null,
      cancelToken: cancelToken,
      cancelTag: cancelTag,
      maxRetries: maxRetries,
    );
  }

  /// GET bỏ qua cache, luôn fetch từ network
  Future<Result<T>> getForceRefresh<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String? cancelTag,
    int maxRetries = 1,
  }) {
    return get(
      path,
      fromJson,
      queryParameters: queryParameters,
      options: SmartCacheInterceptor.forceRefresh(),
      cancelToken: cancelToken,
      cancelTag: cancelTag,
      maxRetries: maxRetries,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Lifecycle
  // ═══════════════════════════════════════════════════════════════

  /// Clear authorization và hủy tất cả pending requests (dùng khi logout)
  void clearAuthorization() {
    _dioClient.clearAuthorization();
    cancelAllRequests('Logout cleanup');
  }
}
