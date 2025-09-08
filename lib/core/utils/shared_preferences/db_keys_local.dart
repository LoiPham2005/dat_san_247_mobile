import 'package:dat_san_247_mobile/core/utils/shared_preferences/share_pref.dart';

class DbKeysLocal {
  static const String urlImagePrdTest =
      'https://i.scdn.co/image/ab67616d0000b2733a67ae649c1800037f46fc9b';

  static const String carts = '/carts';
  // type String
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  // type bool
  static const String isFirstRun = 'is_first_run';
  static const String isLogin = 'is_first_login';
  static const String isSaveLogin = '/is_save_login';
  static const String isWarning = '/is_warning';
  static const String userId = '/user_id';
  static const String user = 'user';
  static const String themeKey = 'theme_key'; // 🔑 lưu theme hiện tại
  static const String isDark = '/is_dark';
  
  static String bankApp = "bank_app";

  static removeAllKey() async {
    await SharedPrefs.remove(carts);
    await SharedPrefs.remove(accessToken);
    await SharedPrefs.remove(refreshToken);
    await SharedPrefs.remove(isLogin);
    await SharedPrefs.remove(isWarning);
    await SharedPrefs.remove(user);
    await SharedPrefs.remove(isWarning);
  }

  static Future<void> clearAuthData() async {
    await SharedPrefs.remove(accessToken);
    await SharedPrefs.remove(refreshToken);
    await SharedPrefs.remove(isLogin);
    await SharedPrefs.remove(user);
  }

  static clearUserAuthData() async {
    await SharedPrefs.remove(accessToken);
    await SharedPrefs.remove(refreshToken);
    await SharedPrefs.remove(isLogin);
    await SharedPrefs.remove(user);
  }


  
}
