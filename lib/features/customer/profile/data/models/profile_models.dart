// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_models.freezed.dart';
part 'profile_models.g.dart';

@JsonEnum()
enum Gender {
  @JsonValue('MALE')
  MALE,
  @JsonValue('FEMALE')
  FEMALE,
  @JsonValue('OTHER')
  OTHER;

  String get label => this == MALE ? 'Nam' : this == FEMALE ? 'Nữ' : 'Khác';
}

@JsonEnum()
enum KycStatus {
  @JsonValue('UNVERIFIED')
  UNVERIFIED,
  @JsonValue('PENDING')
  PENDING,
  @JsonValue('VERIFIED')
  VERIFIED,
  @JsonValue('REJECTED')
  REJECTED;

  String get label {
    switch (this) {
      case UNVERIFIED: return 'Chưa xác minh';
      case PENDING: return 'Đang xem xét';
      case VERIFIED: return 'Đã xác minh';
      case REJECTED: return 'Bị từ chối';
    }
  }
}

@freezed
abstract class SportPreferenceModel with _$SportPreferenceModel {
  const factory SportPreferenceModel({
    required String id,
    @JsonKey(name: 'user_profile_id') required String userProfileId,
    @JsonKey(name: 'sport_type') required String sportType,
    @JsonKey(name: 'skill_level') @Default(1) int skillLevel,
  }) = _SportPreferenceModel;

  factory SportPreferenceModel.fromJson(Map<String, dynamic> json) => _$SportPreferenceModelFromJson(json);
}

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
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
    @JsonKey(name: 'sport_preferences') @Default([]) List<SportPreferenceModel> sportPreferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    Gender? gender,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    @JsonKey(name: 'kyc_status') @Default(KycStatus.UNVERIFIED) KycStatus kycStatus,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'is_phone_verified') @Default(false) bool isPhoneVerified,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    UserProfileModel? profile,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
