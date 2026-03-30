import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_models.freezed.dart';
part 'finance_models.g.dart';

// ── Helper for String/Num to Double ──────────────────────────────────────────
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// ── CommissionStatus ───────────────────────────────────────────────
@JsonEnum(alwaysCreate: true)
enum CommissionStatus { PENDING, APPROVED, PAID, CANCELLED }

extension CommissionStatusX on CommissionStatus {
  String get label => switch (this) {
    CommissionStatus.PENDING   => 'Chờ duyệt',
    CommissionStatus.APPROVED  => 'Đã duyệt',
    CommissionStatus.PAID      => 'Đã thanh toán',
    CommissionStatus.CANCELLED => 'Đã huỷ',
  };
  String get emoji => switch (this) {
    CommissionStatus.PENDING   => '⏳',
    CommissionStatus.APPROVED  => '✅',
    CommissionStatus.PAID      => '💰',
    CommissionStatus.CANCELLED => '❌',
  };
}

// ── PayoutStatus ───────────────────────────────────────────────────
@JsonEnum(alwaysCreate: true)
enum PayoutStatus { PENDING, PROCESSING, COMPLETED, REJECTED, CANCELLED }

extension PayoutStatusX on PayoutStatus {
  String get label => switch (this) {
    PayoutStatus.PENDING    => 'Chờ xử lý',
    PayoutStatus.PROCESSING => 'Đang xử lý',
    PayoutStatus.COMPLETED  => 'Hoàn thành',
    PayoutStatus.REJECTED   => 'Bị từ chối',
    PayoutStatus.CANCELLED  => 'Đã huỷ',
  };
}

// ── CommissionRecordModel ─────────────────────────────────────────────
@freezed
abstract class CommissionRecordModel with _$CommissionRecordModel {
  const factory CommissionRecordModel({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'booking_code') required String bookingCode,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'venue_name') required String venueName,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'court_name') required String courtName,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'booking_amount', fromJson: _toDouble) required double bookingAmount,
    @JsonKey(name: 'commission_rate', fromJson: _toDouble) required double commissionRate,
    @JsonKey(name: 'commission_amount', fromJson: _toDouble) required double commissionAmount,
    @JsonKey(name: 'owner_receives', fromJson: _toDouble) required double ownerReceives,
    @Default(CommissionStatus.PENDING) CommissionStatus status,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommissionRecordModel;

  factory CommissionRecordModel.fromJson(Map<String, dynamic> json) =>
      _$CommissionRecordModelFromJson(json);
}

// ── WalletModel ──────────────────────────────────────────────────────
@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(fromJson: _toDouble) required double balance,
    @JsonKey(name: 'locked_balance', fromJson: _toDouble) @Default(0) double lockedBalance,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'bank_accounts') @Default([]) List<BankAccountModel> bankAccounts,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _WalletModel;

  const WalletModel._();

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  double get availableBalance => balance - lockedBalance;
}

// ── BankAccountModel ─────────────────────────────────────────────────
@freezed
abstract class BankAccountModel with _$BankAccountModel {
  const factory BankAccountModel({
    required String id,
    @JsonKey(name: 'wallet_id') required String walletId,
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'bank_code') required String bankCode,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'account_name') required String accountName,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _BankAccountModel;

  const BankAccountModel._();

  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      _$BankAccountModelFromJson(json);

  String get maskedAccount =>
      accountNumber.length > 4 ? '****${accountNumber.substring(accountNumber.length - 4)}' : accountNumber;
}

// ── PayoutRequestModel ─────────────────────────────────────────────
@freezed
abstract class PayoutRequestModel with _$PayoutRequestModel {
  const factory PayoutRequestModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(fromJson: _toDouble) required double amount,
    @Default(PayoutStatus.PENDING) PayoutStatus status,
    @JsonKey(name: 'bank_account_id') required String bankAccountId,
    @JsonKey(name: 'bank_account_name') required String bankAccountName,
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'admin_note') String? adminNote,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PayoutRequestModel;

  factory PayoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestModelFromJson(json);
}

// ── Finance Overview Stats ────────────────────────────────────────
@freezed
abstract class FinanceStatsModel with _$FinanceStatsModel {
  const factory FinanceStatsModel({
    @JsonKey(fromJson: _toDouble) @Default(0) double totalRevenue,
    @JsonKey(fromJson: _toDouble) @Default(0) double totalCommission,
    @JsonKey(fromJson: _toDouble) @Default(0) double netIncome,
    @JsonKey(fromJson: _toDouble) @Default(0) double availableBalance,
    @JsonKey(fromJson: _toDouble) @Default(0) double pendingPayout,
  }) = _FinanceStatsModel;

  factory FinanceStatsModel.fromJson(Map<String, dynamic> json) =>
      _$FinanceStatsModelFromJson(json);
}

// ── Revenue summary (per month) ───────────────────────────────────
@freezed
abstract class RevenueSummaryModel with _$RevenueSummaryModel {
  const factory RevenueSummaryModel({
    required String month, // 'YYYY-MM'
    @JsonKey(name: 'booking_count') @Default(0) int bookingCount,
    @JsonKey(name: 'total_booking_amount', fromJson: _toDouble) @Default(0) double totalBookingAmount,
    @JsonKey(name: 'total_commission_amount', fromJson: _toDouble) @Default(0) double totalCommissionAmount,
    @JsonKey(name: 'total_owner_receives', fromJson: _toDouble) @Default(0) double totalOwnerReceives,
    @JsonKey(name: 'paid_amount', fromJson: _toDouble) @Default(0) double paidAmount,
    @JsonKey(name: 'pending_amount', fromJson: _toDouble) @Default(0) double pendingAmount,
  }) = _RevenueSummaryModel;

  factory RevenueSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueSummaryModelFromJson(json);
}
