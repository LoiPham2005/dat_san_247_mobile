import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/auth_model.dart';

part 'auth_service.g.dart';

@RestApi()
@LazySingleton()
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST(ApiConstants.login)
  Future<AuthResponseModel> login(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.logout)
  Future<dynamic> logout();

  @POST(ApiConstants.register)
  Future<AuthResponseModel> register(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.forgotPassword)
  Future<dynamic> forgotPassword(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.resetPassword)
  Future<dynamic> resetPassword(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.profile)
  Future<UserModel> getProfile();

  @DELETE(ApiConstants.profile)
  Future<dynamic> deleteAccount();
}
