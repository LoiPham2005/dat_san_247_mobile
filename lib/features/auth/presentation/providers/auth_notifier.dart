import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_state.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_request.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_response.dart';
import 'package:dat_san_247_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier with BaseNotifier<Object?> {
  late AuthRepository _repository;

  @override
  Future<Object?> build() async {
    _repository = getIt<AuthRepository>();
    return null;
  }

  /// 🔐 Login
  Future<void> login(LoginRequest request, {AppLoginMode mode = AppLoginMode.customer}) =>
      runResult(
        action: () => _repository.login(request, mode: mode),
        mapper: (data) => data,
        successMessage: 'Đăng nhập thành công!',
      );

  /// 📝 Register
  Future<void> register(RegisterRequest request) => runResult(
    action: () => _repository.register(request),
    mapper: (data) => data,
    successMessage: 'Đăng ký thành công! Vui lòng kiểm tra email để xác thực.',
  );

  /// ✅ Verify Email (Consume OTP)
  Future<void> verifyEmail(VerifyOtpRequest request) => runResult(
    action: () => _repository.verifyEmail(request),
    mapper: (data) => data,
    successMessage: 'Xác thực email thành công!',
  );

  /// 🔍 Verify OTP (Just check validity)
  Future<void> verifyOtp(VerifyOtpRequest request) => runResult(
    action: () => _repository.verifyOtp(request),
    mapper: (data) => data,
    successMessage: 'Xác thực mã thành công!',
  );

  /// 🔄 Resend OTP
  Future<void> resendOtp(String email, String type) => runResult(
    action: () => _repository.resendOtp(email, type),
    mapper: (data) => data,
    successMessage: 'Mã xác thực mới đã được gửi!',
  );

  /// 📧 Forgot Password
  Future<void> forgotPassword(ForgotPasswordRequest request) => runResult(
    action: () => _repository.forgotPassword(request),
    mapper: (data) => data,
    successMessage: 'Mã xác thực đã được gửi tới email của bạn.',
  );

  /// 🔑 Reset Password
  Future<void> resetPassword(ResetPasswordRequest request) => runResult(
    action: () => _repository.resetPassword(request),
    mapper: (data) => data,
    successMessage: 'Đặt lại mật khẩu thành công!',
  );

  /// 🚪 Logout
  Future<void> logout() => runResult(
    action: () => _repository.logout(),
    mapper: (data) => data,
    successMessage: 'Đăng xuất thành công!',
  );
}
