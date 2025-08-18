import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';

class HeaderAuth extends StatelessWidget {
  final String title;
  final String content;

  const HeaderAuth({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
        ),
        Image.asset(
          ImagePath.logoApp,
          width: 143,
        ),
        SizedBox(
          height: 13,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 13,
        ),
        Text(
          content,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
