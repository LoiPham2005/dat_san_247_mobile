import 'package:flutter/material.dart';

class ColorApp {
  ColorApp._();

  static final ColorApp instance = ColorApp._();

  static const primaryColor = Color(0xff62b766);

  static const white = Color(0xffFFFFFF);
  static const whiteF6 = Color(0xfff6f6ff);

  static const gray46 = Color(0xff464447);
  static const grayE7 = Color(0xffE7E8E9);
  static const gray9B = Color(0xff9B9B9B);
  static const grayF6 = Color(0xffF6F6F6);
  static const orangeE6 = Color(0xffE68A37);

  // Màu chính (Primary)
  static const Color primary = Color(0xff62b766);
  static const Color primaryDark = Color(0xff4fa553);

  // Màu text
  static const Color textPrimary = Color(0xff2d5533);
  static const Color textSecondary = Color(0xff6c757d);

  // Màu nền
  static const Color background = Colors.white;
  static const Color inputBackground = Color(0xfff8f9fa);

  // Màu border
  static const Color border = Color(0xffe0e0e0);

  // Màu phụ trợ
  static const Color google = Color(0xffdb4437);
  static const Color facebook = Color(0xff4267b2);

  // Màu thông báo
  static const Color error = Colors.red;
  static const Color success = Color(0xff28a745);

  static const gradient = LinearGradient(
    colors: [Color(0xff62b766), Color(0xff4fa553)],
    end: Alignment.centerRight,
    begin: Alignment.centerLeft,
  );
  // static const gradientWhite = LinearGradient(
  //   colors: [
  //     Colors.white,
  //     grayF9,
  //   ],
  //   end: Alignment.bottomCenter,
  //   begin: Alignment.topCenter,
  // );
}
