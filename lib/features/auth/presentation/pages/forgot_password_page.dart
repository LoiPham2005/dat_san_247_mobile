import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../widgets/auth_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isEmailSent = false;

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
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(bottom: 24, top: 20),
                decoration: BoxDecoration(
                  color: AppColors.primaryLightBrand.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.password_rounded, size: 40, color: AppColors.primaryLightBrand),
              ),
              const Text(
                'Quên Mật Khẩu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Vui lòng nhập Email hoặc Số điện thoại. Chúng tôi sẽ gửi một mã OTP để tạo lại mật khẩu mới.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Form
              const AuthFormField(
                label: 'Email / Số điện thoại',
                hintText: 'Nhập thông tin tại đây',
                prefixIcon: Icons.contact_mail_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),

              // Action Button
              ElevatedButton(
                onPressed: () {
                  // Simulate sending success
                  setState(() {
                    _isEmailSent = true;
                  });
                  // After OTP sends successfully, navigating to OTP screen is done in Cubit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBrand,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Gửi Yêu Cầu OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              
              if (_isEmailSent)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightBrand.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryLightBrand.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.primaryLightBrand),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Mã cấu hình gửi thành công! Hãy kiểm tra hòm thư của bạn.',
                            style: TextStyle(color: AppColors.primaryLightBrand, fontWeight: FontWeight.w600, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
