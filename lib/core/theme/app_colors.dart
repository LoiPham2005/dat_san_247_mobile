// // lib/core/theme/app_colors.dart
// import 'package:flutter/material.dart';

// class AppColors {
//   AppColors._();

//   // Primary Colors
//   static const Color primary = Color(0xFF2196F3);
//   static const Color primaryLight = Color(0xFF64B5F6);
//   static const Color primaryDark = Color(0xFF1976D2);

//   // Secondary Colors
//   static const Color secondary = Color(0xFFFF9800);
//   static const Color secondaryLight = Color(0xFFFFB74D);
//   static const Color secondaryDark = Color(0xFFF57C00);

//   // Status Colors
//   static const Color success = Color(0xFF4CAF50);
//   static const Color warning = Color(0xFFFFC107);
//   static const Color error = Color(0xFFF44336);
//   static const Color info = Color(0xFF2196F3);

//   // Neutral Colors
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color black = Color(0xFF000000);
//   static const Color grey = Color(0xFF9E9E9E);
//   static const Color greyLight = Color(0xFFE0E0E0);
//   static const Color greyDark = Color(0xFF616161);

//   // Background Colors
//   static const Color background = Color(0xFFF5F5F5);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color scaffoldBackground = Color(0xFFFAFAFA);

//   // Text Colors
//   static const Color textPrimary = Color(0xFF212121);
//   static const Color textSecondary = Color(0xFF757575);
//   static const Color textHint = Color(0xFFBDBDBD);
//   static const Color textDisabled = Color(0xFFE0E0E0);

//   // Border Colors
//   static const Color border = Color(0xFFE0E0E0);
//   static const Color divider = Color(0xFFBDBDBD);
// }

// ========================================
// 📁 lib/core/theme/app_colors.dart
// ========================================
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ✅ ĐỊNH NGHĨA TẤT CẢ THEME COLORS
  static const Map<String, ColorSet> themeColors = {
    'blue': ColorSet(
      primary: Color(0xFF2196F3),
      primaryLight: Color(0xFF64B5F6),
      primaryDark: Color(0xFF1976D2),
      secondary: Color(0xFFFF9800),
      secondaryLight: Color(0xFFFFB74D),
      secondaryDark: Color(0xFFF57C00),
    ),
    'green': ColorSet(
      primary: Color(0xFF4CAF50),
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
  static const Color white = Color(0xFFFFFFFF);
  // static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  // Text Colors
  // static const Color textPrimary = Color(0xFF212121);
  // static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFFE0E0E0);

  // Border Colors
  // static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);


    static const primaryColor = Color(0xff62b766);
  // Base colors
  static const Color primaryGreen = Color(0xff4fa553);
  static const Color lightGreen = Color(0xff62b766);
  // static const Color background = Color(0xffF5F5F5);

  // Gradient colors
  static List<Color> primaryGradient = [primaryGreen, lightGreen];

  // static const white = Color(0xffFFFFFF);
  static const whiteF6 = Color(0xfff6f6ff);

  static const black = Color(0xff464447);


  static const gray46 = Color(0xff464447);
  static const grayE7 = Color(0xffE7E8E9);
  static const gray9B = Color(0xff9B9B9B);
  static const gray82 = Color(0xff9B9B9B);

  static const grayF6 = Color(0xffF6F6F6);
  static const orangeE6 = Color(0xffE68A37);

  static const redF0 = Color(0xffE68A37);

  // Màu chính (Primary)
  static const Color primary = Color(0xff62b766);
  static const Color primary2 = Color(0xff4fa553);

  // Màu text
  static const Color textPrimary = Color(0xff2d5533);
  static const Color textSecondary = Color(0xff6c757d);

  // Màu nền
  static const Color inputBackground = Color(0xfff8f9fa);

  // Màu border
  static const Color border = Color(0xffe0e0e0);

  // Màu phụ trợ
  static const Color google = Color(0xffdb4437);
  static const Color facebook = Color(0xff4267b2);

  // Màu thông báo
  // static const Color error = Colors.red;
  // static const Color success = Color(0xff28a745);

  static const gradient = LinearGradient(
    colors: [Color(0xff62b766), Color(0xff4fa553)],
    end: Alignment.centerRight,
    begin: Alignment.centerLeft,
  );
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
