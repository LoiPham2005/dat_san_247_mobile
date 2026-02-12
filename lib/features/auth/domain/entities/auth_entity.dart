import 'package:equatable/equatable.dart';

/// AuthUser Entity - Domain layer (không phụ thuộc framework)
class AuthUser extends Equatable {
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

  const AuthUser({
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
  
  // ═══════════════════════════════════════════════════════════════
  // CopyWith
  // ═══════════════════════════════════════════════════════════════

  AuthUser copyWith({
    int? id,
    String? fullname,
    String? username,
    String? email,
    String? phone,
    String? gender,
    DateTime? birthDate,
    String? avatar,
    int? roleId,
    bool? isVerified,
    String? address,
    double? latitude,
    double? longitude,
    bool? isActive,
    String? specialStatus,
    bool? emailVerified,
    bool? phoneVerified,
    String? provider,
    String? providerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
      roleId: roleId ?? this.roleId,
      isVerified: isVerified ?? this.isVerified,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      specialStatus: specialStatus ?? this.specialStatus,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      provider: provider ?? this.provider,
      providerId: providerId ?? this.providerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

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

  @override
  String toString() => 'AuthUser(id: $id, email: $email, fullname: $fullname)';
}

/// AuthResponse Entity
class AuthResponse extends Equatable {
  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt; // ✅ THÊM: Token expiry time

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  /// Check if token is expired
  bool get isTokenExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if token will expire soon (within 5 minutes)
  bool get isTokenExpiringSoon {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!.subtract(const Duration(minutes: 5)));
  }

  AuthResponse copyWith({
    AuthUser? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthResponse(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];

  @override
  String toString() => 'AuthResponse(user: ${user.email}, hasToken: ${accessToken.isNotEmpty})';
}
