import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_state.dart';

import '../../data/models/auth_request.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/dev_quick_login_banner.dart';
import '../widgets/register_prompt.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isStaffMode = useState(false);

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // ── Listen to auth results (Success/Error Toast + Navigation) ──
    useAsyncValueListener(
      provider: authProvider,
      ref: ref,
      notifier: authNotifier,
      onSuccess: (data) {
        // AppAuthService will handle the session, we just navigate
        // RouteGuards will handle the correct redirection
        const MainShellRoute().go(context);
      },
    );

    void onLogin() {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        toast.error('Vui lòng nhập đầy đủ thông tin');
        return;
      }

      final mode = isStaffMode.value ? AppLoginMode.staff : AppLoginMode.customer;

      authNotifier.login(
        LoginRequest(email: email, password: password),
        mode: mode,
      );
    }

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
              AuthFormField(
                label: 'Email / Số điện thoại',
                hintText: 'Nhập email hoặc số điện thoại',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 20),
              AuthFormField(
                label: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: passwordController,
              ),

              const SizedBox(height: 12),

              // Staff Toggle
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: isStaffMode.value,
                      onChanged: (value) => isStaffMode.value = value ?? false,
                      activeColor: AppColors.primaryLightBrand,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => isStaffMode.value = !isStaffMode.value,
                      child: const Text(
                        'Đăng nhập cho nhân viên sân',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => const ForgotPasswordRoute().push(context),
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
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Login Button
              AuthPrimaryButton(
                text: 'Đăng Nhập',
                isLoading: authState.isLoading,
                onPressed: onLogin,
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
