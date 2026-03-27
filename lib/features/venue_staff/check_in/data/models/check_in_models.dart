import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_in_models.freezed.dart';
part 'check_in_models.g.dart';

// ── Enums (mirrors schema.prisma) ───────────────────────────────────────────

enum BookingStatusVS {
  PENDING,
  CONFIRMED,
  CHECKED_IN,
  COMPLETED,
  CANCELLED,
  NO_SHOW;

  String get label {
    switch (this) {
      case PENDING:
        return 'Chờ xác nhận';
      case CONFIRMED:
        return 'Đã xác nhận';
      case CHECKED_IN:
        return 'Đã check-in';
      case COMPLETED:
        return 'Hoàn thành';
      case CANCELLED:
        return 'Đã huỷ';
      case NO_SHOW:
        return 'Vắng mặt';
    }
  }

  bool get canCheckIn => this == CONFIRMED;
  bool get isActive => this == PENDING || this == CONFIRMED;
}

enum VenueStaffRole {
  OWNER,
  MANAGER,
  STAFF,
  RECEPTIONIST;

  String get label => switch (this) {
        OWNER => 'Chủ sân',
        MANAGER => 'Quản lý',
        STAFF => 'Nhân viên',
        RECEPTIONIST => 'Nhân viên lễ tân',
      };
  bool get canMarkNoShow => this == OWNER || this == MANAGER || this == STAFF;
}

// ── booking_addons model ───────────────────────────────────────────────────
@freezed
abstract class StaffBookingAddonModel with _$StaffBookingAddonModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffBookingAddonModel({
    required String id,
    required String bookingId,
    required String serviceId,
    required String serviceName,
    String? serviceCategory,
    required int quantity,
    required double pricePerUnit,
    required double totalPrice,
    String? note,
  }) = _StaffBookingAddonModel;

  const StaffBookingAddonModel._();

  factory StaffBookingAddonModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['venue_services'] != null && json['venue_services'] is Map) {
      mappedJson['service_name'] = json['venue_services']['name'] ??
          json['service_name'] ??
          '';
      mappedJson['service_category'] = json['venue_services']['category'];
    }
    return _$StaffBookingAddonModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── Check-in booking model ─────────────────────────────────────────────────
@freezed
abstract class CheckInBookingModel with _$CheckInBookingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CheckInBookingModel({
    required String id,
    required String bookingCode,
    String? checkInCode,
    required String courtId,
    required String courtName,
    required bool isIndoor,
    required String venueName,
    required String venueAddress,
    required String customerId,
    required String customerName,
    String? customerPhone,
    String? customerAvatar,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required BookingStatusVS status,
    required double totalAmount,
    String? paymentMethod,
    @Default([]) List<StaffBookingAddonModel> addons,
    DateTime? checkedInAt,
    String? checkedInByName,
  }) = _CheckInBookingModel;

  const CheckInBookingModel._();

  bool get isValidForCheckIn {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bDate = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
    if (bDate != today) return false;
    if (status != BookingStatusVS.CONFIRMED) return false;

    final parts = startTime.split(':');
    final startDt = DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
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

  factory CheckInBookingModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'] ?? '';
      mappedJson['is_indoor'] = json['courts']['is_indoor'] ?? false;
    }
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'] ?? '';
      mappedJson['venue_address'] = json['venues']['address'] ?? '';
    }
    if (json['customers'] != null && json['customers'] is Map) {
      mappedJson['customer_name'] = json['customers']['full_name'] ?? 'Khách hàng';
      mappedJson['customer_phone'] = json['customers']['phone'];
      mappedJson['customer_avatar'] = json['customers']['avatar_url'];
    }
    if (json['start_time'] != null) {
      mappedJson['start_time'] = _parseTime(json['start_time']);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = _parseTime(json['end_time']);
    }
    if (json['check_in_staff'] != null && json['check_in_staff'] is Map) {
      mappedJson['checked_in_by_name'] = json['check_in_staff']['full_name'];
    }
    return _$CheckInBookingModelFromJson(mappedJson);
  }

  static String _parseTime(dynamic t) {
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

// ── Today schedule model ───────────────────────────────────────────────────
@freezed
abstract class TodayCourtScheduleModel with _$TodayCourtScheduleModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TodayCourtScheduleModel({
    required String courtId,
    required String courtName,
    required bool isIndoor,
    String? thumbnail,
    required List<CheckInBookingModel> bookings,
  }) = _TodayCourtScheduleModel;

  const TodayCourtScheduleModel._();

  int get checkedInCount =>
      bookings.where((b) => b.status == BookingStatusVS.CHECKED_IN).length;
  int get confirmedCount =>
      bookings.where((b) => b.status == BookingStatusVS.CONFIRMED).length;
  int get pendingCount =>
      bookings.where((b) => b.status == BookingStatusVS.PENDING).length;

  factory TodayCourtScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$TodayCourtScheduleModelFromJson(json);

  Map<String, dynamic> toJson();
}
