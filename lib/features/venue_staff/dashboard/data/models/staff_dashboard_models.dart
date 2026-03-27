import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_dashboard_models.freezed.dart';
part 'staff_dashboard_models.g.dart';

// ── Enums ──────────────────────────────────────────────────────────────────
enum CourtStatusNow {
  available, // Không có booking hiện tại
  occupied, // Đang có khách chơi
  reserved, // Sắp dùng
  maintenance, // Bảo trì
  inactive, // Đóng cửa
}

extension CourtStatusNowExt on CourtStatusNow {
  String get label => switch (this) {
        CourtStatusNow.available => 'Trống',
        CourtStatusNow.occupied => 'Đang dùng',
        CourtStatusNow.reserved => 'Sắp dùng',
        CourtStatusNow.maintenance => 'Bảo trì',
        CourtStatusNow.inactive => 'Đóng cửa',
      };
  bool get isAvailable => this == CourtStatusNow.available;
}

// ── court_maintenance snapshot ──────────────────────────────────────────────
@freezed
abstract class CourtMaintenanceModel with _$CourtMaintenanceModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CourtMaintenanceModel({
    required String id,
    required String courtId,
    required DateTime startAt,
    required DateTime endAt,
    required String reason,
    @Default(false) bool isEmergency,
    String? createdByName,
  }) = _CourtMaintenanceModel;

  const CourtMaintenanceModel._();

  bool get isActiveNow {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }

  factory CourtMaintenanceModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['creator'] != null && json['creator'] is Map) {
      mappedJson['created_by_name'] = json['creator']['full_name'];
    }
    return _$CourtMaintenanceModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── Court status snapshot ──────────────────────────────────────────────────
@freezed
abstract class CourtStatusModel with _$CourtStatusModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CourtStatusModel({
    required String id,
    required String name,
    @Default(false) bool isIndoor,
    @Default(true) bool isActive,
    String? surfaceType,
    String? size,
    required double pricePerHour,
    @Default(0) int displayOrder,
    String? currentBookingId,
    String? currentCustomerName,
    String? currentCustomerPhone,
    String? currentStartTime,
    String? currentEndTime,
    String? currentBookingCode,
    String? nextCustomerName,
    String? nextStartTime,
    CourtMaintenanceModel? activeMaintenance,
    @Default(0) int todayBookingCount,
    @Default(0) int todayCheckedInCount,
  }) = _CourtStatusModel;

  const CourtStatusModel._();

  CourtStatusNow get statusNow {
    if (!isActive) return CourtStatusNow.inactive;
    if (activeMaintenance != null) return CourtStatusNow.maintenance;
    if (currentBookingId != null) return CourtStatusNow.occupied;
    if (nextStartTime != null) return CourtStatusNow.reserved;
    return CourtStatusNow.available;
  }

  factory CourtStatusModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['current_booking'] != null && json['current_booking'] is Map) {
      mappedJson['current_booking_id'] = json['current_booking']['id'];
      if (json['current_booking']['customers'] != null) {
        mappedJson['current_customer_name'] =
            json['current_booking']['customers']['full_name'];
        mappedJson['current_customer_phone'] =
            json['current_booking']['customers']['phone'];
      }
      mappedJson['current_start_time'] = json['current_booking']['start_time'];
      mappedJson['current_end_time'] = json['current_booking']['end_time'];
      mappedJson['current_booking_code'] =
          json['current_booking']['booking_code'];
    }
    if (json['next_booking'] != null && json['next_booking'] is Map) {
      mappedJson['next_customer_name'] =
          json['next_booking']['customers']?['full_name'];
      mappedJson['next_start_time'] = json['next_booking']['start_time'];
    }
    return _$CourtStatusModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── Staff Dashboard summary ────────────────────────────────────────────────
@freezed
abstract class StaffDashboardModel with _$StaffDashboardModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffDashboardModel({
    required String venueId,
    required String venueName,
    required String venueAddress,
    required DateTime date,
    required int totalBookingsToday,
    required int pendingCount,
    required int confirmedCount,
    required int checkedInCount,
    required int completedCount,
    required int noShowCount,
    required double revenueToday,
    required double revenuePending,
    required List<CourtStatusModel> courts,
    required List<CourtMaintenanceModel> maintenanceToday,
    required String staffName,
    required String staffRole,
    String? shiftStart,
    String? shiftEnd,
  }) = _StaffDashboardModel;

  const StaffDashboardModel._();

  int get availableCourts =>
      courts.where((c) => c.statusNow == CourtStatusNow.available).length;
  int get occupiedCourts =>
      courts.where((c) => c.statusNow == CourtStatusNow.occupied).length;
  int get maintenanceCourtsCount =>
      courts.where((c) => c.statusNow == CourtStatusNow.maintenance).length;

  double get checkInRate =>
      totalBookingsToday == 0 ? 0 : checkedInCount / totalBookingsToday;

  factory StaffDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$StaffDashboardModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── Notification model ──────────────────────────────────────────────────────
enum StaffNotifType {
  newBooking,
  bookingCancelled,
  checkInAlert,
  maintenanceAlert,
  systemAlert,
  reviewReply;

  String get label => switch (this) {
        newBooking => 'Booking mới',
        bookingCancelled => 'Huỷ booking',
        checkInAlert => 'Check-in',
        maintenanceAlert => 'Bảo trì',
        systemAlert => 'Hệ thống',
        reviewReply => 'Đánh giá',
      };
}

@freezed
abstract class StaffNotificationModel with _$StaffNotificationModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffNotificationModel({
    required String id,
    required String title,
    required String body,
    required StaffNotifType type,
    String? referenceId,
    String? referenceType,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _StaffNotificationModel;

  const StaffNotificationModel._();

  factory StaffNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$StaffNotificationModelFromJson(json);

  Map<String, dynamic> toJson();
}
