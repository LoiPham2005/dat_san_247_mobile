import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default(0.0) double balance,
    @JsonKey(name: 'locked_balance') @Default(0.0) double lockedBalance,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

extension WalletModelExt on WalletModel {
  double get availableBalance => balance - lockedBalance;
}
