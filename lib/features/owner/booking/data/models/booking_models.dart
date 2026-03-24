
// ── booking (owner view) ─────────────────────────────────────────────────────
enum BookingStatus { PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED, NO_SHOW }

extension BookingStatusX on BookingStatus {
  String get label => switch (this) {
    BookingStatus.PENDING    => 'Chờ xác nhận',
    BookingStatus.CONFIRMED  => 'Đã xác nhận',
    BookingStatus.CHECKED_IN => 'Check-in',
    BookingStatus.COMPLETED  => 'Hoàn thành',
    BookingStatus.CANCELLED  => 'Đã hủy',
    BookingStatus.NO_SHOW    => 'Vắng mặt',
  };
  String get emoji => switch (this) {
    BookingStatus.PENDING    => '⏳',
    BookingStatus.CONFIRMED  => '✅',
    BookingStatus.CHECKED_IN => '🏃',
    BookingStatus.COMPLETED  => '🏁',
    BookingStatus.CANCELLED  => '❌',
    BookingStatus.NO_SHOW    => '👻',
  };
}

class OwnerBookingModel {
  final String id;
  final String bookingCode;
  final String? checkInCode;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String? customerAvatar;
  final String courtId;
  final String courtName;
  final String venueId;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final BookingStatus status;
  final double totalHours;
  final double pricePerHour;
  final double subTotal;
  final double discountAmount;
  final double vatAmount;
  final double totalAmount;
  final double commissionAmount;
  final String? note;
  final String? promotionCode;
  final List<OwnerBookingAddonModel> addons;
  final DateTime createdAt;

  const OwnerBookingModel({
    required this.id, required this.bookingCode, this.checkInCode,
    required this.customerId, required this.customerName, this.customerPhone, this.customerAvatar,
    required this.courtId, required this.courtName, required this.venueId,
    required this.bookingDate, required this.startTime, required this.endTime,
    required this.status, required this.totalHours, required this.pricePerHour,
    required this.subTotal, this.discountAmount = 0, this.vatAmount = 0,
    required this.totalAmount, this.commissionAmount = 0,
    this.note, this.promotionCode, this.addons = const [], required this.createdAt,
  });

  double get ownerReceives => totalAmount - commissionAmount;
  bool get isPending => status == BookingStatus.PENDING;
  bool get canConfirm => status == BookingStatus.PENDING;
  bool get canCancel => status == BookingStatus.PENDING || status == BookingStatus.CONFIRMED;
}

class OwnerBookingAddonModel {
  final String id;
  final String serviceName;
  final int quantity;
  final double pricePerUnit;
  final double totalPrice;

  const OwnerBookingAddonModel({
    required this.id, required this.serviceName,
    required this.quantity, required this.pricePerUnit, required this.totalPrice,
  });
}
