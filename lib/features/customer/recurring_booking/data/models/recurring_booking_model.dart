import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_booking_model.freezed.dart';
part 'recurring_booking_model.g.dart';

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
@freezed
abstract class RecurringBookingModel with _$RecurringBookingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RecurringBookingModel({
    required String id,
    required String venueId,
    required String venueName,
    required String courtId,
    required String courtName,
    required RecurringType repeatType,
    required String startTime,   // HH:mm
    required String endTime,     // HH:mm
    required DateTime startDate,
    DateTime? endDate,
    @Default(true) bool isActive,
    required DateTime createdAt,
    @Default([]) List<DayOfWeek> repeatDays,
    @Default(0) int totalBookingsGenerated,
  }) = _RecurringBookingModel;

  const RecurringBookingModel._();

  factory RecurringBookingModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    
    // Join details
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'];
    }
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'];
    }
    
    // Substring times
    if (json['start_time'] != null) {
      mappedJson['start_time'] = json['start_time'].toString().substring(0, 5);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = json['end_time'].toString().substring(0, 5);
    }
    
    // Mapping recurring_days relation to our list of enums
    if (json['recurring_days'] != null && json['recurring_days'] is List) {
      mappedJson['repeat_days'] = (json['recurring_days'] as List)
          .map((d) => d['day_of_week'])
          .toList();
    }
    
    // Action: map total count
    if (json['_count'] != null && json['_count'] is Map) {
      mappedJson['total_bookings_generated'] = json['_count']['bookings'];
    }

    return _$RecurringBookingModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── booking_waitlist model ─────────────────────────────────────────────────
@freezed
abstract class WaitlistItemModel with _$WaitlistItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory WaitlistItemModel({
    required String id,
    required String courtId,
    required String courtName,
    required String venueId,
    required String venueName,
    required String venueAddress,
    String? venueThumbnailUrl,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    @Default(1) int priority,
    @Default(false) bool isNotified,
    required WaitlistStatus status,
    required DateTime createdAt,
  }) = _WaitlistItemModel;

  const WaitlistItemModel._();

  factory WaitlistItemModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'];
      mappedJson['venue_id'] = json['courts']['venue_id'];
      if (json['courts']['venues'] != null) {
        mappedJson['venue_name'] = json['courts']['venues']['name'];
        mappedJson['venue_address'] = json['courts']['venues']['address'];
        mappedJson['venue_thumbnail_url'] = json['courts']['venues']['thumbnail_url'];
      }
    }
    
    if (json['start_time'] != null) {
      mappedJson['start_time'] = json['start_time'].toString().substring(0, 5);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = json['end_time'].toString().substring(0, 5);
    }

    return _$WaitlistItemModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── wallets model ──────────────────────────────────────────────────────────
@freezed
abstract class WalletModel with _$WalletModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory WalletModel({
    required String id,
    required String userId,
    required double balance,
    @Default(0) double lockedBalance,
    @Default(true) bool isActive,
    required DateTime updatedAt,
  }) = _WalletModel;

  const WalletModel._();

  double get availableBalance => balance - lockedBalance;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── transactions model ─────────────────────────────────────────────────────
@freezed
abstract class TransactionModel with _$TransactionModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TransactionModel({
    required String id,
    required TransactionType type,
    required double amount,
    required double balanceAfter,
    required TransactionStatus status,
    String? description,
    String? bookingId,
    String? bookingCode,
    required DateTime createdAt,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['bookings'] != null && json['bookings'] is Map) {
      mappedJson['booking_code'] = json['bookings']['booking_code'];
    }
    return _$TransactionModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}
