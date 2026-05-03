import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import '../../../../design/theme/styles/app_colors.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/auth_request.dart';

class ResetPasswordPage extends HookConsumerWidget {
  final String email;
  final String code;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // ── Listen to auth results ──
    useAsyncValueListener(
      provider: authProvider,
      ref: ref,
      notifier: authNotifier,
      onSuccess: (_) {
        const LoginRoute().go(context);
      },
    );

    void onSubmit() {
      final password = passwordController.text;
      final confirm = confirmPasswordController.text;

      if (password.isEmpty || confirm.isEmpty) {
        toast.error('Vui lòng nhập đầy đủ mật khẩu');
        return;
      }

      if (password != confirm) {
        toast.error('Mật khẩu không khớp');
        return;
      }

      authNotifier.resetPassword(
        ResetPasswordRequest(
          email: email,
          code: code,
          newPassword: password,
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
                showIcon: true,
              ),
              const SizedBox(height: 40),

              AuthFormField(
                label: 'Mật khẩu mới',
                hintText: 'Nhập mật khẩu mới',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              AuthFormField(
                label: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu mới',
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 48),

              AuthPrimaryButton(
                text: 'Cập Nhật Mật Khẩu',
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
