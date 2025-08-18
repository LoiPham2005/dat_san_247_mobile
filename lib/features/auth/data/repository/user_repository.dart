import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:dat_san_247_mobile/core/api/api_path.dart';
import 'package:dat_san_247_mobile/core/config/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/core/api/dio_client.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/user_model.dart';

class AuthRepository {
  final DioClient _client = Get.find<DioClient>();

  Future<BaseResponse<User>> login(String email, String password) async {
    try {
      final response = await _client.post(ApiPath.login, data: {
        'email': email,
        'password': password,
      });
      // return parseResponse(response, (json) => User.fromJson(json));

      // Map response data correctly
      if (response.data['result'] == true || response.data['status'] == 200) {
        return BaseResponse<User>(
          result: true,
          message: response.data['message'],
          data: User.fromJson(
              response.data['user']), // Use 'user' instead of 'data'
          accessToken: response.data['accessToken'],
          refreshToken: response.data['refreshToken'],
        );
        // return BaseResponse.fromResponse(
        //   response,
        //   (json) => User.fromJson(json),
        // );
      } else {
        return BaseResponse<User>(
          result: false,
          message: response.data['message'],
        );
      }
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  Future<BaseResponse<User>> register(
      String username, String email, String password) async {
    try {
      final response = await _client.post(ApiPath.register, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      // return parseResponse(response, (json) => User.fromJson(json));
      if (response.data['result'] == true || response.data['status'] == 200) {
        // return BaseResponse<User>(
        //   result: true,
        //   message: response.data['message'],
        //   data: User.fromJson(
        //       response.data['user']), // Use 'user' instead of 'data'
        //   accessToken: response.data['accessToken'],
        //   refreshToken: response.data['refreshToken'],
        // );

        return BaseResponse.fromResponse(
          response,
          (json) => User.fromJson(json),
        );
      } else {
        return BaseResponse<User>(
          result: false,
          message: response.data['message'],
        );
      }
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  // đăng xuất
  Future<BaseResponse<void>> logout() async {
    try {
      final response = await _client.post(ApiPath.logout);
      // return parseResponse(response, (json) {});
      return BaseResponse.fromResponse(
        response,
        (json) {},
      );
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  Future<BaseResponse<User>> sendEmail(String email) async {
    try {
      final response = await _client.post(ApiPath.sendEmail, data: {
        'email': email,
      });

      // Kiểm tra status code từ response
      if (response.data['status'] == 200) {
        print(" 😊😊😊😊đã bào được đây repository");
        print(response.data['status']);
        print(response.data['message']);

        // return BaseResponse<User>(
        //   result: true,
        //   status: response.data['status'],
        //   message: response.data['message'],
        //   // data: User(email: email), // Provide a valid User object
        // );
        return BaseResponse.fromResponse(
          response,
          (json) => User.fromJson(json),
        );
      } else {
        return BaseResponse<User>(
          result: false,
          status: response.data['status'],
          message: response.data['message'] ?? 'Gửi email thất bại',
        );
      }
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  Future<BaseResponse<User>> sendOtp(String email, String otp) async {
    try {
      final response = await _client.post(ApiPath.sendOtp, data: {
        'email': email,
        'otp': otp,
      });
      // return parseResponse(
      //   response,
      //   (p0) => User.fromJson(p0),
      // );
      return BaseResponse.fromResponse(
        response,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  Future<BaseResponse<User>> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      final response = await _client.post("${ApiPath.sendOtp}/$email", data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      });
      // return parseResponse(
      //   response,
      //   (p0) => User.fromJson(p0),
      // );
      return BaseResponse.fromResponse(
        response,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  Future<BaseResponse<User>> changePassword(
      String oldPassword, String newPassword, String id) async {
    try {
      final response = await _client.post("${ApiPath.changPassword}/$id",
          data: {'oldPassword': oldPassword, 'newPassword': newPassword});
      // return parseResponse(
      //   response,
      //   (p0) => User.fromJson(p0),
      // );
      return BaseResponse.fromResponse(
        response,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }

  Future<BaseResponse<User>> editInformation(
      String oldPassword, String newPassword, String id) async {
    try {
      final response = await _client.post("${ApiPath.sendOtp}/$id",
          data: {'oldPassword': oldPassword, 'newPassword': newPassword});
      // return parseResponse(
      //   response,
      //   (p0) => User.fromJson(p0),
      // );
      return BaseResponse.fromResponse(
        response,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      return BaseResponse.handleError(e);
    }
  }
}
