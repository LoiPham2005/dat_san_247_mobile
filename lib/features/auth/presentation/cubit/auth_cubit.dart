// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/presentation/cubit/auth_cubit.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_state.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/auth_request.dart';
import '../../data/models/auth_response.dart';
import '../../data/repositories/auth_repository.dart';

@injectable
class AuthCubit extends BaseCubit<Object?> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(BaseState.initial());

  /// 🔐 Login
  Future<void> login(LoginRequest request, {AppLoginMode mode = AppLoginMode.customer}) async {
    await run<AuthResponse>(
      action: () => _repository.login(request, mode: mode),
      successMessage: 'Đăng nhập thành công!',
    );
  }

  /// 📝 Register
  Future<void> register(RegisterRequest request) async {
    await run<RegisterResponse>(
      action: () => _repository.register(request),
      successMessage: 'Đăng ký thành công! Vui lòng kiểm tra email để xác thực.',
    );
  }

  /// ✅ Verify Email (Consume OTP)
  Future<void> verifyEmail(VerifyOtpRequest request) async {
    await run<SimpleResponse>(
      action: () => _repository.verifyEmail(request),
      successMessage: 'Xác thực email thành công!',
    );
  }

  /// 🔍 Verify OTP (Just check validity)
  Future<void> verifyOtp(VerifyOtpRequest request) async {
    await run<SimpleResponse>(
      action: () => _repository.verifyOtp(request),
      successMessage: 'Xác thực mã thành công!',
    );
  }

  /// 🔄 Resend OTP
  Future<void> resendOtp(String email, String type) async {
    await run<SimpleResponse>(
      action: () => _repository.resendOtp(email, type),
      successMessage: 'Mã xác thực mới đã được gửi!',
    );
  }

  /// 📧 Forgot Password
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    await run<SimpleResponse>(
      action: () => _repository.forgotPassword(request),
      successMessage: 'Mã xác thực đã được gửi tới email của bạn.',
    );
  }

  /// 🔑 Reset Password
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await run<SimpleResponse>(
      action: () => _repository.resetPassword(request),
      successMessage: 'Đặt lại mật khẩu thành công!',
    );
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await run<SimpleResponse>(
      action: () => _repository.logout(),
      successMessage: 'Đăng xuất thành công!',
    );
  }
}
