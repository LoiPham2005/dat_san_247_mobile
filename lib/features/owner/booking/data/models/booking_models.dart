import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

// ── booking (owner view) ─────────────────────────────────────────────────────
enum BookingStatus {
  PENDING,
  CONFIRMED,
  CHECKED_IN,
  COMPLETED,
  CANCELLED,
  NO_SHOW
}

extension BookingStatusX on BookingStatus {
  String get label => switch (this) {
        BookingStatus.PENDING => 'Chờ xác nhận',
        BookingStatus.CONFIRMED => 'Đã xác nhận',
        BookingStatus.CHECKED_IN => 'Check-in',
        BookingStatus.COMPLETED => 'Hoàn thành',
        BookingStatus.CANCELLED => 'Đã hủy',
        BookingStatus.NO_SHOW => 'Vắng mặt',
      };
  String get emoji => switch (this) {
        BookingStatus.PENDING => '⏳',
        BookingStatus.CONFIRMED => '✅',
        BookingStatus.CHECKED_IN => '🏃',
        BookingStatus.COMPLETED => '🏁',
        BookingStatus.CANCELLED => '❌',
        BookingStatus.NO_SHOW => '👻',
      };
}

@freezed
abstract class OwnerBookingModel with _$OwnerBookingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerBookingModel({
    required String id,
    required String bookingCode,
    String? checkInCode,
    required String customerId,
    required String customerName,
    String? customerPhone,
    String? customerAvatar,
    required String courtId,
    required String courtName,
    required String venueId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required BookingStatus status,
    required double totalHours,
    required double pricePerHour,
    required double subTotal,
    @Default(0) double discountAmount,
    @Default(0) double vatAmount,
    required double totalAmount,
    @Default(0) double commissionAmount,
    String? note,
    String? promotionCode,
    @Default([]) List<OwnerBookingAddonModel> addons,
    required DateTime createdAt,
  }) = _OwnerBookingModel;

  const OwnerBookingModel._();

  double get ownerReceives => totalAmount - commissionAmount;
  bool get isPending => status == BookingStatus.PENDING;
  bool get canConfirm => status == BookingStatus.PENDING;
  bool get canCancel =>
      status == BookingStatus.PENDING || status == BookingStatus.CONFIRMED;

  factory OwnerBookingModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerBookingModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class OwnerBookingAddonModel with _$OwnerBookingAddonModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerBookingAddonModel({
    required String id,
    required String serviceName,
    required int quantity,
    required double pricePerUnit,
    required double totalPrice,
  }) = _OwnerBookingAddonModel;

  const OwnerBookingAddonModel._();

  factory OwnerBookingAddonModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerBookingAddonModelFromJson(json);

  Map<String, dynamic> toJson();
}
