// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:equatable/equatable.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';


// ══════════════════════════════════════════════════════════════════════════════
// pricing_rules model — DB: pricing_rules
// { id, court_id, name, day_of_week, start_time, end_time, price,
//   start_date, end_date, priority, is_active }
// ══════════════════════════════════════════════════════════════════════════════
class PricingRuleModel extends Equatable {
  final String id;
  final String courtId;             // pricing_rules.court_id → courts.id
  final String courtName;           // joined courts.name
  final String? name;               // @db.VarChar(100) — tên quy tắc
  final String? dayOfWeek;          // DayOfWeek? — null = áp dụng tất cả ngày
  final String startTime;           // @db.Time(6) → HH:mm
  final String endTime;             // @db.Time(6) → HH:mm
  final double price;               // @db.Decimal(10,2)
  final DateTime? startDate;        // @db.Date — null = không giới hạn
  final DateTime? endDate;          // @db.Date
  final int priority;               // @default(1) — số nhỏ = ưu tiên cao hơn
  final bool isActive;              // @default(true)
  final DateTime updatedAt;

  const PricingRuleModel({
    required this.id,
    required this.courtId,
    required this.courtName,
    this.name,
    this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.price,
    this.startDate,
    this.endDate,
    this.priority = 1,
    this.isActive = true,
    required this.updatedAt,
  });

  String get dayLabel {
    const map = {
      'MONDAY': 'T2', 'TUESDAY': 'T3', 'WEDNESDAY': 'T4',
      'THURSDAY': 'T5', 'FRIDAY': 'T6', 'SATURDAY': 'T7', 'SUNDAY': 'CN',
    };
    return dayOfWeek != null ? (map[dayOfWeek] ?? dayOfWeek!) : 'Tất cả ngày';
  }

  bool get isWeekend => dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY';
  bool get isPeakHour {
    final h = int.tryParse(startTime.split(':')[0]) ?? 0;
    return h >= 17 && h <= 21; // 17:00–21:59 = peak
  }

  factory PricingRuleModel.fromJson(Map<String, dynamic> j) => PricingRuleModel(
    id: j['id'],
    courtId: j['court_id'],
    courtName: j['courts']?['name'] ?? '',
    name: j['name'],
    dayOfWeek: j['day_of_week'],
    startTime: _pt(j['start_time']),
    endTime: _pt(j['end_time']),
    price: (j['price'] as num).toDouble(),
    startDate: j['start_date'] != null ? DateTime.tryParse(j['start_date']) : null,
    endDate: j['end_date'] != null ? DateTime.tryParse(j['end_date']) : null,
    priority: j['priority'] ?? 1,
    isActive: j['is_active'] ?? true,
    updatedAt: DateTime.parse(j['updated_at']),
  );

  Map<String, dynamic> toUpdateJson() => {
    'name': name,
    'day_of_week': dayOfWeek,
    'start_time': startTime,
    'end_time': endTime,
    'price': price,
    'priority': priority,
    'is_active': isActive,
  };

  PricingRuleModel copyWith({String? name, double? price, bool? isActive, int? priority}) =>
      PricingRuleModel(
        id: id, courtId: courtId, courtName: courtName,
        name: name ?? this.name, dayOfWeek: dayOfWeek,
        startTime: startTime, endTime: endTime,
        price: price ?? this.price,
        startDate: startDate, endDate: endDate,
        priority: priority ?? this.priority,
        isActive: isActive ?? this.isActive,
        updatedAt: DateTime.now(),
      );

  static String _pt(dynamic t) {
    if (t == null) return '00:00';
    final s = t.toString();
    if (s.contains('T')) {
      final dt = DateTime.tryParse(s);
      if (dt != null) return '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    }
    return s.length >= 5 ? s.substring(0, 5) : s;
  }

  @override
  List<Object?> get props => [id, courtId, dayOfWeek, startTime, endTime];
}

// ══════════════════════════════════════════════════════════════════════════════
// Staff Notification model — VS-11
// DB: notifications { id, user_id, type, channel, title, message,
//     reference_id, reference_type, is_read, read_at }
// ══════════════════════════════════════════════════════════════════════════════
enum StaffNotifChannel { IN_APP, EMAIL, PUSH, SMS }
enum StaffNotifReferenceType { BOOKING, PAYMENT, REVIEW, VENUE, SUPPORT_TICKET, COURT }

// NotificationType subset relevant to staff
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
    StaffSystemNotifType.BOOKING_CONFIRMED  => 'Booking xác nhận',
    StaffSystemNotifType.BOOKING_CANCELLED  => 'Booking huỷ',
    StaffSystemNotifType.BOOKING_REMINDER   => 'Nhắc booking',
    StaffSystemNotifType.PAYMENT_SUCCESS    => 'Thanh toán',
    StaffSystemNotifType.NEW_REVIEW         => 'Đánh giá mới',
    StaffSystemNotifType.MAINTENANCE_ALERT  => 'Bảo trì',
    StaffSystemNotifType.SYSTEM_ANNOUNCEMENT=> 'Hệ thống',
    StaffSystemNotifType.SHIFT_REMINDER     => 'Nhắc ca làm',
  };
}

class StaffSystemNotificationModel extends Equatable {
  final String id;                          // notifications.id
  final String userId;                      // notifications.user_id
  final StaffSystemNotifType type;          // notifications.type
  final StaffNotifChannel channel;          // notifications.channel
  final String title;                       // @db.VarChar(255)
  final String message;                     // @db.Text
  final String? referenceId;                // @db.Uuid — FK mềm
  final StaffNotifReferenceType? referenceType; // notifications.reference_type
  final bool isRead;                        // @default(false)
  final DateTime? readAt;                   // notifications.read_at
  final DateTime createdAt;

  const StaffSystemNotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.channel,
    required this.title,
    required this.message,
    this.referenceId,
    this.referenceType,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
  });

  factory StaffSystemNotificationModel.fromJson(Map<String, dynamic> j) =>
      StaffSystemNotificationModel(
        id: j['id'],
        userId: j['user_id'],
        type: StaffSystemNotifType.values.firstWhere(
            (e) => e.name == j['type'], orElse: () => StaffSystemNotifType.SYSTEM_ANNOUNCEMENT),
        channel: StaffNotifChannel.values.firstWhere(
            (e) => e.name == j['channel'], orElse: () => StaffNotifChannel.IN_APP),
        title: j['title'],
        message: j['message'],
        referenceId: j['reference_id'],
        referenceType: j['reference_type'] != null
            ? StaffNotifReferenceType.values.firstWhere(
                (e) => e.name == j['reference_type'], orElse: () => StaffNotifReferenceType.BOOKING)
            : null,
        isRead: j['is_read'] ?? false,
        readAt: j['read_at'] != null ? DateTime.tryParse(j['read_at']) : null,
        createdAt: DateTime.parse(j['created_at']),
      );

  @override
  List<Object?> get props => [id];
}

// ══════════════════════════════════════════════════════════════════════════════
// Staff Profile model — VS-12
// DB: users + venue_staff + venues
// ══════════════════════════════════════════════════════════════════════════════
class StaffProfileModel extends Equatable {
  // users fields
  final String userId;              // users.id
  final String fullName;            // users.full_name
  final String? email;              // users.email
  final String? phone;              // users.phone
  final String? avatarUrl;          // users.avatar_url

  // venue_staff fields
  final String venueStaffId;        // venue_staff.id
  final String venueId;             // venue_staff.venue_id
  final VenueStaffRole role;        // venue_staff.role
  final bool isActive;              // venue_staff.is_active
  final DateTime? joinedAt;         // venue_staff.joined_at
  final String? workStartTime;      // venue_staff.work_start_time → HH:mm
  final String? workEndTime;        // venue_staff.work_end_time → HH:mm
  final List<String> workDays;      // venue_staff.work_days DayOfWeek[]
  final String? note;               // venue_staff.note

  // venues fields
  final String venueName;           // venues.name
  final String? venueAddress;       // venues.address
  final String? venuePhone;         // venues.phone_number
  final String? venueLogoUrl;       // venues.logo_url

  const StaffProfileModel({
    required this.userId,
    required this.fullName,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.venueStaffId,
    required this.venueId,
    required this.role,
    required this.isActive,
    this.joinedAt,
    this.workStartTime,
    this.workEndTime,
    this.workDays = const [],
    this.note,
    required this.venueName,
    this.venueAddress,
    this.venuePhone,
    this.venueLogoUrl,
  });

  String get workDaysLabel {
    const map = {'MONDAY':'T2','TUESDAY':'T3','WEDNESDAY':'T4','THURSDAY':'T5','FRIDAY':'T6','SATURDAY':'T7','SUNDAY':'CN'};
    return workDays.map((d) => map[d] ?? d).join(' · ');
  }

  String get shiftLabel => (workStartTime != null && workEndTime != null)
      ? '$workStartTime – $workEndTime'
      : 'Chưa cài ca';

  factory StaffProfileModel.fromJson(Map<String, dynamic> j) => StaffProfileModel(
    userId: j['users']['id'],
    fullName: j['users']['full_name'],
    email: j['users']['email'],
    phone: j['users']['phone'],
    avatarUrl: j['users']['avatar_url'],
    venueStaffId: j['id'],
    venueId: j['venue_id'],
    role: VenueStaffRole.values.firstWhere(
        (e) => e.name == j['role'], orElse: () => VenueStaffRole.STAFF),
    isActive: j['is_active'] ?? true,
    joinedAt: j['joined_at'] != null ? DateTime.tryParse(j['joined_at']) : null,
    workStartTime: j['work_start_time']?.toString().substring(0, 5),
    workEndTime: j['work_end_time']?.toString().substring(0, 5),
    workDays: List<String>.from(j['work_days'] ?? []),
    note: j['note'],
    venueName: j['venues']['name'],
    venueAddress: j['venues']['address'],
    venuePhone: j['venues']['phone_number'],
    venueLogoUrl: j['venues']['logo_url'],
  );

  @override
  List<Object?> get props => [userId, venueStaffId];
}
