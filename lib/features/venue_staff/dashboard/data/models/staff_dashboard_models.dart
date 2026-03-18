import 'package:equatable/equatable.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Staff Dashboard Models — mirrors schema.prisma
// VS-01 DB: bookings, courts, court_maintenance, venue_staff
// ══════════════════════════════════════════════════════════════════════════════

// ── Enums ─────────────────────────────────────────────────────────────────────
enum CourtStatusNow {
  available,    // Không có booking hiện tại
  occupied,     // Đang có khách chơi (start_time ≤ now ≤ end_time, status=CHECKED_IN)
  reserved,     // Có booking CONFIRMED/PENDING trong vòng 30 phút
  maintenance,  // court_maintenance record covers now
  inactive,     // courts.is_active = false
}

extension CourtStatusNowExt on CourtStatusNow {
  String get label => switch (this) {
    CourtStatusNow.available    => 'Trống',
    CourtStatusNow.occupied     => 'Đang dùng',
    CourtStatusNow.reserved     => 'Sắp dùng',
    CourtStatusNow.maintenance  => 'Bảo trì',
    CourtStatusNow.inactive     => 'Đóng cửa',
  };

  bool get isAvailable => this == CourtStatusNow.available;
}

// ── court_maintenance snapshot ────────────────────────────────────────────────
// DB: court_maintenance { id, court_id, start_at, end_at, reason, is_emergency }
class CourtMaintenanceModel extends Equatable {
  final String id;
  final String courtId;
  final DateTime startAt;         // @db.Timestamp(6)
  final DateTime endAt;
  final String reason;            // @db.VarChar(500)
  final bool isEmergency;
  final String? createdByName;

  const CourtMaintenanceModel({
    required this.id,
    required this.courtId,
    required this.startAt,
    required this.endAt,
    required this.reason,
    required this.isEmergency,
    this.createdByName,
  });

  bool get isActiveNow {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }

  factory CourtMaintenanceModel.fromJson(Map<String, dynamic> j) =>
      CourtMaintenanceModel(
        id: j['id'],
        courtId: j['court_id'],
        startAt: DateTime.parse(j['start_at']),
        endAt: DateTime.parse(j['end_at']),
        reason: j['reason'],
        isEmergency: j['is_emergency'] ?? false,
        createdByName: j['creator']?['full_name'],
      );

  @override
  List<Object?> get props => [id, courtId];
}

// ── Court status snapshot (joins courts + bookings + court_maintenance) ───────
// DB: courts { id, venue_id, name, is_indoor, is_active, surface_type, size }
//     + current booking (start_time ≤ now ≤ end_time, status IN [CONFIRMED, CHECKED_IN])
class CourtStatusModel extends Equatable {
  final String id;                            // courts.id
  final String name;                          // courts.name
  final bool isIndoor;                        // courts.is_indoor
  final bool isActive;                        // courts.is_active
  final String? surfaceType;                  // courts.surface_type
  final String? size;                         // courts.size
  final double pricePerHour;                  // courts.price_per_hour
  final int displayOrder;                     // courts.display_order

  // Current booking (if any)
  final String? currentBookingId;
  final String? currentCustomerName;
  final String? currentCustomerPhone;
  final String? currentStartTime;             // HH:mm
  final String? currentEndTime;
  final String? currentBookingCode;

  // Next upcoming booking (within 2 hours)
  final String? nextCustomerName;
  final String? nextStartTime;

  // Maintenance
  final CourtMaintenanceModel? activeMaintenance;

  // Today's stats
  final int todayBookingCount;
  final int todayCheckedInCount;

  const CourtStatusModel({
    required this.id,
    required this.name,
    required this.isIndoor,
    required this.isActive,
    this.surfaceType,
    this.size,
    required this.pricePerHour,
    required this.displayOrder,
    this.currentBookingId,
    this.currentCustomerName,
    this.currentCustomerPhone,
    this.currentStartTime,
    this.currentEndTime,
    this.currentBookingCode,
    this.nextCustomerName,
    this.nextStartTime,
    this.activeMaintenance,
    this.todayBookingCount = 0,
    this.todayCheckedInCount = 0,
  });

  CourtStatusNow get statusNow {
    if (!isActive) return CourtStatusNow.inactive;
    if (activeMaintenance != null) return CourtStatusNow.maintenance;
    if (currentBookingId != null) return CourtStatusNow.occupied;
    if (nextStartTime != null) return CourtStatusNow.reserved;
    return CourtStatusNow.available;
  }

  factory CourtStatusModel.fromJson(Map<String, dynamic> j) =>
      CourtStatusModel(
        id: j['id'],
        name: j['name'],
        isIndoor: j['is_indoor'] ?? false,
        isActive: j['is_active'] ?? true,
        surfaceType: j['surface_type'],
        size: j['size'],
        pricePerHour: (j['price_per_hour'] as num).toDouble(),
        displayOrder: j['display_order'] ?? 0,
        currentBookingId: j['current_booking']?['id'],
        currentCustomerName: j['current_booking']?['customers']?['full_name'],
        currentCustomerPhone: j['current_booking']?['customers']?['phone'],
        currentStartTime: j['current_booking']?['start_time'],
        currentEndTime: j['current_booking']?['end_time'],
        currentBookingCode: j['current_booking']?['booking_code'],
        nextCustomerName: j['next_booking']?['customers']?['full_name'],
        nextStartTime: j['next_booking']?['start_time'],
        activeMaintenance: j['active_maintenance'] != null
            ? CourtMaintenanceModel.fromJson(j['active_maintenance']) : null,
        todayBookingCount: j['today_booking_count'] ?? 0,
        todayCheckedInCount: j['today_checked_in_count'] ?? 0,
      );

  @override
  List<Object?> get props => [id];
}

// ── Staff Dashboard summary ────────────────────────────────────────────────────
// DB: bookings WHERE booking_date=today AND venue_id=myVenue AND status≠CANCELLED
class StaffDashboardModel extends Equatable {
  final String venueId;
  final String venueName;
  final String venueAddress;
  final DateTime date;                         // today

  // Booking stats
  final int totalBookingsToday;                // COUNT bookings today, ≠CANCELLED
  final int pendingCount;                      // status=PENDING
  final int confirmedCount;                    // status=CONFIRMED
  final int checkedInCount;                    // status=CHECKED_IN
  final int completedCount;                    // status=COMPLETED
  final int noShowCount;                       // status=NO_SHOW

  // Revenue snapshot (không lọc hoa hồng)
  final double revenueToday;                   // SUM total_amount where status=COMPLETED/CHECKED_IN
  final double revenuePending;                 // SUM where status=CONFIRMED/PENDING

  // Courts
  final List<CourtStatusModel> courts;

  // Maintenance today
  final List<CourtMaintenanceModel> maintenanceToday;

  // Staff info
  final String staffName;
  final String staffRole;                      // VenueStaffRole
  final String? shiftStart;                    // work_start_time HH:mm
  final String? shiftEnd;                      // work_end_time HH:mm

  const StaffDashboardModel({
    required this.venueId,
    required this.venueName,
    required this.venueAddress,
    required this.date,
    required this.totalBookingsToday,
    required this.pendingCount,
    required this.confirmedCount,
    required this.checkedInCount,
    required this.completedCount,
    required this.noShowCount,
    required this.revenueToday,
    required this.revenuePending,
    required this.courts,
    required this.maintenanceToday,
    required this.staffName,
    required this.staffRole,
    this.shiftStart,
    this.shiftEnd,
  });

  int get availableCourts =>
      courts.where((c) => c.statusNow == CourtStatusNow.available).length;
  int get occupiedCourts =>
      courts.where((c) => c.statusNow == CourtStatusNow.occupied).length;
  int get maintenanceCourtsCount =>
      courts.where((c) => c.statusNow == CourtStatusNow.maintenance).length;

  double get checkInRate => totalBookingsToday == 0
      ? 0 : checkedInCount / totalBookingsToday;

  @override
  List<Object?> get props => [venueId, date];
}

// ── Notification model (shared) ───────────────────────────────────────────────
// DB: notifications { id, user_id, title, body, type, reference_id, reference_type, is_read, created_at }
enum StaffNotifType {
  newBooking, bookingCancelled, checkInAlert,
  maintenanceAlert, systemAlert, reviewReply;

  String get label => switch (this) {
    newBooking => 'Booking mới',
    bookingCancelled => 'Huỷ booking',
    checkInAlert => 'Check-in',
    maintenanceAlert => 'Bảo trì',
    systemAlert => 'Hệ thống',
    reviewReply => 'Đánh giá',
  };
}

class StaffNotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final StaffNotifType type;
  final String? referenceId;
  final String? referenceType;
  final bool isRead;
  final DateTime createdAt;

  const StaffNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    this.referenceType,
    required this.isRead,
    required this.createdAt,
  });

  factory StaffNotificationModel.fromJson(Map<String, dynamic> j) =>
      StaffNotificationModel(
        id: j['id'],
        title: j['title'],
        body: j['body'],
        type: StaffNotifType.values.firstWhere(
            (e) => e.name == (j['type'] ?? ''), orElse: () => StaffNotifType.systemAlert),
        referenceId: j['reference_id'],
        referenceType: j['reference_type'],
        isRead: j['is_read'] ?? false,
        createdAt: DateTime.parse(j['created_at']),
      );

  @override
  List<Object?> get props => [id];
}
