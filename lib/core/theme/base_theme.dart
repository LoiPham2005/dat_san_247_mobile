// import 'package:flutter/material.dart';
// import 'app_colors.dart';

// class BaseTheme {
//   static ThemeData build({
//     required Color seed,
//     required Brightness brightness,
//     required Color inversePrimary,
//   }) {
//     final colorScheme = ColorScheme.fromSeed(
//       seedColor: seed,
//       brightness: brightness,
//       primary: AppColors.primary,
//     );

//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: colorScheme,
//       brightness: brightness,
//       scaffoldBackgroundColor: AppColors.background,
//       fontFamily: 'Roboto',

//       // 🔹 AppBar Theme
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: AppColors.textPrimary),
//         titleTextStyle: TextStyle(
//           color: AppColors.textPrimary,
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),

//       // 🔹 ElevatedButton Theme
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(26),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//           elevation: 3,
//         ),
//       ),

//       // 🔹 OutlinedButton Theme
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: BorderSide(color: AppColors.primary, width: 1.5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),

//       // 🔹 TextButton Theme
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           textStyle: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//       ),

//       // 🔹 Input Fields
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.inputBackground,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.primary, width: 2),
//         ),
//         hintStyle: TextStyle(color: Colors.grey[500]),
//       ),

//       // 🔹 Text Theme
//       textTheme: TextTheme(
//         bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
//         bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
//         titleLarge: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: AppColors.textPrimary,
//           fontSize: 20,
//         ),
//       ),
//     );
//   }
// }

import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:flutter/material.dart';

class BaseTheme {
  static ThemeData build({
    required Color seed,
    required Brightness brightness,
    required Color inversePrimary,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      inversePrimary: inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: ColorApp.background,
      fontFamily: 'Roboto',

      // 🔹 AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: seed,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        elevation: 0,
      ),

      // 🔹 TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // 🔹 ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 🔹 OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
