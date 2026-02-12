import 'package:dat_san_247_mobile/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

class HeaderAuth extends StatelessWidget {
  final String title;
  final String content;

  const HeaderAuth({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        60.height,
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
        ),
        // Image.asset(
        //   ImagePath.logoApp,
        //   width: 143,
        // ),
        13.height,
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        13.height,
        Text(
          content,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
