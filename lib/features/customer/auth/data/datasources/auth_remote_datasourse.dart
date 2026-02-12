import 'package:dat_san_247_mobile/core/constants/api_constants.dart';
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/network/api_client.dart';
import 'package:injectable/injectable.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  });

  Future<Result<bool>> logout();

  Future<Result<AuthResponseModel>> register({
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

  Future<Result<bool>> checkLoginStatus();

  Future<Result<UserModel>> getProfile();

  Future<Result<bool>> deleteAccount();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<Result<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    return _apiClient.post(
      ApiConstants.login,
      (json) => AuthResponseModel.fromJson(json),
      data: {'email': email, 'password': password},
    );
  }

  @override
  Future<Result<bool>> logout() async {
    return _apiClient.post(ApiConstants.logout, (json) => true);
  }

  @override
  Future<Result<AuthResponseModel>> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    return _apiClient.post(
      ApiConstants.register,
      (json) => AuthResponseModel.fromJson(json),
      data: {
        'fullname': fullname,
        'username': username,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
    );
  }

  @override
  Future<Result<bool>> forgotPassword({required String email}) async {
    return _apiClient.post(
      ApiConstants.forgotPassword,
      (json) => true,
      data: {'email': email},
    );
  }

  @override
  Future<Result<bool>> resetPassword({
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    return _apiClient.post(
      ApiConstants.resetPassword,
      (json) => true,
      data: {
        'token': token,
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
    );
  }

  @override
  Future<Result<bool>> checkLoginStatus() async {
    return _apiClient.get(ApiConstants.profile, (json) => true);
  }

  @override
  Future<Result<UserModel>> getProfile() async {
    return _apiClient.get(
      ApiConstants.profile,
      (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<Result<bool>> deleteAccount() async {
    return _apiClient.delete(ApiConstants.profile);
  }
}
