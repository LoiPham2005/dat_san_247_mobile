import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:flutter/material.dart';

class BaseTheme {
  static ThemeData build({
    required Color seed,
    required Brightness brightness,
    required Color inversePrimary,
    
  }) {
    return ThemeData(
      useMaterial3: false, // Tắt Material 3 đi
      primaryColor: seed,
      primarySwatch: MaterialColor(seed.value, {
        50: seed.withOpacity(0.1),
        100: seed.withOpacity(0.2),
        200: seed.withOpacity(0.3),
        300: seed.withOpacity(0.4),
        400: seed.withOpacity(0.5),
        500: seed,
        600: seed.withOpacity(0.6),
        700: seed.withOpacity(0.7),
        800: seed.withOpacity(0.8),
        900: seed.withOpacity(0.9),
      }),
      scaffoldBackgroundColor: ColorApp.background,
      fontFamily: 'Roboto',

      // 🔹 AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: seed,
        foregroundColor: inversePrimary,
        centerTitle: true,
        elevation: 0,
      ),

      // 🔹 TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: seed,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // 🔹 ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: inversePrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 🔹 OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seed,
          side: BorderSide(color: seed, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // 🔹 InputDecoration (TextField, TextFormField)
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
