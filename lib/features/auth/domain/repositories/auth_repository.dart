import 'package:flutter_base_template/core/errors/result.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  // ✅ Existing
  Future<Result<AuthResponse>> login({
    required String email,
    required String password,
  });

  Future<Result<bool>> logout();

  // ✅ NEW
  Future<Result<AuthResponse>> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  });

  Future<Result<bool>> forgotPassword({required String email});

  Future<Result<bool>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  });

  /// Check if user is currently logged in
  Future<Result<bool>> checkLoginStatus();

  /// Get current user profile
  Future<Result<AuthUser>> getProfile();

  Future<Result<bool>> deleteAccount();
}
