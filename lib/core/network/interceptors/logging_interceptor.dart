// lib/core/network/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../utils/logger.dart';

@LazySingleton()
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.httpRequest(
      options.method,
      options.uri.toString(),
      data: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.httpResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
      data: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.httpError(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      err.response?.statusCode,
      err.response?.data,
    );
    handler.next(err);
  }
}