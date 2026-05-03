import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/app_theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../gen/theme/color_palettes.dart';

part 'theme_state.freezed.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const factory ThemeState({
    @Default(AppColorTheme.light) AppColorTheme colorType,
    @Default(AppThemeMode.light) AppThemeMode themeMode,
  }) = _ThemeState;

  const ThemeState._();

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
}
