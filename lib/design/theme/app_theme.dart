// 📁 lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/gen/fonts.gen.dart';

import '../../gen/theme/color_palettes.dart';
import '../../gen/theme/color_tokens.dart';
import 'cubit/theme_state.dart';

enum AppThemeMode { light, dark, system }

class AppTheme {
  AppTheme._();

  /// Delegate sang AppColorPalettes — không hardcode ở đây nữa
  static Map<AppColorTheme, String> get themeNames => AppColorPalettes.labels;
  static Map<AppColorTheme, IconData> get themeIcons => AppColorPalettes.icons;
  static List<AppColorTheme> get allThemes => AppColorPalettes.all;

  /// Shorthand dùng tại app.dart — không cần khai báo Brightness thủ công
  static ThemeData light(ThemeState state) =>
      build(palette: state.colorType, brightness: Brightness.light);

  static ThemeData dark(ThemeState state) =>
      build(palette: state.colorType, brightness: Brightness.dark);

  static ThemeData build({
    required AppColorTheme palette,
    required Brightness brightness,
  }) {
    final tokens = AppColorPalettes.of(palette);
    final colorScheme = _buildScheme(tokens, brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.bg.page,
      fontFamily: FontFamily.inter,
      extensions: [tokens],
    );
  }

  /// Map custom tokens → Material3 ColorScheme
  static ColorScheme _buildScheme(AppColorTokens t, Brightness b) =>
      ColorScheme(
        brightness: b,
        primary: t.brand.primary,
        onPrimary: t.text.onPrimary,
        secondary: t.brand.secondary,
        onSecondary: t.text.onPrimary,
        surface: t.bg.card,
        onSurface: t.text.title,
        error: t.status.error,
        onError: Colors.white,
        outline: t.border.defaultColor,
        shadow: t.surface.shadow,
      );
}
