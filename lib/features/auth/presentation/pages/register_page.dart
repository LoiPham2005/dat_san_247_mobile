import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/login_prompt.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.canPop() ? context.pop() : context.go(RouteNames.login),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'Tạo tài khoản mới',
                subtitle: 'Điền thông tin của bạn để tham gia vào nền tảng thể thao',
                showIcon: false,
                centerAlign: false,
              ),
              const SizedBox(height: 40),

              // Form
              const AuthFormField(
                label: 'Họ và tên',
                hintText: 'Nhập họ và tên đầy đủ',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 20),
              const AuthFormField(
                label: 'SĐT / Email',
                hintText: 'Nhập số điện thoại hoặc email',
                prefixIcon: Icons.contact_mail_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const AuthFormField(
                label: 'Mật khẩu',
                hintText: 'Tạo mật khẩu',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 40),

              // Register Button
              AuthPrimaryButton(
                text: 'Đăng Ký',
                onPressed: () {
                  // TODO: Implement Logic and Navigate to OTP Page
                },
              ),

              const SizedBox(height: 24),
              const LoginPrompt(),
            ],
          ),
        ),
      ),
    );
  }
}
