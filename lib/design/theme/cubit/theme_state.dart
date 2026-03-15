// 📁 lib/design/theme/cubit/theme_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../gen/theme/color_palettes.dart';
import '../app_theme.dart';

class ThemeState extends Equatable {
  final AppColorTheme colorType;
  final AppThemeMode themeMode;

  const ThemeState({
    this.colorType = AppColorTheme.light,
    this.themeMode = AppThemeMode.light,
  });

  factory ThemeState.initial() => const ThemeState();

  // ✅ Helper getters
  bool get isDark => themeMode == AppThemeMode.dark;
  bool get isLight => themeMode == AppThemeMode.light;
  bool get isSystem => themeMode == AppThemeMode.system;

  /// Map custom theme mode to Flutter Material ThemeMode
  ThemeMode get materialThemeMode => switch (themeMode) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.system => ThemeMode.system,
  };

  ThemeState copyWith({AppColorTheme? colorType, AppThemeMode? themeMode}) {
    return ThemeState(
      colorType: colorType ?? this.colorType,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [colorType, themeMode];

  @override
  String toString() =>
      'ThemeState(colorType: $colorType, themeMode: $themeMode)';
}
