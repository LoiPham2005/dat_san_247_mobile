import 'package:flutter/material.dart';

class ColorApp {
  ColorApp._();

  static final ColorApp instance = ColorApp._();

  static const primaryColor = Color(0xffE68A37);

  static const white = Color(0xffFFFFFF);
  static const whiteF6 = Color(0xfff6f6ff);

  static const gray46 = Color(0xff464447);
  static const grayE7 = Color(0xffE7E8E9);
  static const gray9B = Color(0xff9B9B9B);
  static const grayF6 = Color(0xffF6F6F6);
  static const orangeE6 = Color(0xffE68A37);

  static const gradient = LinearGradient(
    colors: [
      Color(0xffDEA939),
      Color(0xffFAE46C),
    ],
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
