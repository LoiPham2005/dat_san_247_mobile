import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:injectable/injectable.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetProfileUseCase {
  final AuthRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Result<AuthUser>> call() {
    return _repository.getProfile();
  }
}
