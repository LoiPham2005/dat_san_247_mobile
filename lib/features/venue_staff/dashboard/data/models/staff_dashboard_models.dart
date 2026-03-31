import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_dashboard_models.freezed.dart';
part 'staff_dashboard_models.g.dart';

enum CourtStatusNow {
  available,    // Không có booking hiện tại
  occupied,     // Đang có khách chơi
  reserved,     // Có booking sắp diễn ra
  maintenance,  // Đang bảo trì
  inactive,     // Đóng cửa
}

extension CourtStatusNowExt on CourtStatusNow {
  String get label => switch (this) {
    CourtStatusNow.available    => 'Trống',
    CourtStatusNow.occupied     => 'Đang dùng',
    CourtStatusNow.reserved     => 'Sắp dùng',
    CourtStatusNow.maintenance  => 'Bảo trì',
    CourtStatusNow.inactive     => 'Đóng cửa',
  };
}

enum StaffNotifType {
  newBooking,
  checkInAlert,
  bookingCancelled,
  maintenanceAlert,
  systemAlert,
  reviewReply,
}

extension StaffNotifTypeExt on StaffNotifType {
  String get label {
    switch (this) {
      case StaffNotifType.newBooking:
        return 'Booking mới';
      case StaffNotifType.checkInAlert:
        return 'Cảnh báo';
      case StaffNotifType.bookingCancelled:
        return 'Huỷ sân';
      case StaffNotifType.maintenanceAlert:
        return 'Bảo trì';
      case StaffNotifType.systemAlert:
        return 'Hệ thống';
      case StaffNotifType.reviewReply:
        return 'Đánh giá';
    }
  }
}

@freezed
abstract class StaffNotificationModel with _$StaffNotificationModel {
  const factory StaffNotificationModel({
    required String id,
    required String title,
    required String body,
    required StaffNotifType type,
    String? referenceId,
    required bool isRead,
    required DateTime createdAt,
  }) = _StaffNotificationModel;

  factory StaffNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$StaffNotificationModelFromJson(json);
}

@freezed
abstract class CourtMaintenanceModel with _$CourtMaintenanceModel {
  const CourtMaintenanceModel._();
  const factory CourtMaintenanceModel({
    required String id,
    required String courtId,
    required DateTime startAt,
    required DateTime endAt,
    required String reason,
    required bool isEmergency,
    String? creatorName,
  }) = _CourtMaintenanceModel;

  factory CourtMaintenanceModel.fromJson(Map<String, dynamic> json) =>
      _$CourtMaintenanceModelFromJson(json);

  bool get isActiveNow {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }
}

@freezed
abstract class CourtStatusModel with _$CourtStatusModel {
  const CourtStatusModel._();
  const factory CourtStatusModel({
    required String id,
    required String name,
    required bool isIndoor,
    required bool isActive,
    String? surfaceType,
    String? size,
    required double pricePerHour,
    required int displayOrder,
    
    // Current booking info
    String? currentBookingId,
    String? currentCustomerName,
    String? currentCustomerPhone,
    String? currentStartTime,
    String? currentEndTime,
    String? currentBookingCode,
    
    // Next booking info
    String? nextStartTime,
    String? nextCustomerName,

    // Maintenance
    CourtMaintenanceModel? activeMaintenance,

    @Default(0) int todayBookingCount,
    @Default(0) int todayCheckedInCount,
  }) = _CourtStatusModel;

  factory CourtStatusModel.fromJson(Map<String, dynamic> json) =>
      _$CourtStatusModelFromJson(json);

  CourtStatusNow get statusNow {
    if (!isActive) return CourtStatusNow.inactive;
    if (activeMaintenance != null && activeMaintenance!.isActiveNow) return CourtStatusNow.maintenance;
    if (currentBookingId != null) return CourtStatusNow.occupied;
    if (nextCustomerName != null) return CourtStatusNow.reserved;
    return CourtStatusNow.available;
  }
}

@freezed
abstract class StaffDashboardModel with _$StaffDashboardModel {
  const StaffDashboardModel._();
  const factory StaffDashboardModel({
    required String venueId,
    required String venueName,
    required String venueAddress,
    required DateTime date,
    required String staffName,
    required String staffRole,
    String? shiftStart,
    String? shiftEnd,
    required bool autoAccept,

    // Stats
    required int totalBookingsToday,
    required int pendingCount,
    required int confirmedCount,
    required int checkedInCount,
    required int completedCount,
    required int noShowCount,
    required double revenueToday,
    required double revenuePending,
    required int waitlistCount,

    // Lists
    required List<CourtStatusModel> courts,
    required List<CourtMaintenanceModel> maintenanceToday,
    required List<Map<String, dynamic>> recentPending,
  }) = _StaffDashboardModel;

  factory StaffDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$StaffDashboardModelFromJson(json);

  int get availableCourts =>
      courts.where((c) => c.statusNow == CourtStatusNow.available).length;

  double get checkInRate => totalBookingsToday == 0 ? 0 : checkedInCount / totalBookingsToday;
}
