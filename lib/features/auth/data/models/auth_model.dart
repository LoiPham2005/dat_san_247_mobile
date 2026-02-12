// auth_user_model.dart
import 'package:dat_san_247_mobile/features/auth/domain/entities/auth_entity.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.fullname,
    required super.username,
    required super.email,
    super.phone,
    super.gender,
    super.birthDate,
    super.avatar,
    required super.roleId,
    required super.isVerified,
    super.address,
    super.latitude,
    super.longitude,
    required super.isActive,
    super.specialStatus,
    required super.emailVerified,
    required super.phoneVerified,
    super.provider,
    super.providerId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  /// ✅ From JSON
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      avatar: json['avatar'],
      roleId: json['roleId'],
      isVerified: json['isVerified'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isActive: json['isActive'],
      specialStatus: json['specialStatus'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      provider: json['provider'],
      providerId: json['providerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  /// ✅ NEW: From Entity (Domain layer to Data layer)
  factory AuthUserModel.fromEntity(AuthUser entity) {
    return AuthUserModel(
      id: entity.id,
      fullname: entity.fullname,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      gender: entity.gender,
      birthDate: entity.birthDate,
      avatar: entity.avatar,
      roleId: entity.roleId,
      isVerified: entity.isVerified,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      isActive: entity.isActive,
      specialStatus: entity.specialStatus,
      emailVerified: entity.emailVerified,
      phoneVerified: entity.phoneVerified,
      provider: entity.provider,
      providerId: entity.providerId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  /// To Entity (Data layer to Domain layer)
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      fullname: fullname,
      username: username,
      email: email,
      phone: phone,
      gender: gender,
      birthDate: birthDate,
      avatar: avatar,
      roleId: roleId,
      isVerified: isVerified,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isActive: isActive,
      specialStatus: specialStatus,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      provider: provider,
      providerId: providerId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'avatar': avatar,
      'roleId': roleId,
      'isVerified': isVerified,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
      'specialStatus': specialStatus,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'provider': provider,
      'providerId': providerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
    super.expiresAt,
  });

  /// ✅ From JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: AuthUserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }

  /// ✅ NEW: From Entity
  factory AuthResponseModel.fromEntity(AuthResponse entity) {
    return AuthResponseModel(
      user: AuthUserModel.fromEntity(entity.user),
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
    );
  }

  /// To Entity
  AuthResponse toEntity() {
    return AuthResponse(
      user: (user as AuthUserModel).toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'user': (user as AuthUserModel).toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}
