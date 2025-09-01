import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';

class HeaderIntro extends StatelessWidget {
  const HeaderIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(ImagePath.bgIntroTop);
  }
}
