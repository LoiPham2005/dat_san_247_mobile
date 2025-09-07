import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/login_page.dart';
import 'dio_client.dart'; // import DioClient để gọi API refresh token
import 'package:jwt_decoder/jwt_decoder.dart'; // Thêm package jwt_decoder

class CheckAuthService {
  CheckAuthService._();
  static final CheckAuthService instance = CheckAuthService._();
  bool _isRefreshing = false; // Flag để tránh gọi refresh token đồng thời

  /// Kiểm tra accessToken, refreshToken
  Future<void> checkAndRefreshToken() async {
    // Nếu đang refresh thì bỏ qua
    if (_isRefreshing) return;

    final accessToken = await SharedPrefs.getString(DbKeysLocal.accessToken);
    final refreshToken = await SharedPrefs.getString(DbKeysLocal.refreshToken);

    if (accessToken == null || refreshToken == null) {
      print("Tokens không tồn tại");
      return;
    }

    try {
      // Kiểm tra access token có hết hạn chưa
      bool isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
      bool isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);

      if (isRefreshTokenExpired) {
        // Nếu refresh token hết hạn -> logout
        print("Refresh token hết hạn");
        _logout();
        return;
      }

      if (isAccessTokenExpired) {
        // Nếu access token hết hạn -> gọi refresh
        print("Access token hết hạn - đang refresh");
        _isRefreshing = true;

        final response = await DioClient().post(
          '/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 && response.data['success'] == true) {
          final newAccessToken = response.data['data']['accessToken'];
          final newRefreshToken = response.data['data']['refreshToken'];

          await SharedPrefs.setString(DbKeysLocal.accessToken, newAccessToken);
          await SharedPrefs.setString(
            DbKeysLocal.refreshToken,
            newRefreshToken,
          );
          print("Refresh token thành công");
        } else {
          print("Refresh token thất bại");
          _logout();
        }
      }
    } catch (e) {
      print("Lỗi khi refresh token: $e");
      _logout();
    } finally {
      _isRefreshing = false;
    }
  }

  void _logout() async {
    await DbKeysLocal.clearAuthData();
    Get.offAll(() => LoginPage());
  }
}
