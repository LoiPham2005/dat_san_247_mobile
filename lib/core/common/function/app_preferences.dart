import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // Keys
  static const _keyFirstRun = DbKeysLocal.isFirstRun;
  static const _keyIsLogin = DbKeysLocal.isLogin;

  // Cache
  static bool? _cachedFirstRun;
  static bool? _cachedIsLogin;

  /// Kiểm tra lần đầu mở app
  static Future<bool> isFirstRun() async {
    if (_cachedFirstRun != null) return _cachedFirstRun!;

    final prefs = await SharedPreferences.getInstance();
    final firstRun = prefs.getBool(_keyFirstRun) ?? true;
    _cachedFirstRun = firstRun;

    // Nếu là lần đầu, set false để lần sau không còn là first run
    if (firstRun) await prefs.setBool(_keyFirstRun, false);

    return firstRun;
  }

  /// Kiểm tra trạng thái login
  static Future<bool> isLogin() async {
    if (_cachedIsLogin != null) return _cachedIsLogin!;

    final prefs = await SharedPreferences.getInstance();
    final login = prefs.getBool(_keyIsLogin) ?? false;
    _cachedIsLogin = login;

    return login;
  }

  /// Set trạng thái login
  static Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, value);
    _cachedIsLogin = value;
  }

  /// Reset first run (dùng để test)
  static Future<void> resetFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstRun, true);
    _cachedFirstRun = true;
  }

  /// Reset login (dùng để test)
  static Future<void> resetLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, false);
    _cachedIsLogin = false;
  }
}
