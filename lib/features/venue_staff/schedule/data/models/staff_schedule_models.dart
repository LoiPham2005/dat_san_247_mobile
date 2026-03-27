import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

part 'staff_schedule_models.freezed.dart';
part 'staff_schedule_models.g.dart';

// ── Enums ──────────────────────────────────────────────────────────────────
enum VenueServiceType { SERVICE, EQUIPMENT, FOOD_BEVERAGE, OTHER }

enum ServiceUnit { UNIT, HOUR, SESSION, PERSON, KG, LITER }

extension ServiceUnitExt on ServiceUnit {
  String get label => switch (this) {
        ServiceUnit.UNIT => 'cái',
        ServiceUnit.HOUR => 'giờ',
        ServiceUnit.SESSION => 'buổi',
        ServiceUnit.PERSON => 'người',
        ServiceUnit.KG => 'kg',
        ServiceUnit.LITER => 'lít',
      };
}

// ── venue_services model ───────────────────────────────────────────────────
@freezed
abstract class VenueServiceModel with _$VenueServiceModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueServiceModel({
    required String id,
    required String venueId,
    required String name,
    String? description,
    required double price,
    @Default(ServiceUnit.UNIT) ServiceUnit unit,
    @Default(VenueServiceType.SERVICE) VenueServiceType type,
    String? category,
    @Default(true) bool isAvailable,
    @Default(false) bool trackInventory,
    @Default(0) int stockQuantity,
  }) = _VenueServiceModel;

  const VenueServiceModel._();

  bool get isInStock => !trackInventory || stockQuantity > 0;

  factory VenueServiceModel.fromJson(Map<String, dynamic> json) =>
      _$VenueServiceModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── Staff Booking Detail model ─────────────────────────────────────────────
@freezed
abstract class StaffBookingDetailModel with _$StaffBookingDetailModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StaffBookingDetailModel({
    required String id,
    required String bookingCode,
    String? checkInCode,
    required String customerId,
    required String customerName,
    String? customerPhone,
    String? customerAvatar,
    required String courtId,
    required String courtName,
    required bool isIndoor,
    required String venueName,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required BookingStatusVS status,
    String? paymentMethod,
    @Default('PENDING') String paymentStatus,
    required double subTotal,
    @Default(0) double discountAmount,
    @Default(0) double vatAmount,
    required double totalAmount,
    @Default(0) double depositAmount,
    @Default([]) List<StaffBookingAddonModel> addons,
    DateTime? checkedInAt,
    String? checkedInByName,
    String? note,
  }) = _StaffBookingDetailModel;

  const StaffBookingDetailModel._();

  double get addonTotal =>
      addons.fold(0, (s, a) => s + (a.totalPrice as double));

  factory StaffBookingDetailModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['customers'] != null && json['customers'] is Map) {
      mappedJson['customer_name'] = json['customers']['full_name'] ?? 'Khách hàng';
      mappedJson['customer_phone'] = json['customers']['phone'];
      mappedJson['customer_avatar'] = json['customers']['avatar_url'];
    }
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'] ?? '';
      mappedJson['is_indoor'] = json['courts']['is_indoor'] ?? false;
    }
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'] ?? '';
    }
    if (json['start_time'] != null) {
      mappedJson['start_time'] = _pt(json['start_time']);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = _pt(json['end_time']);
    }
    if (json['check_in_staff'] != null && json['check_in_staff'] is Map) {
      mappedJson['checked_in_by_name'] = json['check_in_staff']['full_name'];
    }
    return _$StaffBookingDetailModelFromJson(mappedJson);
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

// ── venue_staff member model ───────────────────────────────────────────────
@freezed
abstract class VenueStaffMemberModel with _$VenueStaffMemberModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueStaffMemberModel({
    required String id,
    required String userId,
    required String fullName,
    String? phone,
    String? avatarUrl,
    required VenueStaffRole role,
    required bool isActive,
    DateTime? joinedAt,
    DateTime? deactivatedAt,
    String? deactivatedByName,
    String? workStartTime,
    String? workEndTime,
    @Default([]) List<String> workDays,
    String? note,
  }) = _VenueStaffMemberModel;

  const VenueStaffMemberModel._();

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

  bool get canBeDeactivated =>
      role == VenueStaffRole.STAFF || role == VenueStaffRole.RECEPTIONIST;

  factory VenueStaffMemberModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['users'] != null && json['users'] is Map) {
      mappedJson['full_name'] = json['users']['full_name'] ?? 'Nhân viên';
      mappedJson['phone'] = json['users']['phone'];
      mappedJson['avatar_url'] = json['users']['avatar_url'];
    }
    if (json['deactivator_user'] != null && json['deactivator_user'] is Map) {
      mappedJson['deactivated_by_name'] = json['deactivator_user']['full_name'];
    }
    if (json['work_start_time'] != null) {
      mappedJson['work_start_time'] =
          json['work_start_time'].toString().substring(0, 5);
    }
    if (json['work_end_time'] != null) {
      mappedJson['work_end_time'] =
          json['work_end_time'].toString().substring(0, 5);
    }
    return _$VenueStaffMemberModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}
