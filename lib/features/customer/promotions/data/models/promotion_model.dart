import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

// ── Enums (schema.prisma) ──────────────────────────────────────────────────

enum PromotionDiscountType {
  PERCENTAGE,
  FIXED_AMOUNT;

  String get label => this == PERCENTAGE ? '%' : 'đ';
}

enum PromotionStatus { ACTIVE, INACTIVE, EXPIRED }

enum VoucherStatus {
  UNUSED,
  USED,
  EXPIRED;

  String get label {
    switch (this) {
      case UNUSED:
        return 'Chưa dùng';
      case USED:
        return 'Đã dùng';
      case EXPIRED:
        return 'Hết hạn';
    }
  }
}

// ── promotions model ───────────────────────────────────────────────────────
@freezed
abstract class PromotionModel with _$PromotionModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PromotionModel({
    required String id,
    required String code,
    required String name,
    String? description,
    required PromotionDiscountType discountType,
    required double discountValue,
    double? maxDiscountAmount,
    @Default(0) double minBookingAmount,
    int? usageLimit,
    @Default(0) int usageCount,
    @Default(1) int maxUsagePerUser,
    @Default(true) bool isPublic,
    required DateTime validFrom,
    required DateTime validTo,
    @Default(PromotionStatus.ACTIVE) PromotionStatus status,
  }) = _PromotionModel;

  const PromotionModel._();

  bool get isExpired => DateTime.now().isAfter(validTo);
  int get daysLeft => validTo.difference(DateTime.now()).inDays;

  /// Tính discount cho một amount
  double computeDiscount(double amount) {
    if (amount < minBookingAmount) return 0;
    if (discountType == PromotionDiscountType.PERCENTAGE) {
      final d = amount * discountValue / 100;
      return maxDiscountAmount != null && d > maxDiscountAmount!
          ? maxDiscountAmount!
          : d;
    }
    return discountValue;
  }

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── user_vouchers model ────────────────────────────────────────────────────
@freezed
abstract class UserVoucherModel with _$UserVoucherModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory UserVoucherModel({
    required String id,
    required String userId,
    required String promotionId,
    required VoucherStatus status,
    DateTime? expiresAt,
    DateTime? usedAt,
    required DateTime createdAt,
    required PromotionModel promotion,
  }) = _UserVoucherModel;

  const UserVoucherModel._();

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  int? get daysLeft => expiresAt?.difference(DateTime.now()).inDays;

  factory UserVoucherModel.fromJson(Map<String, dynamic> json) =>
      _$UserVoucherModelFromJson(json);

  Map<String, dynamic> toJson();
}
