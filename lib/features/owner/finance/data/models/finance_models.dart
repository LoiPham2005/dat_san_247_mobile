import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_models.freezed.dart';
part 'finance_models.g.dart';

// ── CommissionStatus (schema enum) ───────────────────────────────────────────
enum CommissionStatus { PENDING, APPROVED, PAID, CANCELLED }

extension CommissionStatusX on CommissionStatus {
  String get label => switch (this) {
        CommissionStatus.PENDING => 'Chờ duyệt',
        CommissionStatus.APPROVED => 'Đã duyệt',
        CommissionStatus.PAID => 'Đã thanh toán',
        CommissionStatus.CANCELLED => 'Đã huỷ',
      };
  String get emoji => switch (this) {
        CommissionStatus.PENDING => '⏳',
        CommissionStatus.APPROVED => '✅',
        CommissionStatus.PAID => '💰',
        CommissionStatus.CANCELLED => '❌',
      };
}

// ── PayoutStatus (schema enum) ───────────────────────────────────────────────
enum PayoutStatus { PENDING, PROCESSING, COMPLETED, REJECTED, CANCELLED }

extension PayoutStatusX on PayoutStatus {
  String get label => switch (this) {
        PayoutStatus.PENDING => 'Chờ xử lý',
        PayoutStatus.PROCESSING => 'Đang xử lý',
        PayoutStatus.COMPLETED => 'Hoàn thành',
        PayoutStatus.REJECTED => 'Bị từ chối',
        PayoutStatus.CANCELLED => 'Đã huỷ',
      };
}

// ── commission_records ────────────────────────────────────────────────────────
@freezed
abstract class CommissionRecordModel with _$CommissionRecordModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CommissionRecordModel({
    required String id,
    required String bookingId,
    required String bookingCode,
    required String venueId,
    required String venueName,
    required String ownerId,
    required DateTime bookingDate,
    required String courtName,
    required String customerName,
    required double bookingAmount,
    required double commissionRate,
    required double commissionAmount,
    required double ownerReceives,
    required CommissionStatus status,
    DateTime? paidAt,
    required DateTime createdAt,
  }) = _CommissionRecordModel;

  const CommissionRecordModel._();

  factory CommissionRecordModel.fromJson(Map<String, dynamic> json) =>
      _$CommissionRecordModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── wallets ───────────────────────────────────────────────────────────────────
@freezed
abstract class WalletModel with _$WalletModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory WalletModel({
    required String id,
    required String userId,
    required double balance,
    @Default(0) double lockedBalance,
    @Default(true) bool isActive,
    @Default([]) List<BankAccountModel> bankAccounts,
    required DateTime updatedAt,
  }) = _WalletModel;

  const WalletModel._();

  double get availableBalance => balance - lockedBalance;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── payout_bank_accounts ──────────────────────────────────────────────────────
@freezed
abstract class BankAccountModel with _$BankAccountModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BankAccountModel({
    required String id,
    required String walletId,
    required String bankName,
    required String bankCode,
    required String accountNumber,
    required String accountName,
    @Default(false) bool isDefault,
  }) = _BankAccountModel;

  const BankAccountModel._();

  String get maskedAccount => accountNumber.length > 4
      ? '****${accountNumber.substring(accountNumber.length - 4)}'
      : accountNumber;

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      _$BankAccountModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── payout_requests ───────────────────────────────────────────────────────────
@freezed
abstract class PayoutRequestModel with _$PayoutRequestModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PayoutRequestModel({
    required String id,
    required String userId,
    required double amount,
    required PayoutStatus status,
    required String bankAccountId,
    required String bankAccountName,
    required String bankName,
    String? adminNote,
    String? rejectionReason,
    DateTime? processedAt,
    required DateTime createdAt,
  }) = _PayoutRequestModel;

  const PayoutRequestModel._();

  factory PayoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── Revenue summary (computed) ────────────────────────────────────────────────
@freezed
abstract class RevenueSummaryModel with _$RevenueSummaryModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RevenueSummaryModel({
    required String month, // 'YYYY-MM'
    required int bookingCount,
    required double totalBookingAmount,
    required double totalCommissionAmount,
    required double totalOwnerReceives,
    required double paidAmount,
    required double pendingAmount,
  }) = _RevenueSummaryModel;

  const RevenueSummaryModel._();

  factory RevenueSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueSummaryModelFromJson(json);

  Map<String, dynamic> toJson();
}
