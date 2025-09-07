import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/pages/reset_password.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/button_auth.dart';
import 'package:dat_san_247_mobile/features/auth/presentation/widgets/header_forgot_auth.dart';

class SendOtp extends StatefulWidget {
  final String email;
  const SendOtp({super.key, required this.email});

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final AuthController controller = Get.find<AuthController>();

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  /// Widget ô nhập OTP
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
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  /// Xử lý xác nhận OTP
  Future<void> _handleOtpSubmit() async {
    final otp = _controllers.map((e) => e.text).join();

    // Validate OTP: phải đủ 6 số
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập đủ 6 số OTP",
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

    try {
      final isValidOtp = await controller.sendOtp(widget.email, otp);
      Get.back(); // Tắt loading

      if (isValidOtp) {
        Get.off(() => ResetPassword(email: widget.email, otp: otp),
            transition: Transition.rightToLeft);
      } else {
        Get.snackbar(
          "Lỗi",
          "Mã OTP không hợp lệ",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Lỗi",
        "Có lỗi xảy ra: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            60.height,
            const HeaderForgotAuth(title: "Quên mật khẩu"),
            40.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _buildOtpBox),
            ),
            24.height,
            ButtonAuth(
              name: "Gửi",
              onPressed: _handleOtpSubmit,
            ),
          ],
        ).paddingAll(24),
      ),
    );
  }
}
