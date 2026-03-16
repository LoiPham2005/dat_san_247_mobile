import 'package:json_annotation/json_annotation.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'user_id')
  final String userId;
  final String token;
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @JsonKey(name: 'is_revoked')
  final bool isRevoked;
  @JsonKey(name: 'ip_address')
  final String? ipAddress;
  @JsonKey(name: 'user_agent')
  final String? userAgent;

  AuthTokenModel({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.token,
    required this.expiresAt,
    required this.isRevoked,
    this.ipAddress,
    this.userAgent,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => _$AuthTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);
}

@JsonSerializable()
class AuthResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
