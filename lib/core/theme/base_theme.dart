import 'package:flutter/material.dart';

import 'app_text_styles.dart';

class BaseTheme {
  BaseTheme._();

  static ThemeData buildBaseTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required AppBarTheme appBarTheme,
    required BottomNavigationBarThemeData bottomNavTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: appBarTheme,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBarTheme: bottomNavTheme,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.s32.w400.size(57).letterSpace(-0.25),
        displayMedium: AppTextStyles.s32.w400.size(45),
        displaySmall: AppTextStyles.s32.w400.size(36),
        headlineLarge: AppTextStyles.s32.w400,
        headlineMedium: AppTextStyles.s28.w400,
        headlineSmall: AppTextStyles.s24.w400,
        titleLarge: AppTextStyles.s22.w500,
        titleMedium: AppTextStyles.s16.w500.letterSpace(0.15),
        titleSmall: AppTextStyles.s14.w500.letterSpace(0.1),
        bodyLarge: AppTextStyles.s16.w400.letterSpace(0.5),
        bodyMedium: AppTextStyles.s14.w400.letterSpace(0.25),
        bodySmall: AppTextStyles.s12.w400.letterSpace(0.4),
        labelLarge: AppTextStyles.s14.w500.letterSpace(0.1),
        labelMedium: AppTextStyles.s12.w500.letterSpace(0.5),
        labelSmall: AppTextStyles.s11.w500.letterSpace(0.5),
      ),
    );
  }
}
