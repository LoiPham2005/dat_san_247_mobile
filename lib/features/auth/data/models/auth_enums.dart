import 'package:json_annotation/json_annotation.dart';
part 'auth_enums.g.dart';

@JsonEnum(alwaysCreate: true)
enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
  @JsonValue('OTHER')
  other,
}

@JsonEnum(alwaysCreate: true)
enum KycStatus {
  @JsonValue('UNVERIFIED')
  unverified,
  @JsonValue('PENDING')
  pending,
  @JsonValue('VERIFIED')
  verified,
  @JsonValue('REJECTED')
  rejected,
}

@JsonEnum(alwaysCreate: true)
enum UserStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('INACTIVE')
  inactive,
  @JsonValue('BANNED')
  banned,
  @JsonValue('SUSPENDED')
  suspended,
}

@JsonEnum(alwaysCreate: true)
enum OtpType {
  @JsonValue('EMAIL_VERIFY')
  emailVerify,
  @JsonValue('PHONE_VERIFY')
  phoneVerify,
  @JsonValue('RESET_PASSWORD')
  resetPassword,
  @JsonValue('TWO_FACTOR')
  twoFactor,
}

@JsonEnum(alwaysCreate: true)
enum AppPlatform {
  @JsonValue('IOS')
  ios,
  @JsonValue('ANDROID')
  android,
  @JsonValue('WEB')
  web,
}
