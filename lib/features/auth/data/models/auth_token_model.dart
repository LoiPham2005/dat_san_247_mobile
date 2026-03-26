import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token_model.freezed.dart';
part 'auth_token_model.g.dart';

@freezed
abstract class AuthTokenModel with _$AuthTokenModel {
  const factory AuthTokenModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'user_id') required String userId,
    required String token,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'is_revoked') required bool isRevoked,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
  }) = _AuthTokenModel;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => _$AuthTokenModelFromJson(json);
}
