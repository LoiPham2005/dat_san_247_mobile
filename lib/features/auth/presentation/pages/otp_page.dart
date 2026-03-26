// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/presentation/pages/otp_page.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/auth_request.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';

class OtpPage extends StatefulWidget {
  final String contactInfo;
  final String type; // 'EMAIL_VERIFY' or 'RESET_PASSWORD'
  
  const OtpPage({
    super.key, 
    required this.contactInfo,
    this.type = 'EMAIL_VERIFY',
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(BuildContext context, String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Auto submit if all filled
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _onVerify(context);
    }
  }

  void _onVerify(BuildContext context) {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) return;

    context.read<AuthCubit>().verifyEmail(
      VerifyOtpRequest(
        email: widget.contactInfo,
        code: code,
        type: widget.type,
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
            toast.error(state.error ?? 'Xác thực thất bại');
          }
          if (state.isSuccess) {
            toast.success(state.message ?? 'Xác thực thành công');
            if (widget.type == 'RESET_PASSWORD') {
              ResetPasswordRoute(
                email: widget.contactInfo,
                code: _controllers.map((c) => c.text).join(),
              ).push(context);
            } else {
              const LoginRoute().go(context);
            }
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
                    AuthHeader(
                      title: 'Xác thực mã OTP',
                      subtitle: 'Vui lòng nhập mã gồm 6 chữ số đã được gửi đến ${widget.contactInfo}',
                    ),
                    const SizedBox(height: 48),

                    // OTP Inputs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 48,
                          height: 56,
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            onChanged: (value) => _onOtpChanged(context, value, index),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.mutedLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.borderLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.borderLight),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primaryLightBrand, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Verify Button
                    AuthPrimaryButton(
                      text: 'Xác Thực',
                      isLoading: state.isLoading,
                      onPressed: () => _onVerify(context),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Resend prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa nhận được mã? ', style: TextStyle(color: AppColors.textSecondary)),
                        if (_countdown > 0)
                          Text(
                            'Gửi lại sau ${_countdown}s',
                            style: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.bold),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _countdown = 60;
                                startTimer();
                              });
                              // TODO: Implement resend OTP API call
                              context.read<AuthCubit>().forgotPassword(ForgotPasswordRequest(email: widget.contactInfo));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Gửi lại mã',
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
        },
      ),
    );
  }
}
