// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/presentation/pages/register_page.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth_request.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/login_prompt.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    final fullName = _fullNameController.text.trim();
    final contact = _contactController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty || contact.isEmpty || password.isEmpty) {
      toast.error('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    final bool isEmail = contact.contains('@');
    
    context.read<AuthCubit>().register(
          RegisterRequest(
            fullName: fullName,
            email: isEmail ? contact : '', // Backend requires email for registration
            phone: isEmail ? null : contact, // Send null if it's an email to avoid DB length error
            password: password,
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
            toast.error(state.error ?? 'Đăng ký thất bại');
          }
          if (state.isSuccess) {
            toast.success('Đăng ký thành công! Vui lòng kiểm tra email của bạn.');
            // Navigate to OTP page
            OtpRoute(contactInfo: _contactController.text.trim()).push(context);
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
                      controller: _fullNameController,
                    ),
                    const SizedBox(height: 20),
                    AuthFormField(
                      label: 'SĐT / Email',
                      hintText: 'Nhập số điện thoại hoặc email',
                      prefixIcon: Icons.contact_mail_outlined,
                      keyboardType: TextInputType.emailAddress,
                      controller: _contactController,
                    ),
                    const SizedBox(height: 20),
                    AuthFormField(
                      label: 'Mật khẩu',
                      hintText: 'Tạo mật khẩu',
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 40),

                    // Register Button
                    AuthPrimaryButton(
                      text: 'Đăng Ký',
                      isLoading: state.isLoading,
                      onPressed: () => _onRegister(context),
                    ),

                    const SizedBox(height: 24),
                    const LoginPrompt(),
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
