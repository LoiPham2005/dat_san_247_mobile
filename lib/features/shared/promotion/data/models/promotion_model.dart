// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

enum PromotionDiscountType { PERCENTAGE, FIXED_AMOUNT }
enum PromotionStatus { ACTIVE, INACTIVE, EXPIRED }

@freezed
abstract class PromotionModel with _$PromotionModel {
  const factory PromotionModel({
    required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'discount_type') required PromotionDiscountType discountType,
    @JsonKey(name: 'discount_value') required double discountValue,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'min_booking_amount') @Default(0) double minBookingAmount,
    @JsonKey(name: 'usage_limit') int? usageLimit,
    @JsonKey(name: 'usage_count') @Default(0) int usageCount,
    @JsonKey(name: 'max_usage_per_user') @Default(1) int maxUsagePerUser,
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,
    @JsonKey(name: 'valid_from') required DateTime validFrom,
    @JsonKey(name: 'valid_to') required DateTime validTo,
    @Default(PromotionStatus.ACTIVE) PromotionStatus status,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);
}
