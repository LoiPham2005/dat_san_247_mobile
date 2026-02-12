import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  /// Gửi OTP/email reset password
  Future<Result<bool>> call(String email) {
    return _repository.forgotPassword(email: email);
  }
}
