// ══════════════════════════════════════════════════════════════════════════════
// Owner Finance + Review + Verification Models — O-11, O-12, O-13
// Based on schema.prisma
// ══════════════════════════════════════════════════════════════════════════════

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

// ══════════════════════════════════════════════════════════════════════════════
// reviews model — O-12
// DB: reviews (venue_id), users (reviewer)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerReviewModel {
  final String id;
  final String bookingId;
  final String venueId;
  final String? courtId;
  final String userId;
  final String reviewerName;
  final String? reviewerAvatar;

  final int rating;
  final int? ratingCleanliness;
  final int? ratingFacilities;
  final int? ratingStaff;
  final String? comment;

  final String? response;
  final String? respondedBy;
  final DateTime? respondedAt;

  final bool isVisible;
  final DateTime createdAt;

  const OwnerReviewModel({
    required this.id,
    required this.bookingId,
    required this.venueId,
    this.courtId,
    required this.userId,
    required this.reviewerName,
    this.reviewerAvatar,
    required this.rating,
    this.ratingCleanliness,
    this.ratingFacilities,
    this.ratingStaff,
    this.comment,
    this.response,
    this.respondedBy,
    this.respondedAt,
    this.isVisible = true,
    required this.createdAt,
  });

  bool get hasResponse => response != null && response!.isNotEmpty;
  double get avgSubRating {
    final scores = [ratingCleanliness, ratingFacilities, ratingStaff]
        .where((s) => s != null).cast<int>().toList();
    if (scores.isEmpty) return rating.toDouble();
    return scores.fold(0, (a, b) => a + b) / scores.length;
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// venue_verifications model — O-13
// DB: venue_verifications (venue_id), files
// ══════════════════════════════════════════════════════════════════════════════
enum VerificationDocStatus { PENDING, APPROVED, REJECTED }

extension VerificationDocStatusX on VerificationDocStatus {
  String get label => switch (this) {
    VerificationDocStatus.PENDING  => 'Đang xét duyệt',
    VerificationDocStatus.APPROVED => 'Đã xác minh',
    VerificationDocStatus.REJECTED => 'Bị từ chối',
  };
  String get emoji => switch (this) {
    VerificationDocStatus.PENDING  => '⏳',
    VerificationDocStatus.APPROVED => '✅',
    VerificationDocStatus.REJECTED => '❌',
  };
}

class VenueVerificationModel {
  final String id;
  final String venueId;
  final int version;
  final String businessLicenseUrl;
  final String idCardFrontUrl;
  final String idCardBackUrl;
  final String ownerPhotoUrl;
  final VerificationDocStatus status;
  final DateTime? verifiedAt;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VenueVerificationModel({
    required this.id,
    required this.venueId,
    required this.version,
    required this.businessLicenseUrl,
    required this.idCardFrontUrl,
    required this.idCardBackUrl,
    required this.ownerPhotoUrl,
    required this.status,
    this.verifiedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending  => status == VerificationDocStatus.PENDING;
  bool get isApproved => status == VerificationDocStatus.APPROVED;
  bool get isRejected => status == VerificationDocStatus.REJECTED;
  bool get canResubmit => isRejected;
}
