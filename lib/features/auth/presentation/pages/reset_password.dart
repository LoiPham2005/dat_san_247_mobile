import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_forgot_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/input_auth.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPassword({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final password = _passwordController.text.trim();

    // Validate mật khẩu
    if (password.isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập mật khẩu mới",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        "Lỗi",
        "Mật khẩu phải có ít nhất 6 ký tự",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Hiển thị loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Gọi API đổi mật khẩu
    final success = await _authController.resetPassword(
      widget.email,
      widget.otp,
      password,
    );

    // Tắt loading
    Get.back();

    if (success) {
      Get.snackbar(
        "Thành công",
        "Đổi mật khẩu thành công",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Điều hướng về trang chủ
      Get.offAll(() => const BottomMenuCustom());
    } else {
      Get.snackbar(
        "Lỗi",
        "Đổi mật khẩu thất bại. Vui lòng thử lại!",
        snackPosition: SnackPosition.BOTTOM,
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              60.height,
              const HeaderForgotAuth(title: "Đổi mật khẩu"),
              20.height,
              const Text("Nhập mật khẩu mới cho tài khoản của bạn."),
              20.height,
              InputAuth(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                hintText: "Nhập mật khẩu mới",
                icon: const Icon(Icons.lock_outline),
                suffixIcon: true,
              ),
              20.height,
              ButtonAuth(
                name: "Gửi",
                onPressed: _handleResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
