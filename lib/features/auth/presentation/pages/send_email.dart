import 'package:dat_san_247_mobile/core/utils/function/validator.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/widgets/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/loading_overlay.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/send_otp.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_forgot_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/input_auth.dart';
import 'package:toastification/toastification.dart';

class SendEmail extends StatelessWidget {
  SendEmail({super.key});

  final TextEditingController email = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  Future<void> _handleSendEmail() async {
    final emailText = email.text.trim();
    final emailError = ValidatorApp.checkEmail(text: emailText);
    if (emailError != null) {
      Get.snackbar(
        "Lỗi",
        emailError,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Hiển thị loading thủ công
    Get.dialog(const CircularProgressIndicator(), barrierDismissible: false);

    final success = await controller.sendEmail(emailText);

    Get.back();

    if (success) {
      Get.snackbar(
        "Thành công",
        "Gửi email thành công!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.off(
        () => SendOtp(email: emailText),
        transition: Transition.rightToLeft,
      );
    } else {
      Get.snackbar(
        "Thất bại",
        "Gửi email thất bại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              HeaderForgotAuth(title: "Quên mật khẩu"),
              50.height,
              InputAuth(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
                suffixIcon: false,
                hintText: "Nhập email",
              ),
              16.height,
              ButtonAuth(name: "Gửi", onPressed: _handleSendEmail),
            ],
          ),
        ),
      ),
    );
  }
}
