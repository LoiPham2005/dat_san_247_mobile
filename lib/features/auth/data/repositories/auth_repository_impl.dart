import 'package:flutter_base_template/core/errors/result.dart';
import 'package:flutter_base_template/features/auth/data/datasources/auth_remote_datasourse.dart';
import 'package:flutter_base_template/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_base_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Result<bool>> logout() {
    return _remoteDataSource.logout();
  }

  @override
  Future<Result<AuthResponse>> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final result = await _remoteDataSource.register(
      fullname: fullname,
      username: username,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Result<bool>> forgotPassword({required String email}) {
    return _remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<Result<bool>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) {
    return _remoteDataSource.resetPassword(
      token: token,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }

  @override
  Future<Result<bool>> checkLoginStatus() {
    return _remoteDataSource.checkLoginStatus();
  }

  @override
  Future<Result<AuthUser>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Result<bool>> deleteAccount() {
    return _remoteDataSource.deleteAccount();
  }
}
