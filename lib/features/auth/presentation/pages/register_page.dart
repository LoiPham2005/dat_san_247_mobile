import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dat_san_247_mobile/core/widgets/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/common/function/validator.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/loading_overlay.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';
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

  void _handleRegister() async {
    final nameText = username.text.trim();
    final emailText = email.text.trim();
    final passwordText = password.text.trim();
    final confirmPasswordText = confirmPassword.text.trim();
    // final phoneText = phone.text.trim();

    final message = ValidatorApp.validateRegister(
      name: nameText,
      email: emailText,
      password: passwordText,
      confirmPassword: confirmPasswordText,
      // phone: phoneText,
    );

    if (message != null) {
      Get.snackbar(
        "Thông báo",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await controller.register(
      nameText,
      emailText,
      passwordText,
      // phoneText,
    );

    if (success) {
      Get.offAll(() => BottomMenuCustom(), transition: Transition.fade);
    } else {
      Get.snackbar(
        "Thông báo",
        "Đăng ký không thành công",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
                  50.height,
                  InputAuth(
                    controller: username,
                    keyboardType: TextInputType.text,
                    hintText: "Nhập tên tài khoản",
                    obscureText: false,
                    icon: const Icon(Icons.person_outline),
                    suffixIcon: false,
                  ),
                  12.height,
                  InputAuth(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Nhập email",
                    obscureText: false,
                    icon: const Icon(Icons.email_outlined),
                    suffixIcon: false,
                  ),
                  12.height,
                  InputAuth(
                    controller: password,
                    keyboardType: TextInputType.text,
                    hintText: "Nhập password",
                    obscureText: true,
                    icon: const Icon(Icons.lock_outline),
                    suffixIcon: true,
                  ),
                  12.height,
                  InputAuth(
                    controller: confirmPassword,
                    keyboardType: TextInputType.text,
                    hintText: "Nhập lại password",
                    obscureText: true,
                    icon: const Icon(Icons.lock_outline),
                    suffixIcon: true,
                  ),
                  const Clause(),
                  30.height,
                  ButtonAuth(name: "Đăng ký", onPressed: _handleRegister),
                  16.height,
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
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingOverlay(child: _buildRegisterForm(context));
      }

      return _buildRegisterForm(context);
    });
  }
}
