import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:dat_san_247_mobile/core/widget/toast/show_toast.dart';
import 'package:dat_san_247_mobile/core/widget/toast/loading_overlay.dart';
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

  Future<void> _handleSendEmail(BuildContext context) async {
    final emailText = email.text.trim();
    if (emailText.isEmpty) {
      ShowToast(
        context,
        message: "Vui lòng nhập email",
        type: ToastificationType.error,
      );
      return;
    }

    // Hiển thị loading thủ công
    Get.dialog(const CircularProgressIndicator(), barrierDismissible: false);

    final success = await controller.sendEmail(emailText);

    Get.back(); // tắt loading

    if (success) {
      ShowToast(
        context,
        message: "Gửi email thành công!",
        type: ToastificationType.success,
      );
      Navigator.push(
        context,
        PageTransition.slideTransition(SendOtp(email: emailText)),
      );
    } else {
      ShowToast(
        context,
        message: "Gửi email thất bại!",
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              HeaderForgotAuth(title: "Quên mật khẩu"),
              50.withHeight,
              InputAuth(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
                suffixIcon: false,
                hintText: "Nhập email",
              ),
              16.withHeight,
              ButtonAuth(
                name: "Gửi",
                onPressed: () => _handleSendEmail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
