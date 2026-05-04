// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:equatable/equatable.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// venue_services model — DB: venue_services
// { id, venue_id, name, description, price, unit, type, category, is_available,
//   track_inventory, stock_quantity }
// ══════════════════════════════════════════════════════════════════════════════
enum VenueServiceType { SERVICE, EQUIPMENT, FOOD_BEVERAGE, OTHER }
enum ServiceUnit { UNIT, HOUR, SESSION, PERSON, KG, LITER }

extension ServiceUnitExt on ServiceUnit {
  String get label => switch (this) {
    ServiceUnit.UNIT    => 'cái',
    ServiceUnit.HOUR    => 'giờ',
    ServiceUnit.SESSION => 'buổi',
    ServiceUnit.PERSON  => 'người',
    ServiceUnit.KG      => 'kg',
    ServiceUnit.LITER   => 'lít',
  };
}

class VenueServiceModel extends Equatable {
  final String id;                    // @id
  final String venueId;               // venue_services.venue_id
  final String name;                  // @db.VarChar(255)
  final String? description;
  final double price;                 // @db.Decimal(15, 2)
  final ServiceUnit unit;             // @default(UNIT)
  final VenueServiceType type;        // @default(SERVICE)
  final String? category;             // @db.VarChar(100)
  final bool isAvailable;             // @default(true)
  final bool trackInventory;          // @default(false)
  final int stockQuantity;            // @default(0)

  const VenueServiceModel({
    required this.id,
    required this.venueId,
    required this.name,
    this.description,
    required this.price,
    this.unit = ServiceUnit.UNIT,
    this.type = VenueServiceType.SERVICE,
    this.category,
    this.isAvailable = true,
    this.trackInventory = false,
    this.stockQuantity = 0,
  });

  bool get isInStock => !trackInventory || stockQuantity > 0;

  factory VenueServiceModel.fromJson(Map<String, dynamic> j) => VenueServiceModel(
    id: j['id'],
    venueId: j['venue_id'],
    name: j['name'],
    description: j['description'],
    price: (j['price'] as num).toDouble(),
    unit: ServiceUnit.values.firstWhere((e) => e.name == (j['unit'] ?? 'UNIT'), orElse: () => ServiceUnit.UNIT),
    type: VenueServiceType.values.firstWhere((e) => e.name == (j['type'] ?? 'SERVICE'), orElse: () => VenueServiceType.SERVICE),
    category: j['category'],
    isAvailable: j['is_available'] ?? true,
    trackInventory: j['track_inventory'] ?? false,
    stockQuantity: j['stock_quantity'] ?? 0,
  );

  @override
  List<Object?> get props => [id];
}

// ══════════════════════════════════════════════════════════════════════════════
// Staff Booking Detail model — VS-05
// DB: bookings + courts + users + booking_addons + venue_services + check_in_code
// ══════════════════════════════════════════════════════════════════════════════
class StaffBookingDetailModel extends Equatable {
  // bookings fields
  final String id;
  final String bookingCode;          // bookings.booking_code @unique
  final String? checkInCode;         // bookings.check_in_code VarChar(10)

  // Customer (bookings.customer_id → users)
  final String customerId;
  final String customerName;         // users.full_name
  final String? customerPhone;       // users.phone
  final String? customerAvatar;

  // Court + Venue
  final String courtId;
  final String courtName;
  final bool isIndoor;
  final String venueName;

  // Time
  final DateTime bookingDate;
  final String startTime;            // HH:mm
  final String endTime;

  // Status
  final BookingStatusVS status;
  final String? paymentMethod;
  final String paymentStatus;        // PaymentStatus

  // Financial (bookings)
  final double subTotal;             // bookings.sub_total
  final double discountAmount;       // bookings.discount_amount
  final double vatAmount;            // bookings.vat_amount
  final double totalAmount;          // bookings.total_amount
  final double depositAmount;        // bookings.deposit_amount

  // current addons
  final List<StaffBookingAddonModel> addons;

  // check-in metadata
  final DateTime? checkedInAt;       // bookings.checked_in_at
  final String? checkedInByName;     // bookings.checked_in_by → users.full_name

  // note
  final String? note;                // bookings.note

  const StaffBookingDetailModel({
    required this.id,
    required this.bookingCode,
    this.checkInCode,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    this.customerAvatar,
    required this.courtId,
    required this.courtName,
    required this.isIndoor,
    required this.venueName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.paymentMethod,
    this.paymentStatus = 'PENDING',
    required this.subTotal,
    this.discountAmount = 0,
    this.vatAmount = 0,
    required this.totalAmount,
    this.depositAmount = 0,
    this.addons = const [],
    this.checkedInAt,
    this.checkedInByName,
    this.note,
  });

  double get addonTotal => addons.fold(0, (s, a) => s + a.totalPrice);

  factory StaffBookingDetailModel.fromJson(Map<String, dynamic> j) =>
      StaffBookingDetailModel(
        id: j['id'],
        bookingCode: j['booking_code'],
        checkInCode: j['check_in_code'],
        customerId: j['customer_id'],
        customerName: j['customers']?['full_name'] ?? 'Khách hàng',
        customerPhone: j['customers']?['phone'],
        customerAvatar: j['customers']?['avatar_url'],
        courtId: j['court_id'],
        courtName: j['courts']?['name'] ?? '',
        isIndoor: j['courts']?['is_indoor'] ?? false,
        venueName: j['venues']?['name'] ?? '',
        bookingDate: DateTime.parse(j['booking_date']),
        startTime: _pt(j['start_time']),
        endTime: _pt(j['end_time']),
        status: BookingStatusVS.values.firstWhere(
            (e) => e.name == j['status'], orElse: () => BookingStatusVS.PENDING),
        paymentMethod: j['payment_method'],
        paymentStatus: j['payment_status'] ?? 'PENDING',
        subTotal: (j['sub_total'] as num?)?.toDouble() ?? 0,
        discountAmount: (j['discount_amount'] as num?)?.toDouble() ?? 0,
        vatAmount: (j['vat_amount'] as num?)?.toDouble() ?? 0,
        totalAmount: (j['total_amount'] as num).toDouble(),
        depositAmount: (j['deposit_amount'] as num?)?.toDouble() ?? 0,
        addons: (j['booking_addons'] as List? ?? [])
            .map((a) => StaffBookingAddonModel.fromJson(a))
            .toList(),
        checkedInAt: j['checked_in_at'] != null ? DateTime.tryParse(j['checked_in_at']) : null,
        checkedInByName: j['check_in_staff']?['full_name'],
        note: j['note'],
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
  List<Object?> get props => [id, bookingCode];
}

// ══════════════════════════════════════════════════════════════════════════════
// venue_staff member model — VS-08
// DB: venue_staff + users
// ══════════════════════════════════════════════════════════════════════════════
class VenueStaffMemberModel extends Equatable {
  final String id;                      // venue_staff.id
  final String userId;                  // venue_staff.user_id
  final String fullName;                // users.full_name
  final String? phone;                  // users.phone
  final String? avatarUrl;              // users.avatar_url

  final VenueStaffRole role;            // venue_staff.role
  final bool isActive;                  // venue_staff.is_active
  final DateTime? joinedAt;             // venue_staff.joined_at
  final DateTime? deactivatedAt;        // venue_staff.deactivated_at
  final String? deactivatedByName;

  final String? workStartTime;          // venue_staff.work_start_time HH:mm
  final String? workEndTime;            // venue_staff.work_end_time HH:mm
  final List<String> workDays;          // venue_staff.work_days enum DayOfWeek[]
  final String? note;                   // venue_staff.note

  const VenueStaffMemberModel({
    required this.id,
    required this.userId,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    required this.role,
    required this.isActive,
    this.joinedAt,
    this.deactivatedAt,
    this.deactivatedByName,
    this.workStartTime,
    this.workEndTime,
    this.workDays = const [],
    this.note,
  });

  String get workDaysLabel {
    const map = {'MONDAY':'T2','TUESDAY':'T3','WEDNESDAY':'T4','THURSDAY':'T5','FRIDAY':'T6','SATURDAY':'T7','SUNDAY':'CN'};
    return workDays.map((d) => map[d] ?? d).join(' · ');
  }

  bool get canBeDeactivated => role == VenueStaffRole.STAFF || role == VenueStaffRole.RECEPTIONIST;

  factory VenueStaffMemberModel.fromJson(Map<String, dynamic> j) =>
      VenueStaffMemberModel(
        id: j['id'],
        userId: j['user_id'],
        fullName: j['users']?['full_name'] ?? 'Nhân viên',
        phone: j['users']?['phone'],
        avatarUrl: j['users']?['avatar_url'],
        role: VenueStaffRole.values.firstWhere(
            (e) => e.name == j['role'], orElse: () => VenueStaffRole.STAFF),
        isActive: j['is_active'] ?? true,
        joinedAt: j['joined_at'] != null ? DateTime.tryParse(j['joined_at']) : null,
        deactivatedAt: j['deactivated_at'] != null ? DateTime.tryParse(j['deactivated_at']) : null,
        deactivatedByName: j['deactivator_user']?['full_name'],
        workStartTime: j['work_start_time']?.toString().substring(0, 5),
        workEndTime: j['work_end_time']?.toString().substring(0, 5),
        workDays: List<String>.from(j['work_days'] ?? []),
        note: j['note'],
      );

  @override
  List<Object?> get props => [id, userId];
}
