
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:flutter/material.dart';

Widget LoadMoreList({bool isLoad = true, bool isMax = false}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoad)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: ColorApp.primaryColor,
              strokeWidth: 1,
            ),
          ),
        if (isLoad) const SizedBox(width: 10),
        Text(
          isMax
              ? "Đã tải hết danh sách"
              : isLoad
                  ? "Đang tải..."
                  : "",
        ),
      ],
    ),
  );
}
