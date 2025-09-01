import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/widgets/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/register_page.dart';

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
            // Navigate to the registration page
            Navigator.push(
                context, PageTransition.slideTransition(RegisterPage()));
          },
          child: const Text(
            "Đăng ký ngay",
            style: TextStyle(
              fontSize: 14,
              color: ColorApp.primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
