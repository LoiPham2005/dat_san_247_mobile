// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/presentation/pages/forgot_password_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/auth_request.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      toast.error('Vui lòng nhập email');
      return;
    }

    context.read<AuthCubit>().forgotPassword(ForgotPasswordRequest(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, BaseState>(
        listener: (context, state) {
          if (state.isFailure) {
            toast.error(state.error ?? 'Gửi yêu cầu thất bại');
          }
          if (state.isSuccess) {
            toast.success('Mã OTP đã được gửi!');
            OtpRoute(
              contactInfo: _emailController.text.trim(),
              type: 'RESET_PASSWORD',
            ).push(context);
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
                      controller: _emailController,
                    ),
                    const SizedBox(height: 32),

                    // Action Button
                    AuthPrimaryButton(
                      text: 'Gửi Yêu Cầu OTP',
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
