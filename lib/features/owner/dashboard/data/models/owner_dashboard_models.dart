import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_dashboard_models.freezed.dart';
part 'owner_dashboard_models.g.dart';

// ──────────────────────────────────────────────────────────────────────────
// Owner Dashboard Models — mapping schema.prisma
// ──────────────────────────────────────────────────────────────────────────

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

Object? _readTotalToday(Map json, String key) => json['todayBookingsCount'] ?? json['total_today'];
Object? _readPendingCount(Map json, String key) => json['pendingCount'] ?? json['pending'];
Object? _readConfirmedCount(Map json, String key) => json['confirmedCount'] ?? json['confirmed'];
Object? _readCheckedInCount(Map json, String key) => json['checkedInCount'] ?? json['checked_in'];
Object? _readCompletedCount(Map json, String key) => json['completedCount'] ?? json['completed'];
Object? _readCancelledCount(Map json, String key) => json['cancelledCount'] ?? json['cancelled'];

// ── Booking stats ─────────────────────────────────────────────────────────
@freezed
abstract class OwnerBookingStatsModel with _$OwnerBookingStatsModel {
  const factory OwnerBookingStatsModel({
    @JsonKey(readValue: _readTotalToday) @Default(0) int totalToday,
    @JsonKey(readValue: _readPendingCount) @Default(0) int pending,
    @JsonKey(readValue: _readConfirmedCount) @Default(0) int confirmed,
    @JsonKey(readValue: _readCheckedInCount) @Default(0) int checkedIn,
    @JsonKey(readValue: _readCompletedCount) @Default(0) int completed,
    @JsonKey(readValue: _readCancelledCount) @Default(0) int cancelled,
  }) = _OwnerBookingStatsModel;

  factory OwnerBookingStatsModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerBookingStatsModelFromJson(json);
}

// ── Revenue summary ───────────────────────────────────────────────────────
Object? _readRevenueToday(Map json, String key) => json['todayRevenue'] ?? json['revenue_today'];
Object? _readRevenueMonth(Map json, String key) => json['thisMonthRevenue'] ?? json['revenue_this_month'];
Object? _readRevenueLast(Map json, String key) => json['lastMonthRevenue'] ?? json['revenue_last_month'];
Object? _readOwnerReceives(Map json, String key) => json['ownerReceivesThisMonth'] ?? json['owner_receives_this_month'];
Object? _readPlatformFee(Map json, String key) => json['platformFeeThisMonth'] ?? json['platform_fee_this_month'];
Object? _readBookCountMonth(Map json, String key) => json['thisMonthBookingsCount'] ?? json['booking_count_this_month'];

@freezed
abstract class OwnerRevenueModel with _$OwnerRevenueModel {
  const OwnerRevenueModel._();

  const factory OwnerRevenueModel({
    @JsonKey(readValue: _readRevenueToday, fromJson: _toDouble) @Default(0.0) double revenueToday,
    @JsonKey(readValue: _readRevenueMonth, fromJson: _toDouble) @Default(0.0) double revenueThisMonth,
    @JsonKey(readValue: _readRevenueLast, fromJson: _toDouble) @Default(0.0) double revenueLastMonth,
    @JsonKey(readValue: _readOwnerReceives, fromJson: _toDouble) @Default(0.0) double ownerReceivesThisMonth,
    @JsonKey(readValue: _readPlatformFee, fromJson: _toDouble) @Default(0.0) double platformFeeThisMonth,
    @JsonKey(readValue: _readBookCountMonth) @Default(0) int bookingCountThisMonth,
  }) = _OwnerRevenueModel;

  double get growthPercent {
    if (revenueLastMonth == 0) return 100;
    return (revenueThisMonth - revenueLastMonth) / revenueLastMonth * 100;
  }

  factory OwnerRevenueModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerRevenueModelFromJson(json);
}

// ── Pending booking ────────────────────────────────────────────────────────
Object? _readCode(Map json, String key) => json['booking_code'] ?? json['bookingCode'];
Object? _readCourtName(Map json, String key) => json['court_name'] ?? json['courtName'] ?? json['courts']?['name'];
Object? _readVenueName(Map json, String key) => json['venue_name'] ?? json['venueName'] ?? json['courts']?['venues']?['name'];
Object? _readCustomerName(Map json, String key) => json['customer_name'] ?? json['customerName'] ?? json['users']?['full_name'];
Object? _readPhone(Map json, String key) => json['customer_phone'] ?? json['customerPhone'] ?? json['users']?['phone'];
Object? _readAvatar(Map json, String key) => json['customer_avatar'] ?? json['customerAvatar'] ?? json['users']?['avatar_url'];
Object? _readAmount(Map json, String key) => json['total_amount'] ?? json['totalAmount'];

@freezed
abstract class OwnerPendingBookingModel with _$OwnerPendingBookingModel {
  const factory OwnerPendingBookingModel({
    @Default('') String id,
    @JsonKey(readValue: _readCode) @Default('') String bookingCode,
    @JsonKey(readValue: _readCourtName) @Default('') String courtName,
    @JsonKey(readValue: _readVenueName) @Default('') String venueName,
    @JsonKey(readValue: _readCustomerName) @Default('Khách') String customerName,
    @JsonKey(readValue: _readPhone) String? customerPhone,
    @JsonKey(readValue: _readAvatar) String? customerAvatar,
    @Default(null) DateTime? bookingDate,
    @Default('') String startTime,
    @Default('') String endTime,
    @JsonKey(readValue: _readAmount, fromJson: _toDouble) @Default(0.0) double totalAmount,
    @JsonKey(name: 'payment_method') @Default('CASH') String paymentMethod,
    @Default('PENDING') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OwnerPendingBookingModel;

  factory OwnerPendingBookingModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerPendingBookingModelFromJson(json);
}

// ── Recent review ──────────────────────────────────────────────────────────
Object? _readRVVenueName(Map json, String key) => json['venue_name'] ?? json['venues']?['name'];
Object? _readRVCourtName(Map json, String key) => json['court_name'] ?? json['bookings']?['courts']?['name'];
Object? _readRVReviewerName(Map json, String key) => json['customer_name'] ?? json['users']?['full_name'];
Object? _readRVReviewerAvatar(Map json, String key) => json['customer_avatar'] ?? json['users']?['avatar_url'];
Object? _readRVRating(Map json, String key) => json['overall_rating'] ?? json['rating'];

@freezed
abstract class OwnerRecentReviewModel with _$OwnerRecentReviewModel {
  const OwnerRecentReviewModel._();

  const factory OwnerRecentReviewModel({
    @Default('') String id,
    @JsonKey(readValue: _readRVVenueName) @Default('') String venueName,
    @JsonKey(readValue: _readRVCourtName) String? courtName,
    @JsonKey(readValue: _readRVReviewerName) @Default('Ẩn danh') String reviewerName,
    @JsonKey(readValue: _readRVReviewerAvatar) String? reviewerAvatar,
    @JsonKey(readValue: _readRVRating) @Default(5) int overallRating,
    String? comment,
    @JsonKey(name: 'owner_reply') String? ownerReply,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OwnerRecentReviewModel;

  bool get hasReplied => ownerReply != null && ownerReply!.isNotEmpty;

  factory OwnerRecentReviewModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerRecentReviewModelFromJson(json);
}

// ── Venue summary for owner ────────────────────────────────────────────────
@freezed
abstract class OwnerVenueSummaryModel with _$OwnerVenueSummaryModel {
  const factory OwnerVenueSummaryModel({
    @Default('') String id,
    @Default('') String name,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @Default('APPROVED') String status,
    @JsonKey(name: 'is_active') @Default(true) bool isOpen,
    @JsonKey(name: 'auto_accept_bookings') @Default(false) bool autoAccept,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double rating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'active_courts') @Default(0) int activeCourts,
    @Default('') String city,
    @Default('') String district,
  }) = _OwnerVenueSummaryModel;

  factory OwnerVenueSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerVenueSummaryModelFromJson(json);
}
