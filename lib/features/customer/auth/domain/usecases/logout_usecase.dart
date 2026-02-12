import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<bool>> call() {
    return _repository.logout();
  }
}
