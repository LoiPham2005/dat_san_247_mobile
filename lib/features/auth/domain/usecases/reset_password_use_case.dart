import 'package:flutter_base_template/core/errors/result.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  /// Reset password bằng token + password mới
  Future<Result<bool>> call({
    required String token,
    required String password,
    required String passwordConfirm,
  }) {
    return _repository.resetPassword(
      token: token,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }
}