import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

part 'staff_models.freezed.dart';
part 'staff_models.g.dart';

// ── venue_staff (owner view) ──────────────────────────────────────────────────
enum StaffRole { OWNER, MANAGER, STAFF, RECEPTIONIST }

extension StaffRoleX on StaffRole {
  String get label => switch (this) {
        StaffRole.OWNER => 'Chủ sân',
        StaffRole.MANAGER => 'Quản lý',
        StaffRole.STAFF => 'Nhân viên',
        StaffRole.RECEPTIONIST => 'Lễ tân',
      };
  String get emoji => switch (this) {
        StaffRole.OWNER => '👑',
        StaffRole.MANAGER => '🎯',
        StaffRole.STAFF => '👷',
        StaffRole.RECEPTIONIST => '🙋',
      };
  int get level => switch (this) {
        StaffRole.OWNER => 4,
        StaffRole.MANAGER => 3,
        StaffRole.STAFF => 2,
        StaffRole.RECEPTIONIST => 1,
      };
}

enum StaffInviteStatus { PENDING, ACCEPTED, REJECTED, EXPIRED, REVOKED }

extension StaffInviteStatusX on StaffInviteStatus {
  String get label => switch (this) {
        StaffInviteStatus.PENDING => 'Chờ phản hồi',
        StaffInviteStatus.ACCEPTED => 'Đã chấp nhận',
        StaffInviteStatus.REJECTED => 'Đã từ chối',
        StaffInviteStatus.EXPIRED => 'Hết hạn',
        StaffInviteStatus.REVOKED => 'Đã thu hồi',
      };
}

@freezed
abstract class OwnerStaffModel with _$OwnerStaffModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerStaffModel({
    required String id,
    required String venueId,
    required String userId,
    required String fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    required StaffRole role,
    @Default(true) bool isActive,
    String? invitedBy,
    DateTime? joinedAt,
    DateTime? deactivatedAt,
    String? workStartTime,
    String? workEndTime,
    @Default([]) List<OwnerDayOfWeek> workDays,
    String? note,
    required DateTime createdAt,
  }) = _OwnerStaffModel;

  const OwnerStaffModel._();

  factory OwnerStaffModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerStaffModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class StaffInviteModel with _$StaffInviteModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffInviteModel({
    required String id,
    required String venueId,
    required String inviteEmail,
    required StaffRole role,
    required StaffInviteStatus status,
    String? message,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _StaffInviteModel;

  const StaffInviteModel._();

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory StaffInviteModel.fromJson(Map<String, dynamic> json) =>
      _$StaffInviteModelFromJson(json);

  Map<String, dynamic> toJson();
}
