// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

part 'staff_models.freezed.dart';
part 'staff_models.g.dart';

// ── venue_staff (owner view) ──────────────────────────────────────────────────
@JsonEnum(alwaysCreate: true)
enum StaffRole { OWNER, MANAGER, STAFF, RECEPTIONIST }

extension StaffRoleX on StaffRole {
  String get label => switch (this) {
    StaffRole.OWNER        => 'Chủ sân',
    StaffRole.MANAGER      => 'Quản lý',
    StaffRole.STAFF        => 'Nhân viên',
    StaffRole.RECEPTIONIST => 'Lễ tân',
  };
  String get emoji => switch (this) {
    StaffRole.OWNER        => '👑',
    StaffRole.MANAGER      => '🎯',
    StaffRole.STAFF        => '👷',
    StaffRole.RECEPTIONIST => '🙋',
  };
  int get level => switch (this) {
    StaffRole.OWNER => 4, StaffRole.MANAGER => 3,
    StaffRole.STAFF => 2, StaffRole.RECEPTIONIST => 1,
  };
}

@JsonEnum(alwaysCreate: true)
enum StaffInviteStatus { PENDING, ACCEPTED, REJECTED, EXPIRED, REVOKED }

extension StaffInviteStatusX on StaffInviteStatus {
  String get label => switch (this) {
    StaffInviteStatus.PENDING  => 'Chờ phản hồi',
    StaffInviteStatus.ACCEPTED => 'Đã chấp nhận',
    StaffInviteStatus.REJECTED => 'Đã từ chối',
    StaffInviteStatus.EXPIRED  => 'Hết hạn',
    StaffInviteStatus.REVOKED  => 'Đã thu hồi',
  };
}

@freezed
abstract class OwnerStaffModel with _$OwnerStaffModel {
  const factory OwnerStaffModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    String? email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required StaffRole role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'invited_by') String? invitedBy,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(name: 'deactivated_at') DateTime? deactivatedAt,
    @JsonKey(name: 'work_start_time') String? workStartTime,
    @JsonKey(name: 'work_end_time') String? workEndTime,
    @JsonKey(name: 'work_days') @Default([]) List<OwnerDayOfWeek> workDays,
    String? note,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OwnerStaffModel;

  factory OwnerStaffModel.fromJson(Map<String, dynamic> json) => _$OwnerStaffModelFromJson(json);
}

@freezed
abstract class StaffInviteModel with _$StaffInviteModel {
  const StaffInviteModel._();
  
  const factory StaffInviteModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'invite_email') required String inviteEmail,
    required StaffRole role,
    required StaffInviteStatus status,
    String? message,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _StaffInviteModel;

  factory StaffInviteModel.fromJson(Map<String, dynamic> json) => _$StaffInviteModelFromJson(json);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
