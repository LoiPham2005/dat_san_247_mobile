// ════════════════════════════════════════════════════════════════
// 📁 lib/core/network/interceptors/auth_interceptor.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:flutter_base_template/core/constants/api_constants.dart';
import 'package:flutter_base_template/core/di/injection.dart';
import 'package:flutter_base_template/core/storage/secure_storage.dart';
import 'package:flutter_base_template/core/services/auth_service.dart';
import 'package:flutter_base_template/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorage _secureStorage;
  final authService = getIt<AuthService>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token cho các API public
    if (_isPublicApi(options.path)) {
      return handler.next(options);
    }

    // ✅ Lấy từ SecureStorage (encrypted)
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      Logger.warning('No token for: ${options.path}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    Logger.info('Token expired (401). Refreshing...');

    try {
      final success = await authService.refreshToken();

      if (!success) {
        Logger.warning('Refresh failed. Logging out.');
        await authService.logout();
        return handler.reject(err);
      }

      Logger.info('Refresh success. Retrying request.');
      final response = await _retryRequest(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      Logger.error('Token refresh error', error: e);
      await getIt<AuthService>().logout();
      return handler.reject(err);
    }
  }

  bool _isPublicApi(String path) {
    return ApiConstants.publicEndpoints.any(
      (publicPath) => path.contains(publicPath),
    );
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    // ✅ Lấy từ SecureStorage
    final token = await _secureStorage.getAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

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
      options: options,
    );
  }
}
