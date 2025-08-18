import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';

class DbKeysLocal {
  static const String urlImagePrdTest =
      'https://i.scdn.co/image/ab67616d0000b2733a67ae649c1800037f46fc9b';

  static const String carts = '/carts';
  // type String
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  // type bool
  static const String isLogin = 'isLogin';
  static const String isSaveLogin = '/isSaveLogin';
  static const String isWarning = '/isWarning';
  static const String userId = '/user-id';
  static const String user = 'user';
  static const String themeKey = 'themeKey'; // 🔑 lưu theme hiện tại
  static const String idCat = '/idCat';
  static const String firstLogin = '/first_login';
  static const String isDark = '/isDark';
  static const String productSceen = '/productSceen';
  static const String listCartLocal = '/listCartLocal';
  static const String listCartWholesale = '/listCartWholeSale';
  static const String listCartRefund = '/listCartRefund';
  static const String addressLocal = '/addressLocal';
  static const String ipPrinter = '/ip_printer';
  static const String pass = '/pass';
  static const String username = '/user_name';
  static const String userType = '/user_type';
  static const String provinceId = '/province';
  static const String provinceName = '/province_n';
  static const String districtId = '/district';
  static const String districtName = '/district_n';
  static const String wardId = '/ward';
  static const String wardName = '/ward_n';
  static const String saveAddress = '/saveAddress';
  static const String residentType = '/residentType';
  static String bankApp = "bank_app";

  static removeAllKey() async {
    await SharedPrefs.remove(carts);
    await SharedPrefs.remove(accessToken);
    await SharedPrefs.remove(refreshToken);
    await SharedPrefs.remove(isLogin);
    await SharedPrefs.remove(isWarning);
    await SharedPrefs.remove(user);
    await SharedPrefs.remove(isWarning);
    await SharedPrefs.remove(productSceen);
    await SharedPrefs.remove(listCartLocal);
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
