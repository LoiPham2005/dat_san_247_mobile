import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class PermissionModel extends Equatable {
  final String id;
  final String slug;
  final String resource;
  final String action;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const PermissionModel({
    required this.id,
    required this.slug,
    required this.resource,
    required this.action,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) => _$PermissionModelFromJson(json);
  Map<String, dynamic> toJson() => _$PermissionModelToJson(this);

  @override
  List<Object?> get props => [id, slug, resource, action, description, createdAt, updatedAt];
}

@JsonSerializable()
class RoleModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  @JsonKey(name: 'is_system', defaultValue: false)
  final bool isSystem;
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;
  @JsonKey(name: 'role_permissions')
  final List<PermissionModel>? permissions;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const RoleModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.isSystem = false,
    this.isActive = true,
    this.permissions,
    this.createdAt,
    this.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    isSystem,
    isActive,
    permissions,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class UserProfileModel extends Equatable {
  final String id;
  final String? bio;
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @JsonKey(name: 'is_verified', defaultValue: false)
  final bool isVerified;
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  @JsonKey(name: 'referred_by')
  final String? referredBy;
  @JsonKey(name: 'rank_score', defaultValue: 1000)
  final int rankScore;
  @JsonKey(name: 'skill_score', defaultValue: 1)
  final int skillScore;
  @JsonKey(defaultValue: 1)
  final int level;
  @JsonKey(name: 'experience_points', defaultValue: 0)
  final int experiencePoints;
  @JsonKey(name: 'reliability_score', defaultValue: 100)
  final int reliabilityScore;
  @JsonKey(name: 'total_matches', defaultValue: 0)
  final int totalMatches;
  @JsonKey(name: 'total_wins', defaultValue: 0)
  final int totalWins;
  @JsonKey(name: 'total_bookings', defaultValue: 0)
  final int totalBookings;
  @JsonKey(name: 'total_teams', defaultValue: 0)
  final int totalTeams;
  @JsonKey(name: 'total_friends', defaultValue: 0)
  final int totalFriends;
  @JsonKey(name: 'total_followers', defaultValue: 0)
  final int totalFollowers;
  @JsonKey(name: 'total_following', defaultValue: 0)
  final int totalFollowing;
  @JsonKey(name: 'total_posts', defaultValue: 0)
  final int totalPosts;
  @JsonKey(name: 'is_profile_public', defaultValue: true)
  final bool isProfilePublic;
  @JsonKey(name: 'show_email', defaultValue: false)
  final bool showEmail;
  @JsonKey(name: 'show_phone', defaultValue: false)
  final bool showPhone;
  @JsonKey(name: 'preferred_language', defaultValue: 'vi')
  final String preferredLanguage;
  @JsonKey(defaultValue: 'Asia/Ho_Chi_Minh')
  final String timezone;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.id,
    this.bio,
    this.coverUrl,
    this.isVerified = false,
    this.referralCode,
    this.referredBy,
    this.rankScore = 1000,
    this.skillScore = 1,
    this.level = 1,
    this.experiencePoints = 0,
    this.reliabilityScore = 100,
    this.totalMatches = 0,
    this.totalWins = 0,
    this.totalBookings = 0,
    this.totalTeams = 0,
    this.totalFriends = 0,
    this.totalFollowers = 0,
    this.totalFollowing = 0,
    this.totalPosts = 0,
    this.isProfilePublic = true,
    this.showEmail = false,
    this.showPhone = false,
    this.preferredLanguage = 'vi',
    this.timezone = 'Asia/Ho_Chi_Minh',
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    bio,
    coverUrl,
    isVerified,
    referralCode,
    referredBy,
    rankScore,
    skillScore,
    level,
    experiencePoints,
    reliabilityScore,
    totalMatches,
    totalWins,
    totalBookings,
    totalTeams,
    totalFriends,
    totalFollowers,
    totalFollowing,
    totalPosts,
    isProfilePublic,
    showEmail,
    showPhone,
    preferredLanguage,
    timezone,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? username;
  @JsonKey(name: 'kyc_status', defaultValue: 'UNVERIFIED')
  final String kycStatus;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? gender;
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  final String? address;
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;
  @JsonKey(name: 'is_verified', defaultValue: false)
  final bool isVerified;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'phone_verified_at')
  final DateTime? phoneVerifiedAt;
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  @JsonKey(name: 'role_id')
  final String? roleId;
  final RoleModel? role;
  @JsonKey(name: 'user_profiles')
  final UserProfileModel? profile;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.username,
    this.kycStatus = 'UNVERIFIED',
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.isActive = true,
    this.isVerified = false,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.lastLoginAt,
    this.roleId,
    this.role,
    this.profile,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    kycStatus,
    fullName,
    phone,
    avatarUrl,
    gender,
    dateOfBirth,
    address,
    isActive,
    isVerified,
    emailVerifiedAt,
    phoneVerifiedAt,
    lastLoginAt,
    roleId,
    role,
    profile,
    createdAt,
    updatedAt,
  ];

  // /// 🔄 Mapping to Entity (Domain)
  // AuthUser toEntity() {
  //   return AuthUser(
  //     id: id,
  //     fullName: fullName,
  //     username: username,
  //     email: email,
  //     phone: phone,
  //     gender: gender,
  //     birthDate: dateOfBirth,
  //     avatarUrl: avatarUrl,
  //     roleId: roleId,
  //     isVerified: isVerified,
  //     address: address,
  //     isActive: isActive,
  //     emailVerified: emailVerifiedAt != null,
  //     phoneVerified: phoneVerifiedAt != null,
  //     createdAt: createdAt ?? DateTime.now(),
  //     updatedAt: updatedAt ?? DateTime.now(),
  //     deletedAt: null,
  //   );
  // }
}

@JsonSerializable()
class AuthResponseModel extends Equatable {
  final UserModel user;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];

  // AuthResponse toEntity() => AuthResponse(
  //   user: user.toEntity(),
  //   accessToken: accessToken,
  //   refreshToken: refreshToken,
  //   expiresAt: expiresAt,
  // );
}
