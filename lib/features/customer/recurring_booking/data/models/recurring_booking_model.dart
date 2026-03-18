import 'package:equatable/equatable.dart';

// ── Enums ──────────────────────────────────────────────────────────────────

enum RecurringType {
  DAILY,
  WEEKLY,
  MONTHLY;

  String get label {
    switch (this) {
      case DAILY: return 'Hằng ngày';
      case WEEKLY: return 'Hằng tuần';
      case MONTHLY: return 'Hằng tháng';
    }
  }
}

enum DayOfWeek {
  MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY;

  String get label {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return labels[index];
  }

  String get fullLabel {
    const labels = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    return labels[index];
  }
}

enum WaitlistStatus {
  WAITING,
  CONVERTED,
  EXPIRED,
  CANCELLED;

  String get label {
    switch (this) {
      case WAITING: return 'Đang chờ';
      case CONVERTED: return 'Đã đặt';
      case EXPIRED: return 'Hết hạn';
      case CANCELLED: return 'Đã hủy';
    }
  }
}

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

// ── recurring_bookings model ───────────────────────────────────────────────
class RecurringBookingModel extends Equatable {
  final String id;
  final String venueId;
  final String venueName;
  final String courtId;
  final String courtName;
  final RecurringType repeatType;
  final String startTime;   // HH:mm
  final String endTime;     // HH:mm
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final List<DayOfWeek> repeatDays;   // từ recurring_booking_days
  final int totalBookingsGenerated;   // count từ bookings relation

  const RecurringBookingModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.courtId,
    required this.courtName,
    required this.repeatType,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.createdAt,
    this.repeatDays = const [],
    this.totalBookingsGenerated = 0,
  });

  factory RecurringBookingModel.fromJson(Map<String, dynamic> json) {
    return RecurringBookingModel(
      id: json['id'],
      venueId: json['venue_id'],
      venueName: json['venues']?['name'] ?? '',
      courtId: json['court_id'],
      courtName: json['courts']?['name'] ?? '',
      repeatType: RecurringType.values.firstWhere((e) => e.name == json['repeat_type']),
      startTime: json['start_time'].toString().substring(0, 5),
      endTime: json['end_time'].toString().substring(0, 5),
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      repeatDays: (json['recurring_days'] as List? ?? [])
          .map((d) => DayOfWeek.values.firstWhere((e) => e.name == d['day_of_week']))
          .toList(),
      totalBookingsGenerated: json['_count']?['bookings'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, isActive, repeatType];
}

// ── booking_waitlist model ─────────────────────────────────────────────────
class WaitlistItemModel extends Equatable {
  final String id;
  final String courtId;
  final String courtName;
  final String venueId;
  final String venueName;
  final String venueAddress;
  final String? venueThumbnailUrl;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final int priority;
  final bool isNotified;
  final WaitlistStatus status;
  final DateTime createdAt;

  const WaitlistItemModel({
    required this.id,
    required this.courtId,
    required this.courtName,
    required this.venueId,
    required this.venueName,
    required this.venueAddress,
    this.venueThumbnailUrl,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.isNotified,
    required this.status,
    required this.createdAt,
  });

  factory WaitlistItemModel.fromJson(Map<String, dynamic> json) {
    return WaitlistItemModel(
      id: json['id'],
      courtId: json['court_id'],
      courtName: json['courts']?['name'] ?? '',
      venueId: json['courts']?['venue_id'] ?? '',
      venueName: json['courts']?['venues']?['name'] ?? '',
      venueAddress: json['courts']?['venues']?['address'] ?? '',
      venueThumbnailUrl: json['courts']?['venues']?['thumbnail_url'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: json['start_time'].toString().substring(0, 5),
      endTime: json['end_time'].toString().substring(0, 5),
      priority: json['priority'] ?? 1,
      isNotified: json['is_notified'] ?? false,
      status: WaitlistStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, status, priority];
}

// ── wallets model ──────────────────────────────────────────────────────────
class WalletModel extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final double lockedBalance;      // wallets.locked_balance (đang giữ)
  final bool isActive;
  final DateTime updatedAt;

  double get availableBalance => balance - lockedBalance;

  const WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.lockedBalance,
    required this.isActive,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['user_id'],
      balance: (json['balance'] as num).toDouble(),
      lockedBalance: (json['locked_balance'] as num).toDouble(),
      isActive: json['is_active'] ?? true,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [id, balance, lockedBalance];
}

// ── transactions model ─────────────────────────────────────────────────────
class TransactionModel extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final double balanceAfter;
  final TransactionStatus status;
  final String? description;
  final String? bookingId;
  final String? bookingCode;   // joined for display
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.status,
    this.description,
    this.bookingId,
    this.bookingCode,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      status: TransactionStatus.values.firstWhere((e) => e.name == json['status']),
      description: json['description'],
      bookingId: json['booking_id'],
      bookingCode: json['bookings']?['booking_code'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, type, amount, createdAt];
}
