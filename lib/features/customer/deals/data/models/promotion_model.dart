import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

enum PromotionDiscountType {
  @JsonValue('PERCENTAGE')
  percentage,
  @JsonValue('FIXED_AMOUNT')
  fixedAmount,
}

enum PromotionStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('INACTIVE')
  inactive,
}

@freezed
abstract class PromotionModel with _$PromotionModel {
  const factory PromotionModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_by') String? createdBy,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'discount_type') required PromotionDiscountType discountType,
    @JsonKey(name: 'discount_value') required double discountValue,
    @JsonKey(name: 'max_discount_amount') double? maxDiscountAmount,
    @JsonKey(name: 'min_booking_amount') required double minBookingAmount,
    @JsonKey(name: 'usage_limit') int? usageLimit,
    @JsonKey(name: 'usage_count') required int usageCount,
    @JsonKey(name: 'max_usage_per_user') required int maxUsagePerUser,
    @JsonKey(name: 'is_public') required bool isPublic,
    @JsonKey(name: 'valid_from') required DateTime validFrom,
    @JsonKey(name: 'valid_to') required DateTime validTo,
    required PromotionStatus status,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) => _$PromotionModelFromJson(json);
}

@freezed
abstract class PromotionsResponse with _$PromotionsResponse {
  const factory PromotionsResponse({
    required List<PromotionModel> data,
    required PromotionsMeta meta,
  }) = _PromotionsResponse;

  factory PromotionsResponse.fromJson(Map<String, dynamic> json) => _$PromotionsResponseFromJson(json);
}

@freezed
abstract class PromotionsMeta with _$PromotionsMeta {
  const factory PromotionsMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PromotionsMeta;

  factory PromotionsMeta.fromJson(Map<String, dynamic> json) => _$PromotionsMetaFromJson(json);
}
