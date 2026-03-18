import 'package:dat_san_247_mobile/features/auth/presentation/pages/dev_quick_login_page.dart';
import 'package:dat_san_247_mobile/features/customer/home/presentation/pages/home_page.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_form_field.dart';

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
              // ── Dev Quick Login Banner ──────────────────────────────────
              if (kDebugMode)
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DevQuickLoginPage())),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.developer_mode_rounded, color: Color(0xFF94A3B8), size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🛠 Dev Mode — Đăng nhập nhanh', style: TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('Chọn vai trò: Customer · Owner · Staff', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 14),
                      ],
                    ),
                  ),
                ),
              // ──────────────────────────────────────────────────────────
              const SizedBox(height: 20),
              // Header
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightBrand,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.sports_soccer, size: 40, color: AppColors.white),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Chào mừng trở lại!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng đăng nhập để tiếp tục',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
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
                  onPressed: () {
                    context.push('/forgot-password');
                  },
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
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement Login Logic
                  HomeRoute().push(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBrand,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Đăng Nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 32),
              // Register Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Chưa có tài khoản?',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Đăng ký ngay',
                      style: TextStyle(
                        color: AppColors.primaryLightBrand,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


