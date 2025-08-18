import 'package:dat_san_247_mobile/core/config/repository_helper/base_response.dart';
import 'package:dio/dio.dart';

class ApiHelper {
  /// Gọi API và xử lý kết quả trả về là **một đối tượng**
  ///
  /// [apiCall]: Hàm gọi API trả về Future<Response>, ví dụ: `() => dio.get('/user/1')`
  /// [fromJson]: Hàm chuyển đổi Map<String, dynamic> sang đối tượng T, ví dụ: `(json) => User.fromJson(json)`
  static Future<BaseResponse<T>> handleRequest<T>({
    required Future<Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await apiCall();
      return BaseResponse.fromResponse(response, fromJson);
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  /// Gọi API và xử lý kết quả trả về là **một danh sách đối tượng**
  ///
  /// [apiCall]: Hàm gọi API trả về Future<Response>, ví dụ: `() => dio.get('/users')`
  /// [fromJson]: Hàm chuyển đổi từng phần tử trong danh sách json sang đối tượng T, ví dụ: `(json) => User.fromJson(json)`
  static Future<BaseResponse<List<T>>> handleListRequest<T>({
    required Future<Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await apiCall();
      return BaseResponse.listFromResponse(response, fromJson);
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }
}
