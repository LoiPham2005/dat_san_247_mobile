import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dat_san_247_mobile/core/common/function/share_pref.dart';
import 'app_theme.dart';
import 'package:dat_san_247_mobile/core/common/db_keys_local.dart';

class ThemeService extends GetxService {
  // danh sách theme
  final themes = AppTheme.themes;
  // final themes = {
  //   "Light": AppTheme.lightTheme,
  //   "Dark": AppTheme.darkTheme,
  //   "Blue": AppTheme.blueTheme,
  //   "Green": AppTheme.greenTheme,
  // };

  // theme hiện tại
  final _currentTheme = "Light".obs;

  String get currentThemeKey => _currentTheme.value;
  ThemeData get currentTheme => themes[_currentTheme.value]!;

  /// Load theme đã lưu từ SharedPr`eferences
  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(DbKeysLocal.themeKey) ?? "Light";
    _currentTheme.value = savedTheme;
    Get.changeTheme(themes[savedTheme]!);
  }

  /// Đổi theme + lưu lại
  Future<void> changeTheme(String key) async {
     final  SharedPreferences prefs = await SharedPreferences.getInstance();
    if (themes.containsKey(key)) {
      _currentTheme.value = key;
      Get.changeTheme(themes[key]!);

      prefs.setString(DbKeysLocal.themeKey, key);
    }
  }
}
