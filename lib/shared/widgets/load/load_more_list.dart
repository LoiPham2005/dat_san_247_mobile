
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/theme/app_colors.dart';

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
              color: AppColors.background,
              strokeWidth: 1,
            ),
          ),
        if (isLoad) const SizedBox(width: 10),
        Text(
          isMax
              ? 'Đã tải hết danh sách'
              : isLoad
                  ? 'Đang tải...'
                  : '',
        ),
      ],
    ),
  );
}
