// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/presentation/pages/reset_password_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import '../../../../design/theme/styles/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/auth_request.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordPage({
    super.key, 
    required this.email, 
    required this.code
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.isEmpty || confirm.isEmpty) {
      toast.error('Vui lòng nhập đầy đủ mật khẩu');
      return;
    }

    if (password != confirm) {
      toast.error('Mật khẩu không khớp');
      return;
    }

    context.read<AuthCubit>().resetPassword(
      ResetPasswordRequest(
        email: widget.email,
        code: widget.code,
        newPassword: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, BaseState>(
        listener: (context, state) {
          if (state.isFailure) {
            toast.error(state.error ?? 'Đặt lại mật khẩu thất bại');
          }
          if (state.isSuccess) {
            toast.success('Đặt lại mật khẩu thành công!');
            const LoginRoute().go(context);
          }
        },
        builder: (context, state) {
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
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    AuthFormField(
                      label: 'Xác nhận mật khẩu',
                      hintText: 'Nhập lại mật khẩu mới',
                      prefixIcon: Icons.lock_reset_rounded,
                      isPassword: true,
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 48),

                    AuthPrimaryButton(
                      text: 'Cập Nhật Mật Khẩu',
                      isLoading: state.isLoading,
                      onPressed: () => _onSubmit(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
