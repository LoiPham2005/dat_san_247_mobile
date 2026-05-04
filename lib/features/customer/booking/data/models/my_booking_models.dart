// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:equatable/equatable.dart';

// ── Enums mapping schema.prisma ─────────────────────────────────────────

enum BookingStatus {
  PENDING,
  CONFIRMED,
  CHECKED_IN,
  COMPLETED,
  CANCELLED,
  NO_SHOW;

  String get label {
    switch (this) {
      case PENDING: return 'Chờ xác nhận';
      case CONFIRMED: return 'Đã xác nhận';
      case CHECKED_IN: return 'Đang chơi';
      case COMPLETED: return 'Hoàn thành';
      case CANCELLED: return 'Đã hủy';
      case NO_SHOW: return 'Không đến';
    }
  }
}

enum PaymentStatus { PENDING, PAID, FAILED, REFUNDED, PARTIALLY_REFUNDED }
enum PaymentMethod { CASH, VNPAY, MOMO, ZALOPAY, BANK_TRANSFER, WALLET }
enum ActorRole { CUSTOMER, OWNER, VENUE_STAFF, STAFF, ADMIN, SUPER_ADMIN }

// ── booking_status_history ───────────────────────────────────────────────
class BookingStatusHistoryModel extends Equatable {
  final String id;
  final String bookingId;
  final BookingStatus status;
  final ActorRole? actorRole;
  final String? note;
  final DateTime createdAt;

  const BookingStatusHistoryModel({
    required this.id,
    required this.bookingId,
    required this.status,
    this.actorRole,
    this.note,
    required this.createdAt,
  });

  factory BookingStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusHistoryModel(
      id: json['id'],
      bookingId: json['booking_id'],
      status: BookingStatus.values.firstWhere((e) => e.name == json['status']),
      actorRole: json['actor_role'] != null
          ? ActorRole.values.firstWhere((e) => e.name == json['actor_role'])
          : null,
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, bookingId, status, createdAt];
}

// ── booking_addons ───────────────────────────────────────────────────────
class BookingAddonDetailModel extends Equatable {
  final String id;
  final String bookingId;
  final String serviceId;
  final String serviceName;  // joined from venue_services
  final int quantity;
  final double pricePerUnit;
  final double totalPrice;
  final String? note;

  const BookingAddonDetailModel({
    required this.id,
    required this.bookingId,
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPrice,
    this.note,
  });

  factory BookingAddonDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingAddonDetailModel(
      id: json['id'],
      bookingId: json['booking_id'],
      serviceId: json['service_id'],
      serviceName: json['venue_services']?['name'] ?? json['service_name'] ?? '',
      quantity: json['quantity'],
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      note: json['note'],
    );
  }

  @override
  List<Object?> get props => [id, bookingId, serviceId];
}

// ── payments ─────────────────────────────────────────────────────────────
class PaymentDetailModel extends Equatable {
  final String id;
  final String bookingId;
  final double amount;
  final PaymentMethod paymentMethod;
  final PaymentStatus status;
  final DateTime? paidAt;
  final double? refundAmount;
  final DateTime? refundedAt;

  const PaymentDetailModel({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.paidAt,
    this.refundAmount,
    this.refundedAt,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      id: json['id'],
      bookingId: json['booking_id'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere((e) => e.name == json['payment_method']),
      status: PaymentStatus.values.firstWhere((e) => e.name == json['status']),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      refundAmount: json['refund_amount'] != null ? (json['refund_amount'] as num).toDouble() : null,
      refundedAt: json['refunded_at'] != null ? DateTime.parse(json['refunded_at']) : null,
    );
  }

  @override
  List<Object?> get props => [id, bookingId, amount, status];
}

// ── refund_rules ─────────────────────────────────────────────────────────
class RefundRuleModel extends Equatable {
  final String id;
  final int cancelBeforeHours;
  final double refundPercentage;
  final String? description;

  const RefundRuleModel({
    required this.id,
    required this.cancelBeforeHours,
    required this.refundPercentage,
    this.description,
  });

  factory RefundRuleModel.fromJson(Map<String, dynamic> json) {
    return RefundRuleModel(
      id: json['id'],
      cancelBeforeHours: json['cancel_before_hours'],
      refundPercentage: (json['refund_percentage'] as num).toDouble(),
      description: json['description'],
    );
  }

  @override
  List<Object?> get props => [id, cancelBeforeHours, refundPercentage];
}

// ── BookingListItemModel (cho C-09 danh sách) ────────────────────────────
class BookingListItemModel extends Equatable {
  final String id;
  final String bookingCode;
  final String? checkInCode;
  final String venueName;
  final String courtName;
  final String venueAddress;
  final String? venueThumbnailUrl;
  final DateTime bookingDate;
  final String startTime;  // HH:mm
  final String endTime;    // HH:mm
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double totalAmount;
  final DateTime? cancellationDeadline;
  final DateTime createdAt;

  const BookingListItemModel({
    required this.id,
    required this.bookingCode,
    this.checkInCode,
    required this.venueName,
    required this.courtName,
    required this.venueAddress,
    this.venueThumbnailUrl,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    this.cancellationDeadline,
    required this.createdAt,
  });

  bool get canCancel {
    if (status == BookingStatus.CANCELLED || status == BookingStatus.COMPLETED || status == BookingStatus.NO_SHOW) return false;
    if (cancellationDeadline == null) return true;
    return DateTime.now().isBefore(cancellationDeadline!);
  }

  bool get isUpcoming =>
      status == BookingStatus.PENDING || status == BookingStatus.CONFIRMED;

  factory BookingListItemModel.fromJson(Map<String, dynamic> json) {
    return BookingListItemModel(
      id: json['id'],
      bookingCode: json['booking_code'],
      checkInCode: json['check_in_code'],
      venueName: json['venues']?['name'] ?? '',
      courtName: json['courts']?['name'] ?? '',
      venueAddress: json['venues']?['address'] ?? '',
      venueThumbnailUrl: json['venues']?['thumbnail_url'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: json['start_time'].toString().substring(0, 5),
      endTime: json['end_time'].toString().substring(0, 5),
      status: BookingStatus.values.firstWhere((e) => e.name == json['status']),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['payment_status']),
      totalAmount: (json['total_amount'] as num).toDouble(),
      cancellationDeadline: json['cancellation_deadline'] != null
          ? DateTime.parse(json['cancellation_deadline'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, bookingCode, status];
}

// ── BookingDetailModel (cho C-10 chi tiết) ───────────────────────────────
class BookingDetailModel extends Equatable {
  final String id;
  final String bookingCode;
  final String? checkInCode;
  final String venueName;
  final String courtName;
  final String venueAddress;
  final String? venueThumbnailUrl;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double totalHours;
  final double pricePerHour;
  final double subTotal;
  final double discountAmount;
  final double vatRate;
  final double vatAmount;
  final double totalAmount;
  final double refundAmount;
  final double cancellationFee;
  final String? promotionCode;
  final String? note;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final DateTime? paidAt;
  final DateTime? cancellationDeadline;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime? checkedInAt;
  final DateTime createdAt;

  // Relations
  final List<BookingAddonDetailModel> addons;
  final List<BookingStatusHistoryModel> statusHistory;
  final List<PaymentDetailModel> payments;
  final bool hasReview;
  final List<RefundRuleModel> refundRules;

  const BookingDetailModel({
    required this.id,
    required this.bookingCode,
    this.checkInCode,
    required this.venueName,
    required this.courtName,
    required this.venueAddress,
    this.venueThumbnailUrl,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.pricePerHour,
    required this.subTotal,
    required this.discountAmount,
    required this.vatRate,
    required this.vatAmount,
    required this.totalAmount,
    required this.refundAmount,
    required this.cancellationFee,
    this.promotionCode,
    this.note,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.paidAt,
    this.cancellationDeadline,
    this.cancelledAt,
    this.cancellationReason,
    this.checkedInAt,
    required this.createdAt,
    this.addons = const [],
    this.statusHistory = const [],
    this.payments = const [],
    this.hasReview = false,
    this.refundRules = const [],
  });

  bool get canCancel {
    if (status == BookingStatus.CANCELLED || status == BookingStatus.COMPLETED || status == BookingStatus.NO_SHOW) return false;
    if (cancellationDeadline == null) return true;
    return DateTime.now().isBefore(cancellationDeadline!);
  }

  bool get canReview =>
      status == BookingStatus.COMPLETED && !hasReview;

  double computeRefundAmount(double totalAmount) {
    if (refundRules.isEmpty) return 0;
    final now = DateTime.now();
    final bookingDateTime = DateTime(bookingDate.year, bookingDate.month, bookingDate.day)
        .add(Duration(hours: int.parse(startTime.split(':')[0]), minutes: int.parse(startTime.split(':')[1])));
    final hoursLeft = bookingDateTime.difference(now).inHours;

    // Find applicable rule (highest cancel_before_hours that is still <= hoursLeft)
    RefundRuleModel? best;
    for (final rule in refundRules) {
      if (hoursLeft >= rule.cancelBeforeHours) {
        if (best == null || rule.cancelBeforeHours > best.cancelBeforeHours) {
          best = rule;
        }
      }
    }
    if (best == null) return 0;
    return totalAmount * best.refundPercentage / 100;
  }

  @override
  List<Object?> get props => [id, bookingCode, status];
}

// ── ReviewSubmitModel (cho C-12) ──────────────────────────────────────────
class ReviewSubmitModel {
  final String bookingId;
  final String venueId;
  final String courtId;
  final int rating;
  final int? ratingCleanliness;
  final int? ratingFacilities;
  final int? ratingStaff;
  final String? comment;
  final List<String> imagePaths;  // local file paths to upload

  ReviewSubmitModel({
    required this.bookingId,
    required this.venueId,
    required this.courtId,
    required this.rating,
    this.ratingCleanliness,
    this.ratingFacilities,
    this.ratingStaff,
    this.comment,
    this.imagePaths = const [],
  });

  Map<String, dynamic> toJson() => {
    'booking_id': bookingId,
    'venue_id': venueId,
    'court_id': courtId,
    'rating': rating,
    if (ratingCleanliness != null) 'rating_cleanliness': ratingCleanliness,
    if (ratingFacilities != null) 'rating_facilities': ratingFacilities,
    if (ratingStaff != null) 'rating_staff': ratingStaff,
    if (comment != null) 'comment': comment,
  };
}
