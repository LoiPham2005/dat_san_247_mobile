// ========================================
// 📁 lib/core/theme/app_theme.dart
// ========================================
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'base_theme.dart';

// ✅ ENUM cho theme colors
enum ThemeColorType {
  blue,
  green,
  red,
  purple,
  orange,
  pink,
  teal,
  indigo,
  lime,
  yellow,
  black,
  white,
}

// ✅ ENUM cho theme mode
enum AppThemeMode { light, dark, system }

class AppTheme {
  AppTheme._();

  // ✅ Theme names & icons
  static const Map<ThemeColorType, String> themeNames = {
    ThemeColorType.blue: '🔵 Ocean Blue',
    ThemeColorType.green: '🟢 Nature Green',
    ThemeColorType.red: '🔴 Passion Red',
    ThemeColorType.purple: '🟣 Royal Purple',
    ThemeColorType.orange: '🟠 Sunset Orange',
    ThemeColorType.pink: '💗 Sweet Pink',
    ThemeColorType.teal: '🌊 Calm Teal',
    ThemeColorType.indigo: '🎨 Deep Indigo',
    ThemeColorType.lime: '💚 Lime Green',
    ThemeColorType.yellow: '⭐ Sunny Yellow',
    ThemeColorType.black: '⚫ Midnight Black',
    ThemeColorType.white: '⚪ Pure White',
  };

  static const Map<ThemeColorType, IconData> themeIcons = {
    ThemeColorType.blue: Icons.water_drop,
    ThemeColorType.green: Icons.eco,
    ThemeColorType.red: Icons.favorite,
    ThemeColorType.purple: Icons.auto_awesome,
    ThemeColorType.orange: Icons.wb_sunny,
    ThemeColorType.pink: Icons.cake,
    ThemeColorType.teal: Icons.waves,
    ThemeColorType.indigo: Icons.nights_stay,
    ThemeColorType.yellow: Icons.star,
    ThemeColorType.black: Icons.dark_mode,
    ThemeColorType.white: Icons.light_mode,
  };

  // ✅ Get all theme names
  static List<ThemeColorType> get allThemes => ThemeColorType.values;

  // ✅ Build light theme
  static ThemeData getLightTheme(ThemeColorType colorType) {
    final colorKey = colorType.name; // 'blue', 'green', etc.
    final colors = AppColors.themeColors[colorKey];

    if (colors == null) {
      throw Exception('Theme color "$colorKey" not found!');
    }

    return BaseTheme.buildBaseTheme(
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSurface: AppColors.textSecondary,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: colors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // ✅ Build dark theme
  static ThemeData getDarkTheme(ThemeColorType colorType) {
    final colorKey = colorType.name;
    final colors = AppColors.themeColors[colorKey];

    if (colors == null) {
      throw Exception('Theme color "$colorKey" not found!');
    }

    return BaseTheme.buildBaseTheme(
      colorScheme: ColorScheme.dark(
        primary: colors.primaryLight,
        secondary: colors.secondaryLight,
        surface: const Color(0xFF1E1E1E),
        error: AppColors.error,
        onPrimary: AppColors.black,
        onSurface: AppColors.white,
        outline: const Color(0xFF424242),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: colors.primaryLight,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: colors.primaryLight,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
