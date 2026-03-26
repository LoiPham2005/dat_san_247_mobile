// ════════════════════════════════════════════════════════════════
// 📁 lib/features/auth/data/services/auth_service.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/common/constants/api_endpoints.dart';
import '../../../../core/data/network/api_response.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

part 'auth_service.g.dart';

@RestApi()
@LazySingleton()
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST(ApiEndpoints.login)
  Future<ApiResponse<AuthResponse>> login(@Body() LoginRequest request);

  @POST(ApiEndpoints.register)
  Future<ApiResponse<RegisterResponse>> register(@Body() RegisterRequest request);

  @POST(ApiEndpoints.verifyEmail)
  Future<ApiResponse<SimpleResponse>> verifyEmail(@Body() VerifyOtpRequest request);

  @POST(ApiEndpoints.forgotPassword)
  Future<ApiResponse<SimpleResponse>> forgotPassword(@Body() ForgotPasswordRequest request);

  @POST(ApiEndpoints.resetPassword)
  Future<ApiResponse<SimpleResponse>> resetPassword(@Body() ResetPasswordRequest request);

  @POST(ApiEndpoints.refreshToken)
  Future<ApiResponse<AuthResponse>> refresh(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.logout)
  Future<ApiResponse<SimpleResponse>> logout(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoints.me)
  Future<ApiResponse<UserModel>> getMe();
}
