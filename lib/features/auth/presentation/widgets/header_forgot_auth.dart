import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';

class HeaderForgotAuth extends StatelessWidget {
  final String title;
  final String? content;
  const HeaderForgotAuth({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Responsive.safePaddingTopAuth(context).withHeight,
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
        ),
        Image.asset(
          ImagePath.logoApp,
          width: 206,
          height: 206,
        ),
        73.height,
        Text(title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            )),
        if (content != null)
          Text(content!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              )),
      ],
    );
  }
}
