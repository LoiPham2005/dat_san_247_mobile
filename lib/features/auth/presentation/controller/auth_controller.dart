import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/utils/shared_preferences/share_pref.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/core/config/app/config_getx/base_controller.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/user_model.dart';
import 'package:dat_san_247_mobile/features/auth/data/repository/user_repository.dart';

class AuthController extends BaseController {
  final AuthRepository _repo = AuthRepository();

  /// Danh sách user hiện tại (thường chỉ có 1 user)
  final RxList<User> userList = <User>[].obs;

  /// Load dữ liệu khi khởi tạo controller
  @override
  void onInit() async {
    super.onInit();
    await loadUserFromLocal();
  }

  /// Lấy user từ SharedPrefs
  Future<void> loadUserFromLocal() async {
    final isLogin = await SharedPrefs.getBool(DbKeysLocal.isLogin) ?? false;

    if (isLogin) {
      final userStored = await SharedPrefs.getString(DbKeysLocal.user);

      if (userStored != null) {
        User user;

        if (userStored is String) {
          // Nếu là String, decode thành Map
          final userMap = jsonDecode(userStored);
          user = User.fromJson(userMap);
        } else if (userStored is Map<String, dynamic>) {
          // Nếu đã là Map, dùng trực tiếp
          user = User.fromJson(userStored);
        } else {
          throw Exception(
            "Stored user has unsupported type: ${userStored.runtimeType}",
          );
        }

        userList.assignAll([user]);
        print("User loaded: ${user.toJson()}");
      }
    }
  }

  // ===================
  // LOGIN - REGISTER
  // ===================

  Future<bool> login(String email, String password) async {
    return _handleMutation(() => _repo.login(email, password), saveAuth: true);
  }

  Future<bool> register(String username, String email, String password) async {
    return _handleMutation(
      () => _repo.register(username, email, password),
      saveAuth: true,
    );
  }

  // ===================
  // OTHER AUTH ACTIONS
  // ===================

  Future<bool> sendOtp(String email, String otp) {
    return _handleMutation(() => _repo.sendOtp(email, otp));
  }

  Future<bool> sendEmail(String email) {
    return _handleMutation(() => _repo.sendEmail(email));
  }

  Future<bool> resetPassword(String email, String otp, String newPassword) {
    return _handleMutation(() => _repo.resetPassword(email, otp, newPassword));
  }

  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String id,
  ) {
    return _handleMutation(
      () => _repo.changePassword(oldPassword, newPassword, id),
    );
  }

  Future<bool> editInformation(
    String oldPassword,
    String newPassword,
    String id,
  ) {
    return _handleMutation(
      () => _repo.editInformation(oldPassword, newPassword, id),
      saveAuth: true,
    );
  }

  Future<void> logout() async {
    await DbKeysLocal.clearAuthData();
    userList.clear();
  }

  // ===================
  // HANDLE MUTATION DÙNG CHUNG
  // ===================

  Future<bool> _handleMutation(
    Future<BaseResponse<User>> Function() operation, {
    bool saveAuth = false,
  }) async {
    bool result = false;

    try {
      final res = await operation();
      print("Response success: ${res.success}"); // Debug log
      print("Response data: ${res.data}"); // Debug log

      if (res.success == true && res.data != null) {
        if (saveAuth) {
          await _saveAuthData(
            res.data!,
            accessToken: res.accessToken,
            refreshToken: res.refreshToken,
          );
        }
        userList.assignAll([res.data!]);
        result = true;
      } else {
        Get.snackbar(
          "Lỗi",
          res.message ?? "Có lỗi xảy ra",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error in _handleMutation: $e"); // Debug log
      Get.snackbar(
        "Lỗi",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    return result;
  }

  Future<void> _saveAuthData(
    User user, {
    String? accessToken,
    String? refreshToken,
  }) async {
    // Ở đây mình giả định token được lưu trong User model hoặc từ repo trả về
    await SharedPrefs.setBool(DbKeysLocal.isLogin, true);
    await SharedPrefs.setString(DbKeysLocal.user, jsonEncode(user.toJson()));
    if (accessToken != null) {
      await SharedPrefs.setString(DbKeysLocal.accessToken, accessToken);
    }
    if (refreshToken != null) {
      await SharedPrefs.setString(DbKeysLocal.refreshToken, refreshToken);
    }

    final isLogin = await SharedPrefs.getBool(DbKeysLocal.isLogin) ?? false;
    print("isLogin2: $isLogin");
  }
}
