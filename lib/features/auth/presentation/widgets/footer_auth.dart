import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';

class FooterAuth extends StatelessWidget {
  const FooterAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ImagePath.bgIntroBottom,
      ),
    );
  }
}
