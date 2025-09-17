import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:dat_san_247_mobile/core/theme/base_theme.dart';
import 'package:flutter/material.dart';

enum AppThemeKey { light, dark, green, blue }

class AppTheme {
  /// 🎭 Danh sách tất cả Theme
  static final Map<AppThemeKey, ThemeData> themes = {
    AppThemeKey.light: _lightTheme,
    AppThemeKey.dark: _darkTheme,
    AppThemeKey.green: _greenTheme,
    AppThemeKey.blue: _blueTheme,
  };

  // ----------------- LIGHT THEME -----------------
  static final ThemeData _lightTheme = BaseTheme.build(
    seed: Color(0xff62b766),
    brightness: Brightness.light,
    inversePrimary: Colors.deepPurple.shade200,
  );

  // ----------------- DARK THEME -----------------
  static final ThemeData _darkTheme = BaseTheme.build(
    seed: Colors.deepPurple,
    brightness: Brightness.dark,
    inversePrimary: Colors.deepPurple.shade200,
  );

  // ----------------- BLUE THEME -----------------
  static final ThemeData _blueTheme = BaseTheme.build(
    seed: Colors.blue,
    brightness: Brightness.light,
    inversePrimary: Colors.blue.shade200,
  );

  // ----------------- GREEN THEME -----------------
  static final ThemeData _greenTheme = BaseTheme.build(
    seed: Color(0xff62b766),
    brightness: Brightness.light,
    inversePrimary: Color(0xff4fa553),
  );
}
