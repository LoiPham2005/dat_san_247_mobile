// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

enum PromotionDiscountType {
  @JsonValue('PERCENTAGE')
  PERCENTAGE,
  @JsonValue('FIXED_AMOUNT')
  FIXED_AMOUNT;

  String get label {
    return switch (this) {
      PromotionDiscountType.PERCENTAGE => '%',
      PromotionDiscountType.FIXED_AMOUNT => 'đ',
    };
  }
}

enum PromotionStatus {
  @JsonValue('ACTIVE')
  ACTIVE,
  @JsonValue('INACTIVE')
  INACTIVE,
  @JsonValue('EXPIRED')
  EXPIRED,
  @JsonValue('OUT_OF_STOCK')
  OUT_OF_STOCK
}

@freezed
abstract class PromotionModel with _$PromotionModel {
  const PromotionModel._();

  const factory PromotionModel({
    required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'discount_type') required PromotionDiscountType discountType,
    @JsonKey(name: 'discount_value') required double discountValue,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'min_booking_amount') required double minBookingAmount,
    @JsonKey(name: 'valid_from') required DateTime validFrom,
    @JsonKey(name: 'valid_to') required DateTime validTo,
    required PromotionStatus status,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);

  int get daysLeft {
    final diff = validTo.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }
}
