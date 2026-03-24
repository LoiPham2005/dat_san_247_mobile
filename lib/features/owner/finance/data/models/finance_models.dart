// ── CommissionStatus (schema enum) ───────────────────────────────────────────
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

// ── PayoutStatus (schema enum) ───────────────────────────────────────────────
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

// ── commission_records ────────────────────────────────────────────────────────
class CommissionRecordModel {
  final String id;
  final String bookingId;
  final String bookingCode;   // denormalized for display
  final String venueId;
  final String venueName;     // denormalized
  final String ownerId;
  final DateTime bookingDate; // denormalized
  final String courtName;     // denormalized
  final String customerName;  // denormalized
  final double bookingAmount;
  final double commissionRate;   // % e.g. 10.0
  final double commissionAmount; // platform thu
  final double ownerReceives;    // chủ sân nhận
  final CommissionStatus status;
  final DateTime? paidAt;
  final DateTime createdAt;

  const CommissionRecordModel({
    required this.id,
    required this.bookingId,
    required this.bookingCode,
    required this.venueId,
    required this.venueName,
    required this.ownerId,
    required this.bookingDate,
    required this.courtName,
    required this.customerName,
    required this.bookingAmount,
    required this.commissionRate,
    required this.commissionAmount,
    required this.ownerReceives,
    required this.status,
    this.paidAt,
    required this.createdAt,
  });
}

// ── wallets ───────────────────────────────────────────────────────────────────
class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final double lockedBalance;
  final bool isActive;
  final List<BankAccountModel> bankAccounts;
  final DateTime updatedAt;

  const WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    this.lockedBalance = 0,
    this.isActive = true,
    this.bankAccounts = const [],
    required this.updatedAt,
  });

  double get availableBalance => balance - lockedBalance;
}

// ── payout_bank_accounts ──────────────────────────────────────────────────────
class BankAccountModel {
  final String id;
  final String walletId;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountName;
  final bool isDefault;

  const BankAccountModel({
    required this.id,
    required this.walletId,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
    this.isDefault = false,
  });

  String get maskedAccount =>
      accountNumber.length > 4 ? '****${accountNumber.substring(accountNumber.length - 4)}' : accountNumber;
}

// ── payout_requests ───────────────────────────────────────────────────────────
class PayoutRequestModel {
  final String id;
  final String userId;
  final double amount;
  final PayoutStatus status;
  final String bankAccountId;
  final String bankAccountName; // denormalized for display
  final String bankName;
  final String? adminNote;
  final String? rejectionReason;
  final DateTime? processedAt;
  final DateTime createdAt;

  const PayoutRequestModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.bankAccountId,
    required this.bankAccountName,
    required this.bankName,
    this.adminNote,
    this.rejectionReason,
    this.processedAt,
    required this.createdAt,
  });
}

// ── Revenue summary (computed) ────────────────────────────────────────────────
class RevenueSummaryModel {
  final String month; // 'YYYY-MM'
  final int bookingCount;
  final double totalBookingAmount;
  final double totalCommissionAmount;
  final double totalOwnerReceives;
  final double paidAmount;
  final double pendingAmount;

  const RevenueSummaryModel({
    required this.month,
    required this.bookingCount,
    required this.totalBookingAmount,
    required this.totalCommissionAmount,
    required this.totalOwnerReceives,
    required this.paidAmount,
    required this.pendingAmount,
  });
}
