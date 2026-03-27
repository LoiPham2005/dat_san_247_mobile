import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

part 'pricing_models.freezed.dart';
part 'pricing_models.g.dart';

// ── PricingRuleModel ───────────────────────────────────────────────────────
@freezed
abstract class PricingRuleModel with _$PricingRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PricingRuleModel({
    required String id,
    required String courtId,
    @Default('') String courtName,
    String? name,
    String? dayOfWeek,
    required String startTime,
    required String endTime,
    required double price,
    DateTime? startDate,
    DateTime? endDate,
    @Default(1) int priority,
    @Default(true) bool isActive,
    required DateTime updatedAt,
  }) = _PricingRuleModel;

  const PricingRuleModel._();

  String get dayLabel {
    const map = {
      'MONDAY': 'T2',
      'TUESDAY': 'T3',
      'WEDNESDAY': 'T4',
      'THURSDAY': 'T5',
      'FRIDAY': 'T6',
      'SATURDAY': 'T7',
      'SUNDAY': 'CN',
    };
    return dayOfWeek != null ? (map[dayOfWeek] ?? dayOfWeek!) : 'Tất cả ngày';
  }

  bool get isWeekend => dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY';
  bool get isPeakHour {
    final h = int.tryParse(startTime.split(':')[0]) ?? 0;
    return h >= 17 && h <= 21;
  }

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'] ?? '';
    }
    if (json['start_time'] != null) {
      mappedJson['start_time'] = _pt(json['start_time']);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = _pt(json['end_time']);
    }
    return _$PricingRuleModelFromJson(mappedJson);
  }

  static String _pt(dynamic t) {
    if (t == null) return '00:00';
    final s = t.toString();
    if (s.contains('T')) {
      final dt = DateTime.tryParse(s);
      if (dt != null)
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return s.length >= 5 ? s.substring(0, 5) : s;
  }

  Map<String, dynamic> toJson();
}

// ── Enums for Notifications ────────────────────────────────────────────────
enum StaffNotifChannel { IN_APP, EMAIL, PUSH, SMS }

enum StaffNotifReferenceType {
  BOOKING,
  PAYMENT,
  REVIEW,
  VENUE,
  SUPPORT_TICKET,
  COURT
}

enum StaffSystemNotifType {
  BOOKING_CONFIRMED,
  BOOKING_CANCELLED,
  BOOKING_REMINDER,
  PAYMENT_SUCCESS,
  NEW_REVIEW,
  MAINTENANCE_ALERT,
  SYSTEM_ANNOUNCEMENT,
  SHIFT_REMINDER,
}

extension StaffSystemNotifTypeExt on StaffSystemNotifType {
  String get label => switch (this) {
        StaffSystemNotifType.BOOKING_CONFIRMED => 'Booking xác nhận',
        StaffSystemNotifType.BOOKING_CANCELLED => 'Booking huỷ',
        StaffSystemNotifType.BOOKING_REMINDER => 'Nhắc booking',
        StaffSystemNotifType.PAYMENT_SUCCESS => 'Thanh toán',
        StaffSystemNotifType.NEW_REVIEW => 'Đánh giá mới',
        StaffSystemNotifType.MAINTENANCE_ALERT => 'Bảo trì',
        StaffSystemNotifType.SYSTEM_ANNOUNCEMENT => 'Hệ thống',
        StaffSystemNotifType.SHIFT_REMINDER => 'Nhắc ca làm',
      };
}

// ── StaffSystemNotificationModel ───────────────────────────────────────────
@freezed
abstract class StaffSystemNotificationModel with _$StaffSystemNotificationModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffSystemNotificationModel({
    required String id,
    required String userId,
    required StaffSystemNotifType type,
    required StaffNotifChannel channel,
    required String title,
    required String message,
    String? referenceId,
    StaffNotifReferenceType? referenceType,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _StaffSystemNotificationModel;

  const StaffSystemNotificationModel._();

  factory StaffSystemNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$StaffSystemNotificationModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── StaffProfileModel ──────────────────────────────────────────────────────
@freezed
abstract class StaffProfileModel with _$StaffProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffProfileModel({
    required String userId,
    required String fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    required String venueStaffId,
    required String venueId,
    required VenueStaffRole role,
    required bool isActive,
    DateTime? joinedAt,
    String? workStartTime,
    String? workEndTime,
    @Default([]) List<String> workDays,
    String? note,
    required String venueName,
    String? venueAddress,
    String? venuePhone,
    String? venueLogoUrl,
  }) = _StaffProfileModel;

  const StaffProfileModel._();

  String get workDaysLabel {
    const map = {
      'MONDAY': 'T2',
      'TUESDAY': 'T3',
      'WEDNESDAY': 'T4',
      'THURSDAY': 'T5',
      'FRIDAY': 'T6',
      'SATURDAY': 'T7',
      'SUNDAY': 'CN'
    };
    return workDays.map((d) => map[d] ?? d).join(' · ');
  }

  String get shiftLabel => (workStartTime != null && workEndTime != null)
      ? '$workStartTime – $workEndTime'
      : 'Chưa cài ca';

  factory StaffProfileModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['users'] != null && json['users'] is Map) {
      mappedJson['user_id'] = json['users']['id'];
      mappedJson['full_name'] = json['users']['full_name'];
      mappedJson['email'] = json['users']['email'];
      mappedJson['phone'] = json['users']['phone'];
      mappedJson['avatar_url'] = json['users']['avatar_url'];
    }
    mappedJson['venue_staff_id'] = json['id'];
    if (json['work_start_time'] != null) {
      mappedJson['work_start_time'] =
          json['work_start_time'].toString().substring(0, 5);
    }
    if (json['work_end_time'] != null) {
      mappedJson['work_end_time'] =
          json['work_end_time'].toString().substring(0, 5);
    }
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'];
      mappedJson['venue_address'] = json['venues']['address'];
      mappedJson['venue_phone'] = json['venues']['phone_number'];
      mappedJson['venue_logo_url'] = json['venues']['logo_url'];
    }
    return _$StaffProfileModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}
