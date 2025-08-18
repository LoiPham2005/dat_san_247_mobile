import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/common/function/validator.dart';
import 'package:dat_san_247_mobile/core/widget/toast/loading_overlay.dart';
import 'package:dat_san_247_mobile/core/widget/toast/show_toast.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/clause.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/footer_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/input_auth.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  void _handleRegister(BuildContext context) async {
    final usernameText = username.text.trim();
    final emailText = email.text.trim();
    final passwordText = password.text.trim();
    final confirmPassText = confirmPassword.text.trim();

    final emailError = ValidatorApp.checkEmail(text: emailText);
    final passError = ValidatorApp.checkPass(text: passwordText);
    final usernameError = ValidatorApp.checkMinLength(
      text: usernameText,
      minLength: 3,
      fieldName: "Tên đăng nhập",
    );

    if (emailError != null || passError != null || usernameError != null) {
      ShowToast(
        context,
        message: emailError ??
            passError ??
            usernameError ??
            "Vui lòng nhập thông tin hợp lệ",
        type: ToastificationType.error,
      );
      return;
    }

    if (passwordText != confirmPassText) {
      ShowToast(
        context,
        message: "Mật khẩu không khớp!",
        type: ToastificationType.error,
      );
      return;
    }

    final success =
        await controller.register(usernameText, emailText, passwordText);

    if (success) {
      ShowToast(
        context,
        message: "Đăng ký thành công!",
        type: ToastificationType.success,
      );
      Navigator.pushReplacement(
        context,
        PageTransition.slideTransition(const BottomMenuCustom()),
      );
    }
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const HeaderAuth(
                    title: "ĐĂNG KÝ",
                    content: "Đăng ký bằng số điện thoại và mật khẩu của bạn",
                  ),
                  SizedBox(height: 50),
                  InputAuth(
                    controller: username,
                    keyboardType: TextInputType.text,
                    hintText: "Nhập tên tài khoản",
                    obscureText: false,
                    icon: const Icon(Icons.person_outline),
                    suffixIcon: false,
                  ),
                  SizedBox(height: 12),
                  InputAuth(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Nhập email",
                    obscureText: false,
                    icon: const Icon(Icons.email_outlined),
                    suffixIcon: false,
                  ),
                  SizedBox(height: 12),
                  InputAuth(
                    controller: password,
                    keyboardType: TextInputType.text,
                    hintText: "Nhập password",
                    obscureText: true,
                    icon: const Icon(Icons.lock_outline),
                    suffixIcon: true,
                  ),
                  SizedBox(height: 12),
                  InputAuth(
                    controller: confirmPassword,
                    keyboardType: TextInputType.text,
                    hintText: "Nhập lại password",
                    obscureText: true,
                    icon: const Icon(Icons.lock_outline),
                    suffixIcon: true,
                  ),
                  const Clause(),
                  SizedBox(height: 30),
                  ButtonAuth(
                    name: "Đăng ký",
                    onPressed: () => _handleRegister(context),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const FooterAuth(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const LoadingOverlay(isLoading: true);
        }

        return _buildRegisterForm(context);
      },
    );
  }
}
