import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required UserMinimal user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}

@freezed
abstract class UserMinimal with _$UserMinimal {
  const factory UserMinimal({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_venue_staff') required bool isVenueStaff,
    RoleModel? role,
  }) = _UserMinimal;

  factory UserMinimal.fromJson(Map<String, dynamic> json) => _$UserMinimalFromJson(json);
}

@freezed
abstract class RoleModel with _$RoleModel {
  const factory RoleModel({
    required String id,
    required String name,
    required String slug,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
}

@freezed
abstract class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String message,
    required String userId,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);
}

@freezed
abstract class SimpleResponse with _$SimpleResponse {
  const factory SimpleResponse({
    required String message,
  }) = _SimpleResponse;

  factory SimpleResponse.fromJson(Map<String, dynamic> json) => _$SimpleResponseFromJson(json);
}
