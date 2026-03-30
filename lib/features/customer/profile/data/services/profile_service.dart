import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../core/data/network/api_response.dart';
import '../models/profile_models.dart';

part 'profile_service.g.dart';

@RestApi()
abstract class ProfileService {
  factory ProfileService(Dio dio) = _ProfileService;

  @GET('/users/me')
  Future<ApiResponse<UserModel>> getProfile();

  @PATCH('/users/me/profile')
  Future<ApiResponse<UserModel>> updateProfile(@Body() Map<String, dynamic> body);

  @POST('/users/me/sport-preferences')
  Future<ApiResponse<SportPreferenceModel>> updateSportPreference(@Body() Map<String, dynamic> body);
}
