import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dat_san_247_mobile/core/widgets/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/utils/function/validator.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/show_toast.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/loading_overlay.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/input_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/remember_pass.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/ask_register.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/footer_auth.dart';
import 'package:dat_san_247_mobile/features/bottomMenu/screens/bottom_menu_custom.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthController controller = Get.put(AuthController());
  String message = '';

  // void _handleLogin() async {
  //   final emailText = email.text.trim();
  //   final passwordText = password.text.trim();

  //   final emailError = ValidatorApp.checkEmail(text: emailText);
  //   final passError = ValidatorApp.checkPass(text: passwordText);

  //   if (emailError != null || passError != null) {
  //     Get.snackbar(
  //       "Lỗi", // Tiêu đề
  //       emailError ?? passError ?? "Vui lòng nhập thông tin hợp lệ",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   final success = await controller.login(emailText, passwordText);

  //     print('2222222222222' + success.toString());
  //   if (success) {
  //     print("chạy vào đây 1111111111111110");

  //     Get.snackbar(
  //       "Đăng nhập", // Tiêu đề
  //       "Đăng nhập thành công",
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );

  //     Get.offAll(
  //       () => BottomMenuCustom(),
  //       transition: Transition.fade,
  //     );
  //   }
  // }

  void _handleLogin() async {
    final emailText = email.text.trim();
    final passwordText = password.text.trim();

    final message = ValidatorApp.validateLogin(emailText, passwordText);

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

    final success = await controller.login(emailText, passwordText);
    if (success) {
      Get.offAll(() => BottomMenuCustom(), transition: Transition.fade);
    } else {
      Get.snackbar(
        "Thông báo",
        "Đăng nhập không thành công",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
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
                50.height,
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
                const RememberPass(),
                30.height,
                ButtonAuth(name: "Đăng nhập", onPressed: _handleLogin),
                16.height,
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
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingOverlay(child: _buildLoginUI(context));
      }

      return _buildLoginUI(context);
    });
  }
}
