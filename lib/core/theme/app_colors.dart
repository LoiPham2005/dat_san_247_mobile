// ========================================
// 📁 lib/core/theme/app_colors.dart
// ========================================
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ✅ ĐỊNH NGHĨA TẤT CẢ THEME COLORS
  static const Map<String, ColorSet> themeColors = {
    'court': ColorSet(
      primary: Color(0xFF27AE60), // Sporty Green
      primaryLight: Color(0xFF58D68D),
      primaryDark: Color(0xFF1E8449),
      secondary: Color(0xFFF1C40F), // Tennis Yellow
      secondaryLight: Color(0xFFF7DC6F),
      secondaryDark: Color(0xFFD4AC0D),
    ),
    'blue': ColorSet(
      primary: Color(0xFF2196F3),
      primaryLight: Color(0xFF64B5F6),
      primaryDark: Color(0xFF1976D2),
      secondary: Color(0xFFFF9800),
      secondaryLight: Color(0xFFFFB74D),
      secondaryDark: Color(0xFFF57C00),
    ),
    'green': ColorSet(
      primary: Color(0xFF27AE60),
      primaryLight: Color(0xFF81C784),
      primaryDark: Color(0xFF388E3C),
      secondary: Color(0xFFFF5722),
      secondaryLight: Color(0xFFFF8A65),
      secondaryDark: Color(0xFFE64A19),
    ),
    'red': ColorSet(
      primary: Color(0xFFF44336),
      primaryLight: Color(0xFFE57373),
      primaryDark: Color(0xFFD32F2F),
      secondary: Color(0xFF9C27B0),
      secondaryLight: Color(0xFFBA68C8),
      secondaryDark: Color(0xFF7B1FA2),
    ),
    'purple': ColorSet(
      primary: Color(0xFF9C27B0),
      primaryLight: Color(0xFFBA68C8),
      primaryDark: Color(0xFF7B1FA2),
      secondary: Color(0xFFFF9800),
      secondaryLight: Color(0xFFFFB74D),
      secondaryDark: Color(0xFFF57C00),
    ),
    'orange': ColorSet(
      primary: Color(0xFFFF9800),
      primaryLight: Color(0xFFFFB74D),
      primaryDark: Color(0xFFF57C00),
      secondary: Color(0xFF2196F3),
      secondaryLight: Color(0xFF64B5F6),
      secondaryDark: Color(0xFF1976D2),
    ),
    'pink': ColorSet(
      primary: Color(0xFFE91E63),
      primaryLight: Color(0xFFF06292),
      primaryDark: Color(0xFFC2185B),
      secondary: Color(0xFF00BCD4),
      secondaryLight: Color(0xFF4DD0E1),
      secondaryDark: Color(0xFF0097A7),
    ),
    'teal': ColorSet(
      primary: Color(0xFF009688),
      primaryLight: Color(0xFF4DB6AC),
      primaryDark: Color(0xFF00796B),
      secondary: Color(0xFFFF5722),
      secondaryLight: Color(0xFFFF8A65),
      secondaryDark: Color(0xFFE64A19),
    ),
    'indigo': ColorSet(
      primary: Color(0xFF3F51B5),
      primaryLight: Color(0xFF7986CB),
      primaryDark: Color(0xFF303F9F),
      secondary: Color(0xFFFFEB3B),
      secondaryLight: Color(0xFFFFF176),
      secondaryDark: Color(0xFFFBC02D),
    ),
    // ✅ THÊM: Xanh lá, vàng, đen, trắng
    'lime': ColorSet(
      primary: Color(0xFFCDDC39),
      primaryLight: Color(0xFFDEF059),
      primaryDark: Color(0xFFAFB42B),
      secondary: Color(0xFF2196F3),
      secondaryLight: Color(0xFF64B5F6),
      secondaryDark: Color(0xFF1976D2),
    ),
    'yellow': ColorSet(
      primary: Color(0xFFFFD54F),
      primaryLight: Color(0xFFFFE082),
      primaryDark: Color(0xFFFFA000),
      secondary: Color(0xFF2196F3),
      secondaryLight: Color(0xFF64B5F6),
      secondaryDark: Color(0xFF1976D2),
    ),
    'black': ColorSet(
      primary: Color(0xFF212121),
      primaryLight: Color(0xFF424242),
      primaryDark: Color(0xFF000000),
      secondary: Color(0xFFFFEB3B),
      secondaryLight: Color(0xFFFFF176),
      secondaryDark: Color(0xFFFBC02D),
    ),
    'white': ColorSet(
      primary: Color(0xFFFFFFFF),
      primaryLight: Color(0xFFF5F5F5),
      primaryDark: Color(0xFFEEEEEE),
      secondary: Color(0xFF212121),
      secondaryLight: Color(0xFF424242),
      secondaryDark: Color(0xFF000000),
    ),
  };

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color primary = Color(0xFF27AE60);
  static const Color primaryLight = Color(0xFF58D68D);
  static const Color primaryDark = Color(0xFF1E8449);
  static const Color secondary = Color(0xFFF1C40F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF2C3E50);
  static const Color grey = Color(0xFF95A5A6);
  static const Color greyLight = Color(0xFFECF0F1);
  static const Color greyDark = Color(0xFF7F8C8D);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF8F9FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textHint = Color(0xFFBDC3C7);
  static const Color textDisabled = Color(0xFFD5DBDB);

  // Border Colors
  static const Color border = Color(0xFFD5DBDB);
  static const Color divider = Color(0xFFE5E8E8);
}

// ✅ ColorSet class
class ColorSet {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;

  const ColorSet({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
  });
}
