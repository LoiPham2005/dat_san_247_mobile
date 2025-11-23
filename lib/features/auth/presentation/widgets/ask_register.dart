import 'package:dat_san_247_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class AskRegister extends StatelessWidget {
  const AskRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Bạn chưa có tài khoản? ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => RegisterPage(),
                transition: Transition.rightToLeft);
          },
          child: const Text(
            "Đăng ký ngay",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
