// auth_user_model.dart
import 'package:flutter_base_template/features/auth/domain/entities/auth_entity.dart';

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

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
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
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }

  /// Chuyển AuthUserModel -> AuthUser (Entity)
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
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: AuthUserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  /// Chuyển AuthResponseModel -> AuthResponse (Entity)
  AuthResponse toEntity() {
    return AuthResponse(
      user: (user as AuthUserModel).toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as AuthUserModel).toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
