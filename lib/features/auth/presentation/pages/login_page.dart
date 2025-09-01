import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dat_san_247_mobile/core/widgets/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/common/function/validator.dart';
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

  void _handleLogin(BuildContext context) async {
    final emailText = email.text.trim();
    final passwordText = password.text.trim();

    final emailError = ValidatorApp.checkEmail(text: emailText);
    final passError = ValidatorApp.checkPass(text: passwordText);

    if (emailError != null || passError != null) {
      // ShowToast(
      //   context,
      //   message: emailError ?? passError ?? "Vui lòng nhập thông tin hợp lệ",
      //   type: ToastificationType.error,
      // );

      Get.snackbar(
        "Lỗi", // Tiêu đề
        emailError ?? passError ?? "Vui lòng nhập thông tin hợp lệ",
        snackPosition: SnackPosition.TOP, // Hiển thị ở dưới màn hình
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
      return;
    }

    final success = await controller.login(emailText, passwordText);

    if (success) {
      print("không chạy vào đây 1111111111111110");
      // ShowToast(
      //   context,
      //   message: "Đăng nhập thành công",
      //   type: ToastificationType.success,
      // );

      Get.snackbar(
        "Đăng nhập", // Tiêu đề
        "Đăng nhập thành công",
        snackPosition: SnackPosition.TOP, // Hiển thị ở dưới màn hình
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
      Get.offAll(
        () => BottomMenuCustom(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 300),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => BottomMenuCustom()),
      // );
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
    return Obx(() {
      if (controller.isLoading.value) {
        return LoadingOverlay(child: _buildLoginUI(context));
      }

      return _buildLoginUI(context);
    });
  }
}
