import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String? phone;
  final String? gender;
  final DateTime? birthDate;
  final String? avatar;
  final int roleId;
  final bool isVerified;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final String? specialStatus;
  final bool emailVerified;
  final bool phoneVerified;
  final String? provider;
  final String? providerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const User({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.avatar,
    required this.roleId,
    required this.isVerified,
    this.address,
    this.latitude,
    this.longitude,
    required this.isActive,
    this.specialStatus,
    required this.emailVerified,
    required this.phoneVerified,
    this.provider,
    this.providerId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
    id,
    fullname,
    username,
    email,
    phone,
    gender,
    birthDate,
    avatar,
    roleId,
    isVerified,
    address,
    latitude,
    longitude,
    isActive,
    specialStatus,
    emailVerified,
    phoneVerified,
    provider,
    providerId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
}

class AuthResponse extends Equatable {
  final User user;
  final String accessToken;
  final String refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
