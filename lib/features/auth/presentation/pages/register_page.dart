import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/auth_request.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/login_prompt.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullNameController = useTextEditingController();
    final contactController = useTextEditingController();
    final passwordController = useTextEditingController();

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // ── Listen to auth results ──
    useAsyncValueListener(
      provider: authProvider,
      ref: ref,
      notifier: authNotifier,
      onSuccess: (_) {
        // Navigate to OTP page
        OtpRoute(contactInfo: contactController.text.trim()).push(context);
      },
    );

    void onRegister() {
      final fullName = fullNameController.text.trim();
      final contact = contactController.text.trim();
      final password = passwordController.text;

      if (fullName.isEmpty || contact.isEmpty || password.isEmpty) {
        toast.error('Vui lòng nhập đầy đủ thông tin');
        return;
      }

      final bool isEmail = contact.contains('@');

      authNotifier.register(
        RegisterRequest(
          fullName: fullName,
          email: isEmail ? contact : '', // Backend requires email for registration
          phone: isEmail ? null : contact, // Send null if it's an email
          password: password,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : const LoginRoute().go(context),
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
              AuthFormField(
                label: 'Họ và tên',
                hintText: 'Nhập họ và tên đầy đủ',
                prefixIcon: Icons.person_outline_rounded,
                controller: fullNameController,
              ),
              const SizedBox(height: 20),
              AuthFormField(
                label: 'SĐT / Email',
                hintText: 'Nhập số điện thoại hoặc email',
                prefixIcon: Icons.contact_mail_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: contactController,
              ),
              const SizedBox(height: 20),
              AuthFormField(
                label: 'Mật khẩu',
                hintText: 'Tạo mật khẩu',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 40),

              // Register Button
              AuthPrimaryButton(
                text: 'Đăng Ký',
                isLoading: authState.isLoading,
                onPressed: onRegister,
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
