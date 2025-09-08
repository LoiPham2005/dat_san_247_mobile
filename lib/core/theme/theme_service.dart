import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import '../utils/shared_preferences/db_keys_local.dart';

class ThemeService extends GetxService {
  final themes = AppTheme.themes;

  final _currentTheme = AppThemeKey.light.obs;

  AppThemeKey get currentThemeKey => _currentTheme.value;
  ThemeData get currentTheme => themes[_currentTheme.value]!;

  /// Load theme đã lưu
  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedKey = prefs.getString(DbKeysLocal.themeKey);

    if (savedKey != null) {
      final themeKey = AppThemeKey.values.firstWhere(
        (e) => e.toString() == savedKey,
        orElse: () => AppThemeKey.light,
      );
      _currentTheme.value = themeKey;
      Get.changeTheme(themes[themeKey]!);
    }
  }

  /// Đổi theme + lưu lại
  Future<void> changeTheme(AppThemeKey key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTheme.value = key;
    Get.changeTheme(themes[key]!);
    prefs.setString(DbKeysLocal.themeKey, key.toString());
  }
}
