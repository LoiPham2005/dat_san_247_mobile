import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_enums.dart';
import 'auth_response.dart'; // For RoleModel if needed

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    Gender? gender,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    required UserStatus status,
    @JsonKey(name: 'kyc_status') required KycStatus kycStatus,
    @JsonKey(name: 'is_email_verified') required bool isEmailVerified,
    @JsonKey(name: 'is_phone_verified') required bool isPhoneVerified,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    @JsonKey(name: 'phone_verified_at') DateTime? phoneVerifiedAt,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'role_id') String? roleId,
    RoleModel? role,
    UserProfileModel? profile,
    @JsonKey(name: 'is_venue_staff') @Default(false) bool isVenueStaff,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'user_id') required String userId,
    String? bio,
    String? address,
    String? city,
    String? district,
    @JsonKey(name: 'referral_code') String? referralCode,
    @JsonKey(name: 'referred_by_id') String? referredById,
    @JsonKey(name: 'is_profile_public') @Default(true) bool isProfilePublic,
    @JsonKey(name: 'notif_push') @Default(true) bool notifPush,
    @JsonKey(name: 'notif_email') @Default(true) bool notifEmail,
    @JsonKey(name: 'notif_sms') @Default(false) bool notifSms,
    @JsonKey(name: 'notif_booking') @Default(true) bool notifBooking,
    @JsonKey(name: 'notif_promotion') @Default(true) bool notifPromotion,
    @JsonKey(name: 'notif_payment') @Default(true) bool notifPayment,
    @JsonKey(name: 'notif_system') @Default(true) bool notifSystem,
    @JsonKey(name: 'notif_staff') @Default(true) bool notifStaff,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
}

@freezed
abstract class UserDeviceModel with _$UserDeviceModel {
  const factory UserDeviceModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'fcm_token') required String fcmToken,
    @JsonKey(name: 'device_type') AppPlatform? deviceType,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'last_active_at') required DateTime lastActiveAt,
  }) = _UserDeviceModel;

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) => _$UserDeviceModelFromJson(json);
}
