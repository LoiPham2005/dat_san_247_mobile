import 'dart:async';
import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/auth_request.dart';
import '../providers/auth_notifier.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';

class OtpPage extends HookConsumerWidget {
  final String contactInfo;
  final String type; // 'EMAIL_VERIFY' or 'RESET_PASSWORD'

  const OtpPage({
    super.key,
    required this.contactInfo,
    this.type = 'EMAIL_VERIFY',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = useMemoized(() => List.generate(6, (index) => TextEditingController()));
    final focusNodes = useMemoized(() => List.generate(6, (index) => FocusNode()));
    final countdown = useState(60);
    final timerRef = useRef<Timer?>(null);

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    void startTimer() {
      timerRef.value?.cancel();
      timerRef.value = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown.value == 0) {
          timer.cancel();
        } else {
          countdown.value--;
        }
      });
    }

    useEffect(() {
      startTimer();
      return () => timerRef.value?.cancel();
    }, []);

    void onVerify() {
      final code = controllers.map((c) => c.text).join();
      if (code.length < 6) return;

      if (type == 'RESET_PASSWORD') {
        authNotifier.verifyOtp(
          VerifyOtpRequest(
            email: contactInfo,
            code: code,
            type: type,
          ),
        );
      } else {
        authNotifier.verifyEmail(
          VerifyOtpRequest(
            email: contactInfo,
            code: code,
            type: type,
          ),
        );
      }
    }

    void onOtpChanged(String value, int index) {
      if (value.length == 1 && index < 5) {
        focusNodes[index + 1].requestFocus();
      }
      if (value.isEmpty && index > 0) {
        focusNodes[index - 1].requestFocus();
      }

      // Auto submit if all filled
      if (controllers.every((c) => c.text.isNotEmpty)) {
        onVerify();
      }
    }

    // ── Listen to auth results ──
    useAsyncValueListener(
      provider: authProvider,
      ref: ref,
      notifier: authNotifier,
      onSuccess: (_) {
        if (type == 'RESET_PASSWORD') {
          ResetPasswordRoute(
            email: contactInfo,
            code: controllers.map((c) => c.text).join(),
          ).push(context);
        } else {
          const LoginRoute().go(context);
        }
      },
    );

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
                subtitle: 'Vui lòng nhập mã gồm 6 chữ số đã được gửi đến ${contactInfo}',
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
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      onChanged: (value) => onOtpChanged(value, index),
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
                isLoading: authState.isLoading,
                onPressed: onVerify,
              ),

              const SizedBox(height: 32),

              // Resend prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa nhận được mã? ', style: TextStyle(color: AppColors.textSecondary)),
                  if (countdown.value > 0)
                    Text(
                      'Gửi lại sau ${countdown.value}s',
                      style: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.bold),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        countdown.value = 60;
                        startTimer();
                        authNotifier.resendOtp(contactInfo, type);
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
  }
}
