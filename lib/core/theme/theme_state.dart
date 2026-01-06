// ========================================
// 📁 lib/core/theme/theme_state.dart
// ========================================
import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeState {
  final ThemeColorType colorType;
  final AppThemeMode themeMode;

  const ThemeState({
    this.colorType = ThemeColorType.blue,
    this.themeMode = AppThemeMode.light,
  });

  // ✅ Helper getters
  bool get isDark => themeMode == AppThemeMode.dark;
  bool get isLight => themeMode == AppThemeMode.light;
  bool get isSystem => themeMode == AppThemeMode.system;

  ThemeMode get materialThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeState copyWith({ThemeColorType? colorType, AppThemeMode? themeMode}) {
    return ThemeState(
      colorType: colorType ?? this.colorType,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeState &&
        other.colorType == colorType &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => colorType.hashCode ^ themeMode.hashCode;

  @override
  String toString() =>
      'ThemeState(colorType: $colorType, themeMode: $themeMode)';
}
