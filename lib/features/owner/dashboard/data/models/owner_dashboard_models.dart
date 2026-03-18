import 'package:equatable/equatable.dart';

// ──────────────────────────────────────────────────────────────────────────
// Owner Dashboard Models — mapping schema.prisma
// ──────────────────────────────────────────────────────────────────────────

// ── Booking stats ─────────────────────────────────────────────────────────
class OwnerBookingStatsModel extends Equatable {
  final int totalToday;
  final int pending;
  final int confirmed;
  final int checkedIn;
  final int completed;
  final int cancelled;

  const OwnerBookingStatsModel({
    required this.totalToday,
    required this.pending,
    required this.confirmed,
    required this.checkedIn,
    required this.completed,
    required this.cancelled,
  });

  factory OwnerBookingStatsModel.fromJson(Map<String, dynamic> json) =>
      OwnerBookingStatsModel(
        totalToday: json['total_today'] ?? 0,
        pending: json['pending'] ?? 0,
        confirmed: json['confirmed'] ?? 0,
        checkedIn: json['checked_in'] ?? 0,
        completed: json['completed'] ?? 0,
        cancelled: json['cancelled'] ?? 0,
      );

  @override
  List<Object?> get props => [totalToday, pending];
}

// ── Revenue summary ───────────────────────────────────────────────────────
class OwnerRevenueModel extends Equatable {
  final double revenueToday;
  final double revenueThisMonth;
  final double revenueLastMonth;
  final double ownerReceivesThisMonth; // commission_records.owner_receives
  final double platformFeeThisMonth;   // commission_records.platform_fee
  final int bookingCountThisMonth;

  const OwnerRevenueModel({
    required this.revenueToday,
    required this.revenueThisMonth,
    required this.revenueLastMonth,
    required this.ownerReceivesThisMonth,
    required this.platformFeeThisMonth,
    required this.bookingCountThisMonth,
  });

  double get growthPercent {
    if (revenueLastMonth == 0) return 100;
    return (revenueThisMonth - revenueLastMonth) / revenueLastMonth * 100;
  }

  factory OwnerRevenueModel.fromJson(Map<String, dynamic> json) =>
      OwnerRevenueModel(
        revenueToday: (json['revenue_today'] as num?)?.toDouble() ?? 0,
        revenueThisMonth: (json['revenue_this_month'] as num?)?.toDouble() ?? 0,
        revenueLastMonth: (json['revenue_last_month'] as num?)?.toDouble() ?? 0,
        ownerReceivesThisMonth: (json['owner_receives_this_month'] as num?)?.toDouble() ?? 0,
        platformFeeThisMonth: (json['platform_fee_this_month'] as num?)?.toDouble() ?? 0,
        bookingCountThisMonth: json['booking_count_this_month'] ?? 0,
      );

  @override
  List<Object?> get props => [revenueThisMonth, revenueToday];
}

// ── Pending booking (bookings join courts + users) ─────────────────────────
class OwnerPendingBookingModel extends Equatable {
  final String id;
  final String bookingCode;
  final String courtName;
  final String venueName;
  final String customerName;
  final String? customerPhone;
  final String? customerAvatar;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String paymentMethod;
  final DateTime createdAt;

  const OwnerPendingBookingModel({
    required this.id,
    required this.bookingCode,
    required this.courtName,
    required this.venueName,
    required this.customerName,
    this.customerPhone,
    this.customerAvatar,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OwnerPendingBookingModel.fromJson(Map<String, dynamic> json) =>
      OwnerPendingBookingModel(
        id: json['id'],
        bookingCode: json['booking_code'],
        courtName: json['courts']?['name'] ?? '',
        venueName: json['courts']?['venues']?['name'] ?? '',
        customerName: json['users']?['full_name'] ?? 'Khách hàng',
        customerPhone: json['users']?['phone'],
        customerAvatar: json['users']?['avatar_url'],
        bookingDate: DateTime.parse(json['booking_date']),
        startTime: json['start_time'],
        endTime: json['end_time'],
        totalAmount: (json['total_amount'] as num).toDouble(),
        paymentMethod: json['payment_method'],
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  List<Object?> get props => [id, bookingCode];
}

// ── Recent review (reviews join venues + users) ────────────────────────────
class OwnerRecentReviewModel extends Equatable {
  final String id;
  final String venueName;
  final String? courtName;
  final String reviewerName;
  final String? reviewerAvatar;
  final int overallRating;
  final String? comment;
  final String? ownerReply;
  final DateTime createdAt;

  const OwnerRecentReviewModel({
    required this.id,
    required this.venueName,
    this.courtName,
    required this.reviewerName,
    this.reviewerAvatar,
    required this.overallRating,
    this.comment,
    this.ownerReply,
    required this.createdAt,
  });

  bool get hasReplied => ownerReply != null && ownerReply!.isNotEmpty;

  factory OwnerRecentReviewModel.fromJson(Map<String, dynamic> json) =>
      OwnerRecentReviewModel(
        id: json['id'],
        venueName: json['venues']?['name'] ?? '',
        courtName: json['bookings']?['courts']?['name'],
        reviewerName: json['users']?['full_name'] ?? 'Ẩn danh',
        reviewerAvatar: json['users']?['avatar_url'],
        overallRating: json['overall_rating'] ?? 5,
        comment: json['comment'],
        ownerReply: json['owner_reply'],
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  List<Object?> get props => [id, overallRating];
}

// ── Venue summary for owner ────────────────────────────────────────────────
class OwnerVenueSummaryModel extends Equatable {
  final String id;
  final String name;
  final String? thumbnailUrl;
  final String status; // VenueStatus
  final bool isOpen;
  final bool autoAccept;
  final double rating;
  final int totalReviews;
  final int activeCourts;
  final String city;
  final String district;

  const OwnerVenueSummaryModel({
    required this.id,
    required this.name,
    this.thumbnailUrl,
    required this.status,
    required this.isOpen,
    required this.autoAccept,
    required this.rating,
    required this.totalReviews,
    required this.activeCourts,
    required this.city,
    required this.district,
  });

  factory OwnerVenueSummaryModel.fromJson(Map<String, dynamic> json) =>
      OwnerVenueSummaryModel(
        id: json['id'],
        name: json['name'],
        thumbnailUrl: json['thumbnail_url'],
        status: json['status'] ?? 'APPROVED',
        isOpen: json['is_open'] ?? true,
        autoAccept: json['auto_accept'] ?? false,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        totalReviews: json['total_reviews'] ?? 0,
        activeCourts: json['active_courts'] ?? 0,
        city: json['city'] ?? '',
        district: json['district'] ?? '',
      );

  @override
  List<Object?> get props => [id, name, status];
}
