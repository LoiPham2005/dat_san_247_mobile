import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:dat_san_247_mobile/features/auth/data/services/auth_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AuthRepository with ApiHandlerMixin {
  final AuthService _service;

  AuthRepository(this._service);

  Future<Result<AuthResponseModel>> login({required String email, required String password}) async {
    return safeCall(() => _service.login({'email': email, 'password': password}));
  }

  Future<Result<bool>> logout() {
    return safeCallBool(() => _service.logout());
  }

  Future<Result<AuthResponseModel>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    return safeCall(
      () => _service.register({
        'full_name': fullName,
        'username': username,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      }),
    );
  }

  Future<Result<bool>> forgotPassword({required String email}) {
    return safeCallBool(() => _service.forgotPassword({'email': email}));
  }

  Future<Result<bool>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) {
    return safeCallBool(
      () => _service.resetPassword({
        'token': token,
        'password': password,
        'passwordConfirm': passwordConfirm,
      }),
    );
  }

  Future<Result<bool>> checkLoginStatus() {
    return safeCallBool(() => _service.getProfile());
  }

  Future<Result<UserModel>> getProfile() async {
    return safeCall(() => _service.getProfile());
  }

  Future<Result<bool>> deleteAccount() {
    return safeCallBool(() => _service.deleteAccount());
  }
}
