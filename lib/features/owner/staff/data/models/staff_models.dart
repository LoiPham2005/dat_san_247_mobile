import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

// ── venue_staff (owner view) ──────────────────────────────────────────────────
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

class OwnerStaffModel {
  final String id;
  final String venueId;
  final String userId;
  final String fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final StaffRole role;
  final bool isActive;
  final String? invitedBy;
  final DateTime? joinedAt;
  final DateTime? deactivatedAt;
  final String? workStartTime;
  final String? workEndTime;
  final List<OwnerDayOfWeek> workDays;
  final String? note;
  final DateTime createdAt;

  const OwnerStaffModel({
    required this.id, required this.venueId, required this.userId,
    required this.fullName, this.email, this.phone, this.avatarUrl,
    required this.role, this.isActive = true, this.invitedBy,
    this.joinedAt, this.deactivatedAt, this.workStartTime, this.workEndTime,
    this.workDays = const [], this.note, required this.createdAt,
  });
}

class StaffInviteModel {
  final String id;
  final String venueId;
  final String inviteEmail;
  final StaffRole role;
  final StaffInviteStatus status;
  final String? message;
  final DateTime expiresAt;
  final DateTime createdAt;

  const StaffInviteModel({
    required this.id, required this.venueId, required this.inviteEmail,
    required this.role, required this.status, this.message,
    required this.expiresAt, required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
