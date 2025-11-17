// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_base_template/core/network/api_response.dart';
import 'package:injectable/injectable.dart';
import '../errors/exceptions.dart';
import '../errors/result.dart';
import '../errors/failures.dart';
import 'dio_client.dart';
import '../network/network_info.dart';

typedef JsonParser<T> = T Function(dynamic json);

@LazySingleton()
class ApiClient {
  ApiClient(this._dioClient, this._networkInfo);
  final DioClient _dioClient;
  final NetworkInfo _networkInfo;

  // ===============================
  // Helper: Unwrap API Response
  // ===============================
  T _unwrapApiResponse<T>(dynamic responseData, JsonParser<T> fromJson) {
    if (responseData is! Map<String, dynamic>) {
      return fromJson(responseData);
    }

    final apiResponse = ApiResponse<T>.fromJson(responseData, (json) {
      return json == null ? fromJson(responseData) : fromJson(json);
    });

    if (apiResponse.isSuccess) {
      return apiResponse.data ?? fromJson(responseData);
    } else {
      throw ServerException(
        message: apiResponse.error ?? apiResponse.message ?? 'Request failed',
        code: apiResponse.code?.toString(),
      );
    }
  }

  // ===============================
  // Safe + Retry
  // ===============================
  Future<Result<T>> _safeRequest<T>(Future<Result<T>> Function() request) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(NetworkFailure());
    }
    return request();
  }

  Future<Result<T>> _retryRequest<T>(
    Future<Result<T>> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await request();
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          return ResultFailure(
            UnknownFailure(
              // Sửa Error -> ResultFailure
              message: 'Max retries exceeded: $e',
            ),
          );
        }
        await Future.delayed(delay * attempt);
      }
    }
  }

  // ✅ GET - Đã có options rồi, giữ nguyên
  Future<Result<T>> getResult<T>(
    String path,
    JsonParser<T> fromJson, {
    Map<String, dynamic>? queryParameters,
    Options? options, // ✅ Có rồi
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        final response = await _dioClient.get(
          path,
          queryParameters: queryParameters,
          options: options,
        );
        final data = unwrap
            ? _unwrapApiResponse<T>(response.data, fromJson)
            : fromJson(response.data);
        return ResultSuccess(data);
      }, maxRetries: maxRetries),
    );
  }

  // ✅ POST - Thêm options
  Future<Result<T>> postResult<T>(
    String path,
    JsonParser<T> fromJson, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options, // ✅ THÊM MỚI
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        final response = await _dioClient.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options, // ✅ Pass options
        );
        final result = unwrap
            ? _unwrapApiResponse<T>(response.data, fromJson)
            : fromJson(response.data);
        return ResultSuccess(result);
      }, maxRetries: maxRetries),
    );
  }

  // ✅ PUT - Thêm options
  Future<Result<T>> putResult<T>(
    String path,
    JsonParser<T> fromJson, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options, // ✅ THÊM MỚI
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        final response = await _dioClient.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options, // ✅ Pass options
        );
        final result = unwrap
            ? _unwrapApiResponse<T>(response.data, fromJson)
            : fromJson(response.data);
        return ResultSuccess(result);
      }, maxRetries: maxRetries),
    );
  }

  // ✅ PATCH - Thêm options
  Future<Result<T>> patchResult<T>(
    String path,
    JsonParser<T> fromJson, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options, // ✅ THÊM MỚI
    int maxRetries = 1,
    bool unwrap = true,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        final response = await _dioClient.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options, // ✅ Pass options
        );
        final result = unwrap
            ? _unwrapApiResponse<T>(response.data, fromJson)
            : fromJson(response.data);
        return ResultSuccess(result);
      }, maxRetries: maxRetries),
    );
  }

  // ✅ DELETE - Thêm options
  Future<Result<bool>> deleteResult(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options, // ✅ THÊM MỚI
    int maxRetries = 1,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        final response = await _dioClient.delete(
          path,
          queryParameters: queryParameters,
          options: options, // ✅ Pass options
        );

        if (response.data is Map<String, dynamic>) {
          final success = response.data['success'] ?? response.data['result'] ?? true;
          if (!success) {
            throw ServerException(message: response.data['message'] ?? 'Delete failed');
          }
        }

        return const ResultSuccess(true);
      }, maxRetries: maxRetries),
    );
  }

  // ✅ UPLOAD FILE - Thêm options
  Future<Result<T>> uploadFileResult<T>(
    String path,
    String filePath, {
    JsonParser<T>? fromJson,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Options? options, // ✅ THÊM MỚI
    void Function(int sent, int total)? onSendProgress,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        final response = await _dioClient.uploadFile<T>(
          path,
          filePath,
          fieldName: fieldName,
          data: data,
          options: options, // ✅ Pass options (cần update uploadFile method)
          onSendProgress: onSendProgress,
        );

        if (fromJson != null) {
          final result = _unwrapApiResponse<T>(response.data, fromJson);
          return ResultSuccess(result);
        } else {
          return const ResultSuccess(true) as Result<T>;
        }
      }, maxRetries: 1),
    );
  }

  // ✅ DOWNLOAD FILE - Thêm options
  Future<Result<bool>> downloadFileResult(
    String urlPath,
    String savePath, {
    Options? options, // ✅ THÊM MỚI
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    return _safeRequest(
      () => _retryRequest(() async {
        await _dioClient.downloadFile(
          urlPath,
          savePath,
          options: options, // ✅ Pass options (cần update downloadFile method)
          onReceiveProgress: onReceiveProgress,
        );
        return const ResultSuccess(true);
      }, maxRetries: 1),
    );
  }
}
