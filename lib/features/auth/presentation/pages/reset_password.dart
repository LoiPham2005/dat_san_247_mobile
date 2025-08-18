import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_forgot_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/input_auth.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';

class ResetPassword extends ConsumerStatefulWidget {
  final String email;
  final String otp;
  const ResetPassword({super.key, required this.email, required this.otp});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const HeaderForgotAuth(title: "đổi mật khẩu"),
              const SizedBox(height: 20),
              Text("Điền mã OTP đã gửi đến số điện thoại của bạn."),
              20.height,
              InputAuth(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  hintText: "Nhập mật khẩu mới",
                  icon: Icon(Icons.password_outlined),
                  suffixIcon: true),
              20.height,
              ButtonAuth(
                name: "Gửi",
                onPressed: () {
                  Navigator.push(context,
                      PageTransition.slideTransition(BottomMenuCustom()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
