import 'package:injectable/injectable.dart';
import '../../../../../core/base/errors/failures.dart';
import '../../../../../core/base/errors/result.dart';
import '../models/profile_models.dart';
import '../services/profile_service.dart';

@injectable
class ProfileRepository {
  final ProfileService _service;

  ProfileRepository(this._service);

  Future<Result<UserModel>> getProfile() async {
    try {
      final response = await _service.getProfile();
      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ServerFailure(message: response.message ?? 'Lỗi tải thông tin cá nhân'));
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  Future<Result<UserModel>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _service.updateProfile(data);
      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ServerFailure(message: response.message ?? 'Lỗi cập nhật thông tin cá nhân'));
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  Future<Result<SportPreferenceModel>> updateSportPreference(Map<String, dynamic> data) async {
    try {
      final response = await _service.updateSportPreference(data);
      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(ServerFailure(message: response.message ?? 'Lỗi cập nhật sở thích thể thao'));
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }
}
