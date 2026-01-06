import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

extension LottieAssetX on String {
  /// Load Lottie animation from asset path
  Widget lottie({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    bool animate = true,
    bool repeat = true, 
    bool reverse = false,
    VoidCallback? onLoaded,
  }) {
    return Lottie.asset(
      this,
      width: width,
      height: height,
      fit: fit,
      animate: animate,
      repeat: repeat,
      reverse: reverse,
      onLoaded: (composition) {
        onLoaded?.call();
      },
    );
  }
}
