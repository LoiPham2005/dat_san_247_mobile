// lib/core/storage/storage_service.dart
import 'dart:convert';
import 'package:flutter_base_template/core/storage/storage_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// ════════════════════════════════════════════════════════════════
  /// GENERIC METHODS
  /// ════════════════════════════════════════════════════════════════
  T? get<T>(String key) {
    return _prefs.get(key) as T?;
  }

  Future<bool> set<T>(String key, T value) {
    if (value is String) return _prefs.setString(key, value);
    if (value is bool) return _prefs.setBool(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is double) return _prefs.setDouble(key, value);
    if (value is List<String>) return _prefs.setStringList(key, value);
    return Future.value(false);
  }

  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clearAll() => _prefs.clear();

  /// ════════════════════════════════════════════════════════════════
  /// USER PROFILE & LOGIN STATUS (Non-sensitive)
  /// ════════════════════════════════════════════════════════════════

  /// Save user profile
  Future<bool> saveUser(Map<String, dynamic> user) async {
    try {
      return set(StorageKeys.userProfile, json.encode(user));
    } catch (e) {
      return false;
    }
  }

  /// Get user profile
  Map<String, dynamic>? getUser() {
    try {
      final userString = get<String>(StorageKeys.userProfile);
      if (userString == null) return null;
      return json.decode(userString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Set login status
  Future<bool> setLoggedIn(bool value) => set(StorageKeys.isLogin, value);

  /// Check if logged in
  bool isLoggedIn() => get<bool>(StorageKeys.isLogin) ?? false;

  /// Clear auth data (user profile + login status)
  /// NOTE: Tokens are cleared in SecureStorage.clearTokens()
  Future<void> clearAuthData() async {
    await remove(StorageKeys.userProfile);
    await remove(StorageKeys.isLogin);
  }

  /// ════════════════════════════════════════════════════════════════
  /// APP SETTINGS
  /// ════════════════════════════════════════════════════════════════

  /// Set first run flag
  Future<bool> setFirstRun(bool value) => set(StorageKeys.isFirstRun, value);

  /// Check if first run
  bool isFirstRun() => get<bool>(StorageKeys.isFirstRun) ?? true;

  // /// Save theme mode
  // Future<bool> saveThemeMode(String mode) => set(StorageKeys.themeMode, mode);

  // /// Get theme mode
  // String? getThemeMode() => get<String>(StorageKeys.themeMode);


  // ✅ Theme Color
  String? getThemeColor() => _prefs.getString(StorageKeys.keyThemeColor);

  Future<bool> saveThemeColor(String color) =>
      _prefs.setString(StorageKeys.keyThemeColor, color);

  // ✅ Theme Mode
  String? getThemeMode() => _prefs.getString(StorageKeys.keyThemeMode);

  Future<bool> saveThemeMode(String mode) =>
      _prefs.setString(StorageKeys.keyThemeMode, mode);

  /// Save language code
  Future<bool> saveLanguageCode(String code) =>
      set(StorageKeys.languageCode, code);

  /// Get language code
  String? getLanguageCode() => get<String>(StorageKeys.languageCode);
}
