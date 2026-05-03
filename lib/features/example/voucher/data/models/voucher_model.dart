import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher_model.freezed.dart';
part 'voucher_model.g.dart';

@freezed
abstract class VoucherModel with _$VoucherModel {
  const factory VoucherModel({
    required String id,
    required String code,
    required String title,
    required double discountAmount,
    required DateTime expiryDate,
    @Default(false) bool isUsed,
  }) = _VoucherModel;

  factory VoucherModel.fromJson(Map<String, dynamic> json) => _$VoucherModelFromJson(json);
}
