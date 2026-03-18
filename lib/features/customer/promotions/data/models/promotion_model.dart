import 'package:equatable/equatable.dart';

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
      case UNUSED: return 'Chưa dùng';
      case USED: return 'Đã dùng';
      case EXPIRED: return 'Hết hạn';
    }
  }
}

// ── promotions model ───────────────────────────────────────────────────────
class PromotionModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String? description;
  final PromotionDiscountType discountType;
  final double discountValue;
  final double? maxDiscountAmount;
  final double minBookingAmount;
  final int? usageLimit;
  final int usageCount;
  final int maxUsagePerUser;
  final bool isPublic;
  final DateTime validFrom;
  final DateTime validTo;
  final PromotionStatus status;

  const PromotionModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
    required this.minBookingAmount,
    this.usageLimit,
    required this.usageCount,
    required this.maxUsagePerUser,
    required this.isPublic,
    required this.validFrom,
    required this.validTo,
    required this.status,
  });

  bool get isExpired => DateTime.now().isAfter(validTo);
  int get daysLeft => validTo.difference(DateTime.now()).inDays;

  /// Tính discount cho một amount
  double computeDiscount(double amount) {
    if (amount < minBookingAmount) return 0;
    if (discountType == PromotionDiscountType.PERCENTAGE) {
      final d = amount * discountValue / 100;
      return maxDiscountAmount != null && d > maxDiscountAmount! ? maxDiscountAmount! : d;
    }
    return discountValue;
  }

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        description: json['description'],
        discountType: PromotionDiscountType.values.firstWhere(
            (e) => e.name == json['discount_type']),
        discountValue: (json['discount_value'] as num).toDouble(),
        maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
        minBookingAmount: (json['min_booking_amount'] as num?)?.toDouble() ?? 0,
        usageLimit: json['usage_limit'],
        usageCount: json['usage_count'] ?? 0,
        maxUsagePerUser: json['max_usage_per_user'] ?? 1,
        isPublic: json['is_public'] ?? true,
        validFrom: DateTime.parse(json['valid_from']),
        validTo: DateTime.parse(json['valid_to']),
        status: PromotionStatus.values.firstWhere(
            (e) => e.name == json['status'],
            orElse: () => PromotionStatus.ACTIVE),
      );

  @override
  List<Object?> get props => [id, code, status];
}

// ── user_vouchers model ────────────────────────────────────────────────────
class UserVoucherModel extends Equatable {
  final String id;
  final String userId;
  final String promotionId;
  final VoucherStatus status;
  final DateTime? expiresAt;
  final DateTime? usedAt;
  final DateTime createdAt;
  final PromotionModel promotion; // joined

  const UserVoucherModel({
    required this.id,
    required this.userId,
    required this.promotionId,
    required this.status,
    this.expiresAt,
    this.usedAt,
    required this.createdAt,
    required this.promotion,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  int? get daysLeft => expiresAt?.difference(DateTime.now()).inDays;

  factory UserVoucherModel.fromJson(Map<String, dynamic> json) =>
      UserVoucherModel(
        id: json['id'],
        userId: json['user_id'],
        promotionId: json['promotion_id'],
        status: VoucherStatus.values.firstWhere(
            (e) => e.name == json['status']),
        expiresAt: json['expires_at'] != null
            ? DateTime.parse(json['expires_at'])
            : null,
        usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
        createdAt: DateTime.parse(json['created_at']),
        promotion: PromotionModel.fromJson(json['promotions']),
      );

  @override
  List<Object?> get props => [id, status, promotionId];
}
