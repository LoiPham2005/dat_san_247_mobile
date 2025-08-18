import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:dat_san_247_mobile/core/config/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/core/config/config_getx/base_controller.dart';
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
      final userJson = await SharedPrefs.getString(DbKeysLocal.user);
      if (userJson != null) {
        final user = User.fromJson(userJson);
        userList.assignAll([user]);
      }
    }
  }

  // ===================
  // LOGIN - REGISTER
  // ===================

  Future<bool> login(String email, String password) async {
    return _handleMutation(
      () => _repo.login(email, password),
      saveAuth: true,
    );
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
      String oldPassword, String newPassword, String id) {
    return _handleMutation(
        () => _repo.changePassword(oldPassword, newPassword, id));
  }

  Future<bool> editInformation(
      String oldPassword, String newPassword, String id) {
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

    await performAction(
      action: operation,
      onSuccess: (data, {accessToken, refreshToken}) async {
        if (saveAuth) {
          await _saveAuthData(
            data,
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        }
        userList.assignAll([data]);
        result = true;
      },
    );

    return result;
  }

  Future<void> _saveAuthData(User user,
      {String? accessToken, String? refreshToken}) async {
    // Ở đây mình giả định token được lưu trong User model hoặc từ repo trả về
    await SharedPrefs.setBool(DbKeysLocal.isLogin, true);
    await SharedPrefs.setString(DbKeysLocal.user, user.toJson());
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
