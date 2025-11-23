
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  const TextTitle({
    super.key,
    required this.path,
    required this.title,
    this.action,
  });

  final String path;
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          path,
          width: 20,
          height: 20,
          color: ColorApp.primaryColor,
        ),
        // 16.width,
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class TextTitle2 extends StatelessWidget {
  const TextTitle2({
    super.key,
    required this.content,
    required this.title,
    this.colorContent,
    this.titleStyle,
    this.contentStyle,
  });

  final String content;
  final String title;
  final Color? colorContent;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Text(
          content,
          textAlign: TextAlign.end,
          style: contentStyle ?? TextStyle(
            fontWeight: FontWeight.w700,
            color: colorContent,
          ),
        ),
      ],
    );
  }
}
