import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/auth_request.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';

class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // ── Listen to auth results ──
    useAsyncValueListener(
      provider: authProvider,
      ref: ref,
      notifier: authNotifier,
      onSuccess: (_) {
        OtpRoute(
          contactInfo: emailController.text.trim(),
          type: 'RESET_PASSWORD',
        ).push(context);
      },
    );

    void onSubmit() {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        toast.error('Vui lòng nhập email');
        return;
      }

      authNotifier.forgotPassword(ForgotPasswordRequest(email: email));
    }

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
                title: 'Quên Mật Khẩu',
                subtitle: 'Vui lòng nhập Email hoặc Số điện thoại. Chúng tôi sẽ gửi một mã OTP để tạo lại mật khẩu mới.',
              ),
              const SizedBox(height: 48),

              // Form
              AuthFormField(
                label: 'Email / Số điện thoại',
                hintText: 'Nhập thông tin tại đây',
                prefixIcon: Icons.contact_mail_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 32),

              // Action Button
              AuthPrimaryButton(
                text: 'Gửi Yêu Cầu OTP',
                isLoading: authState.isLoading,
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
