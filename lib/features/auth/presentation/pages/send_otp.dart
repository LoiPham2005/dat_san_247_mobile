import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/widget/animation/page_transition.dart';
import 'package:dat_san_247_mobile/core/widget/toast/show_toast.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/reset_password.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_forgot_auth.dart';
import 'package:toastification/toastification.dart';

class SendOtp extends StatefulWidget {
  final String email;
  const SendOtp({super.key, required this.email});

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthController controller = Get.find<AuthController>();
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 48,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFAF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5E8E1)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  Future<void> handleOtpSubmit() async {
    final otp = _controllers.map((e) => e.text).join();
    if (otp.length < 6) {
      ShowToast(
        context,
        message: "Vui lòng nhập đủ 6 số OTP",
        type: ToastificationType.error,
      );
      return;
    }

    // Hiển thị loading
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    final user = await controller.sendOtp(widget.email, otp);

    Get.back(); // Tắt loading

    if (user != null) {
      Get.to(() => ResetPassword(email: widget.email, otp: otp),
          transition: Transition.rightToLeft);
    } else {
      ShowToast(
        context,
        message: "Mã OTP không hợp lệ",
        type: ToastificationType.error,
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
              const SizedBox(height: 60),
              const HeaderForgotAuth(title: "Quên mật khẩu"),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, _buildOtpBox),
              ),
              const SizedBox(height: 24),
              ButtonAuth(
                name: "Gửi",
                onPressed: handleOtpSubmit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
