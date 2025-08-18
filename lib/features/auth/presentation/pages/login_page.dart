import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/common/function/validator.dart';
import 'package:dat_san_247_mobile/core/widget/toast/show_toast.dart';
import 'package:dat_san_247_mobile/core/widget/toast/loading_overlay.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/input_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/remember_pass.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/ask_register.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/footer_auth.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthController controller = Get.put(AuthController());

  void _handleLogin(BuildContext context) async {
    final emailText = email.text.trim();
    final passwordText = password.text.trim();

    final emailError = ValidatorApp.checkEmail(text: emailText);
    final passError = ValidatorApp.checkPass(text: passwordText);

    if (emailError != null || passError != null) {
      ShowToast(
        context,
        message: emailError ?? passError ?? "Vui lòng nhập thông tin hợp lệ",
        type: ToastificationType.error,
      );
      return;
    }

    final success = await controller.login(emailText, passwordText);

    if (success) {
      ShowToast(context,
          message: "Đăng nhập thành công", type: ToastificationType.success);

      // Navigator.pushReplacement(
      //     context, PageTransition.slideTransition(BottomMenuCustom()));

      Get.offAll(() => BottomMenuCustom());
    }
  }

  Widget _buildLoginUI(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const HeaderAuth(
                  title: "ĐĂNG NHẬP",
                  content: "Đăng nhập bằng số điện thoại và mật khẩu của bạn",
                ),
                SizedBox(height: 50),
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
                const RememberPass(),
                SizedBox(height: 30),
                ButtonAuth(
                  name: "Đăng nhập",
                  onPressed: () => _handleLogin(context),
                ),
                SizedBox(height: 16),
                const AskRegister(),
              ],
            ),
          ),
          const Spacer(),
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
          return CircularProgressIndicator();
        }

        return _buildLoginUI(context);
      },
    );
  }
}
