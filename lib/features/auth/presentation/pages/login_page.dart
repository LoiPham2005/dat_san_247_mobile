import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/dev_quick_login_banner.dart';
import '../widgets/register_prompt.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DevQuickLoginBanner(),
              const SizedBox(height: 20),
              const AuthHeader(
                title: 'Chào mừng trở lại!',
                subtitle: 'Vui lòng đăng nhập để tiếp tục',
              ),
              const SizedBox(height: 40),

              // Form
              const AuthFormField(
                label: 'Email / Số điện thoại',
                hintText: 'Nhập email hoặc số điện thoại',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const AuthFormField(
                label: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(RouteNames.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: AppColors.primaryLightBrand,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              AuthPrimaryButton(
                text: 'Đăng Nhập',
                onPressed: () => const MainShellRoute().push(context),
              ),

              const SizedBox(height: 32),
              const RegisterPrompt(),
            ],
          ),
        ),
      ),
    );
  }
}
