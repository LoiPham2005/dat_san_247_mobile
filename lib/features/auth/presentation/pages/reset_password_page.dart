import 'package:flutter/material.dart';
import '../../../../design/theme/styles/app_colors.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../../../../routes/constants/route_names.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'Đặt Lại Mật Khẩu',
                subtitle: 'Vui lòng nhập mật khẩu mới để bảo vệ tài khoản của bạn.',
                showIcon: true, // We could use a different icon like lock_reset, but soccer is the brand
              ),
              const SizedBox(height: 40),

              const AuthFormField(
                label: 'Mật khẩu mới',
                hintText: 'Nhập mật khẩu mới',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              const AuthFormField(
                label: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu mới',
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 48),

              AuthPrimaryButton(
                text: 'Cập Nhật Mật Khẩu',
                onPressed: () {
                  // TODO: Implement reset logic
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Mật khẩu của bạn đã được cập nhật thành công!')),
                  // );
                  context.go(RouteNames.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
