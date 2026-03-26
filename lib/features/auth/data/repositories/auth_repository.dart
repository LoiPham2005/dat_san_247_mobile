// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/data/repositories/auth_repository.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/base/errors/result.dart';
import '../../../../core/services/app_auth/app_auth_service.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// AuthRepository — Handles all auth-related API and session management.
@LazySingleton()
class AuthRepository with ApiHandlerMixin {
  final AuthService _service;
  final AppAuthService _appAuthService;

  AuthRepository(this._service, this._appAuthService);

  /// 🔐 Login
  Future<Result<AuthResponse>> login(LoginRequest request) async {
    final result = await safeCallUnwrap(() => _service.login(request));
    if (result.isSuccess) {
      await _appAuthService.saveLoginData(result.dataOrNull!);
    }
    return result;
  }

  /// 📝 Register
  Future<Result<RegisterResponse>> register(RegisterRequest request) {
    return safeCallUnwrap(() => _service.register(request));
  }

  /// ✅ Verify OTP / Email
  Future<Result<SimpleResponse>> verifyEmail(VerifyOtpRequest request) {
    return safeCallUnwrap(() => _service.verifyEmail(request));
  }

  /// 📧 Forgot Password
  Future<Result<SimpleResponse>> forgotPassword(ForgotPasswordRequest request) {
    return safeCallUnwrap(() => _service.forgotPassword(request));
  }

  /// 🔑 Reset Password
  Future<Result<SimpleResponse>> resetPassword(ResetPasswordRequest request) {
    return safeCallUnwrap(() => _service.resetPassword(request));
  }

  /// 🔄 Refresh Token
  Future<Result<AuthResponse>> refresh(String refreshToken) async {
    final result = await safeCallUnwrap(() => _service.refresh({'refresh_token': refreshToken}));
    if (result.isSuccess) {
      await _appAuthService.saveLoginData(result.dataOrNull!);
    }
    return result;
  }

  /// 🚪 Logout
  Future<Result<SimpleResponse>> logout(String refreshToken) async {
    final result = await safeCallUnwrap(() => _service.logout({'refresh_token': refreshToken}));
    // Clear session always
    await _appAuthService.logout();
    return result;
  }

  /// 👤 Get Current User Profile (Me)
  Future<Result<UserModel>> getMe() {
    return safeCallUnwrap(() => _service.getMe());
  }
}
