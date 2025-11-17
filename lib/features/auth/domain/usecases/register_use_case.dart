import 'package:flutter_base_template/core/errors/result.dart';
import 'package:injectable/injectable.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Result<AuthResponse>> call({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  }) {
    return _repository.register(
      fullname: fullname,
      username: username,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }
}