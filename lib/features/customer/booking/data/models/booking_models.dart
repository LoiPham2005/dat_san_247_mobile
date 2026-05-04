// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_models.g.dart';

double _parsePrice(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? 0;
  return 0;
}

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
@JsonSerializable()
class PricingRuleModel extends Equatable {
  final String id;
  @JsonKey(name: 'court_id')
  final String courtId;
  final String? name;
  @JsonKey(name: 'day_of_week')
  final String? dayOfWeek; // MONDAY..SUNDAY | null = all days
  @JsonKey(name: 'start_time')
  final String startTime;  // HH:mm
  @JsonKey(name: 'end_time')
  final String endTime;    // HH:mm
  @JsonKey(fromJson: _parsePrice)
  final double price;
  final int priority;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const PricingRuleModel({
    required this.id,
    required this.courtId,
    this.name,
    this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.price,
    this.priority = 1,
    this.isActive = true,
  });

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) => _$PricingRuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$PricingRuleModelToJson(this);

  @override
  List<Object?> get props => [id, courtId, startTime, endTime, price, priority];
}

// ── venue_services ─────────────────────────────────────────────────────────
@JsonSerializable()
class VenueServiceModel extends Equatable {
  final String id;
  @JsonKey(name: 'venue_id')
  final String venueId;
  final String name;
  final String? description;
  @JsonKey(fromJson: _parsePrice)
  final double price;
  final String unit;   // UNIT | HOUR | SESSION | PERSON | SET
  final String type;   // PRODUCT | SERVICE
  final String? category;
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @JsonKey(name: 'track_inventory')
  final bool trackInventory;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;

  const VenueServiceModel({
    required this.id,
    required this.venueId,
    required this.name,
    this.description,
    required this.price,
    this.unit = 'UNIT',
    this.type = 'SERVICE',
    this.category,
    this.isAvailable = true,
    this.trackInventory = false,
    this.stockQuantity = 0,
  });

  factory VenueServiceModel.fromJson(Map<String, dynamic> json) => _$VenueServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueServiceModelToJson(this);

  @override
  List<Object?> get props => [id, venueId, name, price];
}

// ── booking_addons (selected services) ────────────────────────────────────
@JsonSerializable()
class BookingAddonModel extends Equatable {
  @JsonKey(name: 'service_id')
  final String serviceId;
  final String name;
  @JsonKey(fromJson: _parsePrice)
  final double pricePerUnit;
  final int quantity; // final → fix @immutable lint
  final String unit;

  const BookingAddonModel({
    required this.serviceId,
    required this.name,
    required this.pricePerUnit,
    this.quantity = 1,
    this.unit = 'UNIT',
  });

  double get totalPrice => pricePerUnit * quantity;

  /// Tạo bản sao với số lượng mới (thay thế mutation trực tiếp)
  BookingAddonModel copyWith({int? quantity}) => BookingAddonModel(
        serviceId: serviceId,
        name: name,
        pricePerUnit: pricePerUnit,
        quantity: quantity ?? this.quantity,
        unit: unit,
      );

  factory BookingAddonModel.fromJson(Map<String, dynamic> json) => _$BookingAddonModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingAddonModelToJson(this);

  @override
  List<Object?> get props => [serviceId, quantity];
}


// ── promotions ────────────────────────────────────────────────────────────
@JsonSerializable()
class PromotionModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String? description;
  @JsonKey(name: 'discount_type')
  final String discountType;  // PERCENTAGE | FIXED_AMOUNT
  @JsonKey(name: 'discount_value', fromJson: _parsePrice)
  final double discountValue;
  @JsonKey(name: 'max_discount_amount', fromJson: _parsePrice)
  final double? maxDiscountAmount;
  @JsonKey(name: 'min_booking_amount', fromJson: _parsePrice)
  final double minBookingAmount;
  @JsonKey(name: 'valid_from')
  final DateTime validFrom;
  @JsonKey(name: 'valid_to')
  final DateTime validTo;
  final String status;  // ACTIVE | INACTIVE | EXPIRED

  const PromotionModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
    this.minBookingAmount = 0,
    required this.validFrom,
    required this.validTo,
    this.status = 'ACTIVE',
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);

  @override
  List<Object?> get props => [id, code];
}

// ── refund_rules ─────────────────────────────────────────────────────────
@JsonSerializable()
class RefundRuleModel extends Equatable {
  @JsonKey(name: 'cancel_before_hours')
  final int cancelBeforeHours;
  @JsonKey(name: 'refund_percentage')
  final double refundPercentage;
  final String? description;

  const RefundRuleModel({
    required this.cancelBeforeHours,
    required this.refundPercentage,
    this.description,
  });

  factory RefundRuleModel.fromJson(Map<String, dynamic> json) => _$RefundRuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RefundRuleModelToJson(this);

  @override
  List<Object?> get props => [cancelBeforeHours, refundPercentage];
}

// ── BookingRequest (submit lên API) ───────────────────────────────────────
@JsonSerializable()
class BookingRequestModel {
  @JsonKey(name: 'court_id')
  final String courtId;
  @JsonKey(name: 'venue_id')
  final String venueId;
  @JsonKey(name: 'booking_date')
  final String bookingDate; // yyyy-MM-dd
  @JsonKey(name: 'start_time')
  final String startTime;  // HH:mm
  @JsonKey(name: 'end_time')
  final String endTime;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'promotion_code')
  final String? promotionCode;
  final String? note;
  final List<BookingAddonModel> addons;

  BookingRequestModel({
    required this.courtId,
    required this.venueId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.paymentMethod,
    this.promotionCode,
    this.note,
    this.addons = const [],
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) => _$BookingRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingRequestModelToJson(this);
}

// ── BookingConfirmation (response sau khi tạo booking) ───────────────────
@JsonSerializable()
class BookingConfirmationModel extends Equatable {
  final String id;
  @JsonKey(name: 'booking_code')
  final String bookingCode;
  @JsonKey(name: 'check_in_code')
  final String? checkInCode;
  @JsonKey(name: 'venue_name')
  final String venueName;
  @JsonKey(name: 'court_name')
  final String courtName;
  @JsonKey(name: 'venue_address')
  final String venueAddress;
  @JsonKey(name: 'booking_date')
  final String bookingDate;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  @JsonKey(name: 'total_amount', fromJson: _parsePrice)
  final double totalAmount;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  final String status;

  const BookingConfirmationModel({
    required this.id,
    required this.bookingCode,
    this.checkInCode,
    required this.venueName,
    required this.courtName,
    required this.venueAddress,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.paymentMethod,
    this.status = 'PENDING',
  });

  factory BookingConfirmationModel.fromJson(Map<String, dynamic> json) => _$BookingConfirmationModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingConfirmationModelToJson(this);

  @override
  List<Object?> get props => [id, bookingCode];
}
