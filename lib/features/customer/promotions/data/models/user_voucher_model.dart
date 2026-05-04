// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_voucher_model.freezed.dart';
part 'user_voucher_model.g.dart';

enum VoucherStatus {
  @JsonValue('UNUSED')
  UNUSED,
  @JsonValue('USED')
  USED,
  @JsonValue('EXPIRED')
  EXPIRED;

  String get label {
    return switch (this) {
      VoucherStatus.UNUSED => 'Chưa dùng',
      VoucherStatus.USED => 'Đã dùng',
      VoucherStatus.EXPIRED => 'Hết hạn',
    };
  }
}

@freezed
abstract class UserVoucherModel with _$UserVoucherModel {
  const factory UserVoucherModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'promotion_id') required String promotionId,
    required VoucherStatus status,
    @JsonKey(name: 'used_at') DateTime? usedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required PromotionModel promotion,
  }) = _UserVoucherModel;

  factory UserVoucherModel.fromJson(Map<String, dynamic> json) => _$UserVoucherModelFromJson(json);
}
