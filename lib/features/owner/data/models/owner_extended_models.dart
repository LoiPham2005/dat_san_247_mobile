// // ══════════════════════════════════════════════════════════════════════════════
// // Owner Extended Models — O-06 to O-10
// // Based on schema.prisma
// // ══════════════════════════════════════════════════════════════════════════════
// import 'package:dat_san_247_mobile/features/owner/data/models/owner_models.dart';

// // ── VenueServiceType (from schema enum) ──────────────────────────────────────
// enum VenueServiceType { PRODUCT, SERVICE }

// extension VenueServiceTypeX on VenueServiceType {
//   String get label => switch (this) {
//     VenueServiceType.PRODUCT => 'Sản phẩm',
//     VenueServiceType.SERVICE => 'Dịch vụ',
//   };
//   String get emoji => switch (this) {
//     VenueServiceType.PRODUCT => '📦',
//     VenueServiceType.SERVICE => '🛎️',
//   };
// }

// // ── ServiceUnit (from schema enum) ───────────────────────────────────────────
// enum ServiceUnit { UNIT, HOUR, SESSION, PERSON, SET }

// extension ServiceUnitX on ServiceUnit {
//   String get label => switch (this) {
//     ServiceUnit.UNIT    => 'cái',
//     ServiceUnit.HOUR    => 'giờ',
//     ServiceUnit.SESSION => 'buổi',
//     ServiceUnit.PERSON  => 'người',
//     ServiceUnit.SET     => 'bộ',
//   };
// }

// // ── venue_services model ──────────────────────────────────────────────────────
// class VenueServiceModel {
//   final String id;
//   final String venueId;
//   final String name;
//   final String? description;
//   final double price;
//   final ServiceUnit unit;
//   final VenueServiceType type;
//   final String? category;
//   final bool isAvailable;
//   final bool trackInventory;
//   final int stockQuantity;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   const VenueServiceModel({
//     required this.id,
//     required this.venueId,
//     required this.name,
//     this.description,
//     required this.price,
//     this.unit = ServiceUnit.UNIT,
//     this.type = VenueServiceType.SERVICE,
//     this.category,
//     this.isAvailable = true,
//     this.trackInventory = false,
//     this.stockQuantity = 0,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   VenueServiceModel copyWith({
//     String? name, String? description, double? price, ServiceUnit? unit,
//     VenueServiceType? type, String? category, bool? isAvailable,
//     bool? trackInventory, int? stockQuantity,
//   }) => VenueServiceModel(
//     id: id, venueId: venueId,
//     name: name ?? this.name, description: description ?? this.description,
//     price: price ?? this.price, unit: unit ?? this.unit, type: type ?? this.type,
//     category: category ?? this.category, isAvailable: isAvailable ?? this.isAvailable,
//     trackInventory: trackInventory ?? this.trackInventory, stockQuantity: stockQuantity ?? this.stockQuantity,
//     createdAt: createdAt, updatedAt: DateTime.now(),
//   );

//   bool get isLowStock => trackInventory && stockQuantity <= 3 && stockQuantity > 0;
//   bool get isOutOfStock => trackInventory && stockQuantity <= 0;
// }

// // ── refund_policies + refund_rules ───────────────────────────────────────────
// class RefundRuleModel {
//   final String id;
//   final String policyId;
//   final int cancelBeforeHours;
//   final double refundPercentage; // 0–100
//   final String? description;

//   const RefundRuleModel({
//     required this.id, required this.policyId,
//     required this.cancelBeforeHours, required this.refundPercentage,
//     this.description,
//   });

//   String get label {
//     if (cancelBeforeHours >= 24) return 'Hủy trước ${cancelBeforeHours ~/ 24} ngày';
//     return 'Hủy trước ${cancelBeforeHours}h';
//   }
// }

// class RefundPolicyModel {
//   final String id;
//   final String? venueId;
//   final String name;
//   final String? description;
//   final bool isActive;
//   final bool isDefault;
//   final List<RefundRuleModel> rules;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   const RefundPolicyModel({
//     required this.id, this.venueId, required this.name,
//     this.description, this.isActive = true, this.isDefault = false,
//     this.rules = const [], required this.createdAt, required this.updatedAt,
//   });

//   RefundPolicyModel copyWith({
//     String? name, String? description, bool? isActive, bool? isDefault,
//     List<RefundRuleModel>? rules,
//   }) => RefundPolicyModel(
//     id: id, venueId: venueId,
//     name: name ?? this.name, description: description ?? this.description,
//     isActive: isActive ?? this.isActive, isDefault: isDefault ?? this.isDefault,
//     rules: rules ?? this.rules, createdAt: createdAt, updatedAt: DateTime.now(),
//   );
// }

// // ── booking (owner view) ─────────────────────────────────────────────────────
// enum BookingStatus { PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED, NO_SHOW }

// extension BookingStatusX on BookingStatus {
//   String get label => switch (this) {
//     BookingStatus.PENDING    => 'Chờ xác nhận',
//     BookingStatus.CONFIRMED  => 'Đã xác nhận',
//     BookingStatus.CHECKED_IN => 'Check-in',
//     BookingStatus.COMPLETED  => 'Hoàn thành',
//     BookingStatus.CANCELLED  => 'Đã hủy',
//     BookingStatus.NO_SHOW    => 'Vắng mặt',
//   };
//   String get emoji => switch (this) {
//     BookingStatus.PENDING    => '⏳',
//     BookingStatus.CONFIRMED  => '✅',
//     BookingStatus.CHECKED_IN => '🏃',
//     BookingStatus.COMPLETED  => '🏁',
//     BookingStatus.CANCELLED  => '❌',
//     BookingStatus.NO_SHOW    => '👻',
//   };
// }

// class OwnerBookingModel {
//   final String id;
//   final String bookingCode;
//   final String? checkInCode;
//   final String customerId;
//   final String customerName;
//   final String? customerPhone;
//   final String? customerAvatar;
//   final String courtId;
//   final String courtName;
//   final String venueId;
//   final DateTime bookingDate;
//   final String startTime;
//   final String endTime;
//   final BookingStatus status;
//   final double totalHours;
//   final double pricePerHour;
//   final double subTotal;
//   final double discountAmount;
//   final double vatAmount;
//   final double totalAmount;
//   final double commissionAmount;
//   final String? note;
//   final String? promotionCode;
//   final List<OwnerBookingAddonModel> addons;
//   final DateTime createdAt;

//   const OwnerBookingModel({
//     required this.id, required this.bookingCode, this.checkInCode,
//     required this.customerId, required this.customerName, this.customerPhone, this.customerAvatar,
//     required this.courtId, required this.courtName, required this.venueId,
//     required this.bookingDate, required this.startTime, required this.endTime,
//     required this.status, required this.totalHours, required this.pricePerHour,
//     required this.subTotal, this.discountAmount = 0, this.vatAmount = 0,
//     required this.totalAmount, this.commissionAmount = 0,
//     this.note, this.promotionCode, this.addons = const [], required this.createdAt,
//   });

//   double get ownerReceives => totalAmount - commissionAmount;
//   bool get isPending => status == BookingStatus.PENDING;
//   bool get canConfirm => status == BookingStatus.PENDING;
//   bool get canCancel => status == BookingStatus.PENDING || status == BookingStatus.CONFIRMED;
// }

// class OwnerBookingAddonModel {
//   final String id;
//   final String serviceName;
//   final int quantity;
//   final double pricePerUnit;
//   final double totalPrice;

//   const OwnerBookingAddonModel({
//     required this.id, required this.serviceName,
//     required this.quantity, required this.pricePerUnit, required this.totalPrice,
//   });
// }

// // ── venue_staff (owner view) ──────────────────────────────────────────────────
// enum StaffRole { OWNER, MANAGER, STAFF, RECEPTIONIST }

// extension StaffRoleX on StaffRole {
//   String get label => switch (this) {
//     StaffRole.OWNER        => 'Chủ sân',
//     StaffRole.MANAGER      => 'Quản lý',
//     StaffRole.STAFF        => 'Nhân viên',
//     StaffRole.RECEPTIONIST => 'Lễ tân',
//   };
//   String get emoji => switch (this) {
//     StaffRole.OWNER        => '👑',
//     StaffRole.MANAGER      => '🎯',
//     StaffRole.STAFF        => '👷',
//     StaffRole.RECEPTIONIST => '🙋',
//   };
//   int get level => switch (this) {
//     StaffRole.OWNER => 4, StaffRole.MANAGER => 3,
//     StaffRole.STAFF => 2, StaffRole.RECEPTIONIST => 1,
//   };
// }

// enum StaffInviteStatus { PENDING, ACCEPTED, REJECTED, EXPIRED, REVOKED }

// extension StaffInviteStatusX on StaffInviteStatus {
//   String get label => switch (this) {
//     StaffInviteStatus.PENDING  => 'Chờ phản hồi',
//     StaffInviteStatus.ACCEPTED => 'Đã chấp nhận',
//     StaffInviteStatus.REJECTED => 'Đã từ chối',
//     StaffInviteStatus.EXPIRED  => 'Hết hạn',
//     StaffInviteStatus.REVOKED  => 'Đã thu hồi',
//   };
// }

// class OwnerStaffModel {
//   final String id;
//   final String venueId;
//   final String userId;
//   final String fullName;
//   final String? email;
//   final String? phone;
//   final String? avatarUrl;
//   final StaffRole role;
//   final bool isActive;
//   final String? invitedBy;
//   final DateTime? joinedAt;
//   final DateTime? deactivatedAt;
//   final String? workStartTime;
//   final String? workEndTime;
//   final List<OwnerDayOfWeek> workDays;
//   final String? note;
//   final DateTime createdAt;

//   const OwnerStaffModel({
//     required this.id, required this.venueId, required this.userId,
//     required this.fullName, this.email, this.phone, this.avatarUrl,
//     required this.role, this.isActive = true, this.invitedBy,
//     this.joinedAt, this.deactivatedAt, this.workStartTime, this.workEndTime,
//     this.workDays = const [], this.note, required this.createdAt,
//   });
// }

// class StaffInviteModel {
//   final String id;
//   final String venueId;
//   final String inviteEmail;
//   final StaffRole role;
//   final StaffInviteStatus status;
//   final String? message;
//   final DateTime expiresAt;
//   final DateTime createdAt;

//   const StaffInviteModel({
//     required this.id, required this.venueId, required this.inviteEmail,
//     required this.role, required this.status, this.message,
//     required this.expiresAt, required this.createdAt,
//   });

//   bool get isExpired => DateTime.now().isAfter(expiresAt);
// }
