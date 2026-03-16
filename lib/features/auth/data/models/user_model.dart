import 'package:json_annotation/json_annotation.dart';
import 'auth_enums.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final Gender? gender;
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;

  final UserStatus status;
  @JsonKey(name: 'kyc_status')
  final KycStatus kycStatus;
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final bool isPhoneVerified;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'phone_verified_at')
  final DateTime? phoneVerifiedAt;
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;

  @JsonKey(name: 'role_id')
  final String? roleId;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.email,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    required this.status,
    required this.kycStatus,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.lastLoginAt,
    this.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserProfileModel {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'user_id')
  final String userId;
  final String? bio;
  final String? address;
  final String? city;
  final String? district;
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  @JsonKey(name: 'referred_by_id')
  final String? referredById;
  @JsonKey(name: 'is_profile_public')
  final bool isProfilePublic;

  // Notification preferences
  @JsonKey(name: 'notif_push')
  final bool notifPush;
  @JsonKey(name: 'notif_email')
  final bool notifEmail;
  @JsonKey(name: 'notif_sms')
  final bool notifSms;
  @JsonKey(name: 'notif_booking')
  final bool notifBooking;
  @JsonKey(name: 'notif_promotion')
  final bool notifPromotion;
  @JsonKey(name: 'notif_payment')
  final bool notifPayment;
  @JsonKey(name: 'notif_system')
  final bool notifSystem;
  @JsonKey(name: 'notif_staff')
  final bool notifStaff;

  UserProfileModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.bio,
    this.address,
    this.city,
    this.district,
    this.referralCode,
    this.referredById,
    required this.isProfilePublic,
    required this.notifPush,
    required this.notifEmail,
    required this.notifSms,
    required this.notifBooking,
    required this.notifPromotion,
    required this.notifPayment,
    required this.notifSystem,
    required this.notifStaff,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}

@JsonSerializable()
class UserDeviceModel {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'fcm_token')
  final String fcmToken;
  @JsonKey(name: 'device_type')
  final AppPlatform? deviceType;
  @JsonKey(name: 'app_version')
  final String? appVersion;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'last_active_at')
  final DateTime lastActiveAt;

  UserDeviceModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.fcmToken,
    this.deviceType,
    this.appVersion,
    required this.isActive,
    required this.lastActiveAt,
  });

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) => _$UserDeviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDeviceModelToJson(this);
}
