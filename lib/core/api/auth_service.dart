import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'dio_client.dart'; // import DioClient để gọi API refresh token
import 'package:dio/dio.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// Kiểm tra accessToken, refreshToken
  Future<void> checkAndRefreshToken() async {
    final accessToken = await SharedPrefs.getString(DbKeysLocal.accessToken);
    final refreshToken = await SharedPrefs.getString(DbKeysLocal.refreshToken);

    if (accessToken == null || refreshToken == null) {
      // _logout();
      print("Tokens chưa có, chưa logout ngay");
      return;
    }

    // TODO: Nếu bạn có decode JWT có thể check expire ở đây
    // Ví dụ decode và kiểm tra expire
    // final decoded = JwtDecoder.decode(accessToken);
    // final isExpired = JwtDecoder.isExpired(accessToken);

    // Giả sử gọi API refresh token
    try {
      final response = await DioClient().post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await SharedPrefs.setString(DbKeysLocal.accessToken, newAccessToken);
        await SharedPrefs.setString(DbKeysLocal.refreshToken, newRefreshToken);
      } else {
        _logout();
      }
    } on DioException catch (_) {
      _logout();
    }
  }

  /// Logout về màn login
  void _logout() async {
    // Chỉ cần gọi trực tiếp hàm clearUserAuthData
    await DbKeysLocal.clearUserAuthData();

    // Xóa userList trong controller nếu cần
    // Get.find<AuthController>().userList.clear();

    // Điều hướng về màn login
    Get.offAll(() => LoginPage());
  }
}
