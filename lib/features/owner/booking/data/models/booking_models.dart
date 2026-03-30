import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

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

@freezed
abstract class OwnerBookingModel with _$OwnerBookingModel {
  const OwnerBookingModel._();

  const factory OwnerBookingModel({
    required String id,
    @JsonKey(name: 'booking_code') required String bookingCode,
    @JsonKey(name: 'check_in_code') String? checkInCode,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @JsonKey(name: 'customer_avatar') String? customerAvatar,
    @JsonKey(name: 'court_id') required String courtId,
    @JsonKey(name: 'court_name') required String courtName,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required BookingStatus status,
    @JsonKey(name: 'total_hours') required double totalHours,
    @JsonKey(name: 'price_per_hour') required double pricePerHour,
    @JsonKey(name: 'sub_total') required double subTotal,
    @JsonKey(name: 'discount_amount') @Default(0) double discountAmount,
    @JsonKey(name: 'vat_amount') @Default(0) double vatAmount,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'commission_amount') @Default(0) double commissionAmount,
    String? note,
    @JsonKey(name: 'promotion_code') String? promotionCode,
    @Default([]) List<OwnerBookingAddonModel> addons,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _OwnerBookingModel;

  factory OwnerBookingModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerBookingModelFromJson(json);

  double get ownerReceives => totalAmount - commissionAmount;
  bool get isPending => status == BookingStatus.PENDING;
  bool get canConfirm => status == BookingStatus.PENDING;
  bool get canCancel => status == BookingStatus.PENDING || status == BookingStatus.CONFIRMED;
}

@freezed
abstract class OwnerBookingAddonModel with _$OwnerBookingAddonModel {
  const factory OwnerBookingAddonModel({
    required String id,
    @JsonKey(name: 'service_name') required String serviceName,
    required int quantity,
    @JsonKey(name: 'price_per_unit') required double pricePerUnit,
    @JsonKey(name: 'total_price') required double totalPrice,
  }) = _OwnerBookingAddonModel;

  factory OwnerBookingAddonModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerBookingAddonModelFromJson(json);
}
