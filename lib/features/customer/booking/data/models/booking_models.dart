import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

// ── Enums (mirrors schema.prisma) ─────────────────────────────────────────

enum BookingStatus {
  PENDING,
  CONFIRMED,
  CHECKED_IN,
  COMPLETED,
  CANCELLED,
  NO_SHOW,
}

enum PaymentStatus {
  PENDING,
  PAID,
  FAILED,
  REFUNDED,
  PARTIALLY_REFUNDED,
}

enum PaymentMethod {
  CASH,
  VNPAY,
  MOMO,
  ZALOPAY,
  BANK_TRANSFER,
  WALLET,
}

// ── pricing_rules ─────────────────────────────────────────────────────────
@freezed
abstract class PricingRuleModel with _$PricingRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PricingRuleModel({
    required String id,
    required String courtId,
    String? name,
    String? dayOfWeek, // MONDAY..SUNDAY | null = all days
    required String startTime, // HH:mm
    required String endTime, // HH:mm
    required double price,
    @Default(1) int priority,
    @Default(true) bool isActive,
  }) = _PricingRuleModel;

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) =>
      _$PricingRuleModelFromJson(json);
}

// ── venue_services ─────────────────────────────────────────────────────────
@freezed
abstract class VenueServiceModel with _$VenueServiceModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory VenueServiceModel({
    required String id,
    required String venueId,
    required String name,
    String? description,
    required double price,
    @Default('UNIT') String unit, // UNIT | HOUR | SESSION | PERSON | SET
    @Default('SERVICE') String type, // PRODUCT | SERVICE
    String? category,
    @Default(true) bool isAvailable,
    @Default(false) bool trackInventory,
    @Default(0) int stockQuantity,
  }) = _VenueServiceModel;

  factory VenueServiceModel.fromJson(Map<String, dynamic> json) =>
      _$VenueServiceModelFromJson(json);
}

// ── booking_addons (selected services) ────────────────────────────────────
@freezed
abstract class BookingAddonModel with _$BookingAddonModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BookingAddonModel({
    required String serviceId,
    required String name,
    required double pricePerUnit,
    @Default(1) int quantity,
    @Default('UNIT') String unit,
  }) = _BookingAddonModel;

  const BookingAddonModel._();

  double get totalPrice => pricePerUnit * quantity;

  factory BookingAddonModel.fromJson(Map<String, dynamic> json) =>
      _$BookingAddonModelFromJson(json);
}

// ── promotions ────────────────────────────────────────────────────────────
@freezed
abstract class PromotionModel with _$PromotionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PromotionModel({
    required String id,
    required String code,
    required String name,
    String? description,
    required String discountType, // PERCENTAGE | FIXED_AMOUNT
    required double discountValue,
    double? maxDiscountAmount,
    @Default(0) double minBookingAmount,
    required DateTime validFrom,
    required DateTime validTo,
    @Default('ACTIVE') String status, // ACTIVE | INACTIVE | EXPIRED
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}

// ── refund_rules ─────────────────────────────────────────────────────────
@freezed
abstract class RefundRuleModel with _$RefundRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RefundRuleModel({
    required int cancelBeforeHours,
    required double refundPercentage,
    String? description,
  }) = _RefundRuleModel;

  factory RefundRuleModel.fromJson(Map<String, dynamic> json) =>
      _$RefundRuleModelFromJson(json);
}

// ── BookingRequest (submit lên API) ───────────────────────────────────────
@freezed
abstract class BookingRequestModel with _$BookingRequestModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BookingRequestModel({
    required String courtId,
    required String venueId,
    required String bookingDate, // yyyy-MM-dd
    required String startTime, // HH:mm
    required String endTime,
    required String paymentMethod,
    String? promotionCode,
    String? note,
    @Default([]) List<BookingAddonModel> addons,
  }) = _BookingRequestModel;

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestModelFromJson(json);
}

// ── BookingConfirmation (response sau khi tạo booking) ───────────────────
@freezed
abstract class BookingConfirmationModel with _$BookingConfirmationModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BookingConfirmationModel({
    required String id,
    required String bookingCode,
    String? checkInCode,
    required String venueName,
    required String courtName,
    required String venueAddress,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required double totalAmount,
    required String paymentMethod,
    @Default('PENDING') String status,
  }) = _BookingConfirmationModel;

  factory BookingConfirmationModel.fromJson(Map<String, dynamic> json) =>
      _$BookingConfirmationModelFromJson(json);
}
