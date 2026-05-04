// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:equatable/equatable.dart';

// ──────────────────────────────────────────────────────────────────────────
// Enums (mirrors schema.prisma)
// ──────────────────────────────────────────────────────────────────────────

enum BookingStatusVS {
  PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED, NO_SHOW;

  String get label {
    switch (this) {
      case PENDING: return 'Chờ xác nhận';
      case CONFIRMED: return 'Đã xác nhận';
      case CHECKED_IN: return 'Đã check-in';
      case COMPLETED: return 'Hoàn thành';
      case CANCELLED: return 'Đã huỷ';
      case NO_SHOW: return 'Vắng mặt';
    }
  }

  bool get canCheckIn => this == CONFIRMED;
  bool get isActive => this == PENDING || this == CONFIRMED;
}

enum VenueStaffRole { OWNER, MANAGER, STAFF, RECEPTIONIST;
  String get label => switch(this) {
    OWNER => 'Chủ sân',
    MANAGER => 'Quản lý',
    STAFF => 'Nhân viên',
    RECEPTIONIST => 'Nhân viên lễ tân',
  };
  bool get canMarkNoShow => this == OWNER || this == MANAGER || this == STAFF;
}

// ──────────────────────────────────────────────────────────────────────────
// booking_addons model (for check-in display)
// ──────────────────────────────────────────────────────────────────────────
class StaffBookingAddonModel extends Equatable {
  final String id;
  final String bookingId;
  final String serviceId;
  final String serviceName;
  final String? serviceCategory;
  final int quantity;
  final double pricePerUnit;
  final double totalPrice;
  final String? note;

  const StaffBookingAddonModel({
    required this.id,
    required this.bookingId,
    required this.serviceId,
    required this.serviceName,
    this.serviceCategory,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPrice,
    this.note,
  });

  factory StaffBookingAddonModel.fromJson(Map<String, dynamic> json) =>
      StaffBookingAddonModel(
        id: json['id'],
        bookingId: json['booking_id'],
        serviceId: json['service_id'],
        serviceName: json['venue_services']?['name'] ?? json['service_name'] ?? '',
        serviceCategory: json['venue_services']?['category'],
        quantity: json['quantity'] ?? 1,
        pricePerUnit: (json['price_per_unit'] as num).toDouble(),
        totalPrice: (json['total_price'] as num).toDouble(),
        note: json['note'],
      );

  @override
  List<Object?> get props => [id, serviceId, quantity];
}

// ──────────────────────────────────────────────────────────────────────────
// Check-in booking model — full info needed for VS-02/VS-03
// Joins: bookings + courts + venues + users (customer) + booking_addons
// ──────────────────────────────────────────────────────────────────────────
class CheckInBookingModel extends Equatable {
  // booking fields
  final String id;
  final String bookingCode;
  final String? checkInCode; // unique VarChar(10)

  // court + venue
  final String courtId;
  final String courtName;
  final bool isIndoor;
  final String venueName;
  final String venueAddress;

  // customer
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String? customerAvatar;

  // booking time
  final DateTime bookingDate;
  final String startTime; // HH:mm
  final String endTime;

  // status
  final BookingStatusVS status;
  final double totalAmount;
  final String? paymentMethod;

  // addons
  final List<StaffBookingAddonModel> addons;

  // check-in metadata
  final DateTime? checkedInAt;
  final String? checkedInByName;

  const CheckInBookingModel({
    required this.id,
    required this.bookingCode,
    this.checkInCode,
    required this.courtId,
    required this.courtName,
    required this.isIndoor,
    required this.venueName,
    required this.venueAddress,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerAvatar,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalAmount,
    this.paymentMethod,
    this.addons = const [],
    this.checkedInAt,
    this.checkedInByName,
  });

  /// Validate trước check-in: status=CONFIRMED, booking_date=today, time range +/- 30 phút
  bool get isValidForCheckIn {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bDate = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
    if (bDate != today) return false;
    if (status != BookingStatusVS.CONFIRMED) return false;
    // parse startTime and allow 30 min grace
    final parts = startTime.split(':');
    final startDt = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    return now.isAfter(startDt.subtract(const Duration(minutes: 30)));
  }

  String get validationError {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bDate = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
    if (bDate != today) return 'Booking không phải hôm nay';
    if (status == BookingStatusVS.CHECKED_IN) return 'Đã check-in rồi';
    if (status == BookingStatusVS.CANCELLED) return 'Booking đã bị huỷ';
    if (status == BookingStatusVS.NO_SHOW) return 'Booking đã vắng mặt';
    if (status == BookingStatusVS.COMPLETED) return 'Booking đã hoàn thành';
    if (status == BookingStatusVS.PENDING) return 'Booking chưa được xác nhận';
    return 'Chưa đến giờ check-in (30 phút trước giờ chơi)';
  }

  factory CheckInBookingModel.fromJson(Map<String, dynamic> json) =>
      CheckInBookingModel(
        id: json['id'],
        bookingCode: json['booking_code'],
        checkInCode: json['check_in_code'],
        courtId: json['court_id'],
        courtName: json['courts']?['name'] ?? '',
        isIndoor: json['courts']?['is_indoor'] ?? false,
        venueName: json['venues']?['name'] ?? '',
        venueAddress: json['venues']?['address'] ?? '',
        customerId: json['customer_id'],
        customerName: json['customers']?['full_name'] ?? 'Khách hàng',
        customerPhone: json['customers']?['phone'],
        customerAvatar: json['customers']?['avatar_url'],
        bookingDate: DateTime.parse(json['booking_date']),
        startTime: _parseTime(json['start_time']),
        endTime: _parseTime(json['end_time']),
        status: BookingStatusVS.values.firstWhere(
            (e) => e.name == json['status'], orElse: () => BookingStatusVS.PENDING),
        totalAmount: (json['total_amount'] as num).toDouble(),
        paymentMethod: json['payment_method'],
        addons: (json['booking_addons'] as List? ?? [])
            .map((a) => StaffBookingAddonModel.fromJson(a))
            .toList(),
        checkedInAt: json['checked_in_at'] != null ? DateTime.parse(json['checked_in_at']) : null,
        checkedInByName: json['check_in_staff']?['full_name'],
      );

  static String _parseTime(dynamic t) {
    if (t == null) return '00:00';
    final s = t.toString();
    if (s.contains('T')) {
      final dt = DateTime.tryParse(s);
      if (dt != null) return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return s.substring(0, 5);
  }

  @override
  List<Object?> get props => [id, bookingCode, status];
}

// ──────────────────────────────────────────────────────────────────────────
// Today schedule model — for VS-04 timeline grouped by court
// ──────────────────────────────────────────────────────────────────────────
class TodayCourtScheduleModel extends Equatable {
  final String courtId;
  final String courtName;
  final bool isIndoor;
  final String? thumbnail;
  final List<CheckInBookingModel> bookings;

  const TodayCourtScheduleModel({
    required this.courtId,
    required this.courtName,
    required this.isIndoor,
    this.thumbnail,
    required this.bookings,
  });

  int get checkedInCount => bookings.where((b) => b.status == BookingStatusVS.CHECKED_IN).length;
  int get confirmedCount => bookings.where((b) => b.status == BookingStatusVS.CONFIRMED).length;
  int get pendingCount => bookings.where((b) => b.status == BookingStatusVS.PENDING).length;

  @override
  List<Object?> get props => [courtId];
}
