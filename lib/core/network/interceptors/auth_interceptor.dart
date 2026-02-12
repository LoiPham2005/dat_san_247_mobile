// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/interceptors/auth_interceptor.dart (OPTIMIZED)
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dat_san_247_mobile/core/constants/api_constants.dart';
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/services/auth_service.dart';
import 'package:dat_san_247_mobile/core/storage/secure/secure_storage_service.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorage _secureStorage;

  // Queue để tránh multiple refresh requests
  bool _isRefreshing = false;
  final List<_QueuedRequest> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip token cho các API public
    if (_isPublicApi(options.path)) {
      return handler.next(options);
    }

    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Chỉ handle 401
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh nếu đang refresh token
    if (err.requestOptions.path.contains('refresh')) {
      return handler.next(err);
    }

    Logger.info('Token expired (401). Refreshing...', tag: 'AUTH');

    // Queue mechanism để tránh race condition
    if (_isRefreshing) {
      final completer = Completer<Response>();
      _pendingRequests.add(
        _QueuedRequest(requestOptions: err.requestOptions, completer: completer),
      );

      try {
        final response = await completer.future;
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    _isRefreshing = true;

    try {
      final authService = getIt<AuthService>();
      final success = await authService.refreshToken();

      if (!success) {
        Logger.warning('Refresh failed. Logging out.', tag: 'AUTH');
        _rejectPendingRequests(err);
        await authService.logout();
        return handler.reject(err);
      }

      Logger.info('Refresh success. Retrying requests.', tag: 'AUTH');

      // Retry original request
      final response = await _retryRequest(err.requestOptions);

      // Retry all pending requests
      await _resolvePendingRequests();

      return handler.resolve(response);
    } catch (e) {
      Logger.error('Token refresh error', error: e, tag: 'AUTH');
      _rejectPendingRequests(err);
      await getIt<AuthService>().logout();
      return handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Helper Methods
  // ═══════════════════════════════════════════════════════════════

  bool _isPublicApi(String path) {
    return ApiConstants.publicEndpoints.any((p) => path.contains(p));
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final token = await _secureStorage.getAccessToken();

    final dio = Dio(
      BaseOptions(
        baseUrl: requestOptions.baseUrl,
        connectTimeout: requestOptions.connectTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
      ),
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<void> _resolvePendingRequests() async {
    for (final request in _pendingRequests) {
      try {
        final response = await _retryRequest(request.requestOptions);
        request.completer.complete(response);
      } catch (e) {
        request.completer.completeError(e);
      }
    }
    _pendingRequests.clear();
  }

  void _rejectPendingRequests(DioException err) {
    for (final request in _pendingRequests) {
      request.completer.completeError(err);
    }
    _pendingRequests.clear();
  }
}

// ✅ SIMPLIFIED: Bỏ handler không dùng
class _QueuedRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  _QueuedRequest({required this.requestOptions, required this.completer});
}
