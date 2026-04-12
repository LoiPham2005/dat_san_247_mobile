import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType {
  DEPOSIT,
  PAYMENT,
  REFUND,
  PAYOUT,
  COMMISSION,
  ADJUSTMENT;

  String get label {
    switch (this) {
      case DEPOSIT: return 'Nạp tiền';
      case PAYMENT: return 'Thanh toán';
      case REFUND: return 'Hoàn tiền';
      case PAYOUT: return 'Rút tiền';
      case COMMISSION: return 'Hoa hồng';
      case ADJUSTMENT: return 'Điều chỉnh';
    }
  }

  bool get isCredit => this == DEPOSIT || this == REFUND || this == ADJUSTMENT;
}

enum TransactionStatus { PENDING, COMPLETED, FAILED, CANCELLED }

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required TransactionType type,
    @Default(0.0) double amount,
    @JsonKey(name: 'balance_after') @Default(0.0) double balanceAfter,
    required TransactionStatus status,
    String? description,
    @JsonKey(name: 'booking_id') String? bookingId,
    @JsonKey(name: 'booking_code') String? bookingCode,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
