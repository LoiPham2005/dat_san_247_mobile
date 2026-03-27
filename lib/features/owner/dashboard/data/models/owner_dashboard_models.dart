import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_dashboard_models.freezed.dart';
part 'owner_dashboard_models.g.dart';

// ── Booking stats ─────────────────────────────────────────────────────────
@freezed
abstract class OwnerBookingStatsModel with _$OwnerBookingStatsModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerBookingStatsModel({
    @Default(0) int totalToday,
    @Default(0) int pending,
    @Default(0) int confirmed,
    @Default(0) int checkedIn,
    @Default(0) int completed,
    @Default(0) int cancelled,
  }) = _OwnerBookingStatsModel;

  const OwnerBookingStatsModel._();

  factory OwnerBookingStatsModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerBookingStatsModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── Revenue summary ───────────────────────────────────────────────────────
@freezed
abstract class OwnerRevenueModel with _$OwnerRevenueModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerRevenueModel({
    @Default(0.0) double revenueToday,
    @Default(0.0) double revenueThisMonth,
    @Default(0.0) double revenueLastMonth,
    @Default(0.0) double ownerReceivesThisMonth,
    @Default(0.0) double platformFeeThisMonth,
    @Default(0) int bookingCountThisMonth,
  }) = _OwnerRevenueModel;

  const OwnerRevenueModel._();

  double get growthPercent {
    if (revenueLastMonth == 0) return 100;
    return (revenueThisMonth - revenueLastMonth) / revenueLastMonth * 100;
  }

  factory OwnerRevenueModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerRevenueModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── Pending booking ────────────────────────────────────────────────────────
@freezed
abstract class OwnerPendingBookingModel with _$OwnerPendingBookingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerPendingBookingModel({
    required String id,
    required String bookingCode,
    required String courtName,
    required String venueName,
    required String customerName,
    String? customerPhone,
    String? customerAvatar,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required double totalAmount,
    required String paymentMethod,
    required DateTime createdAt,
  }) = _OwnerPendingBookingModel;

  const OwnerPendingBookingModel._();

  factory OwnerPendingBookingModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'] ?? '';
      if (json['courts']['venues'] != null && json['courts']['venues'] is Map) {
        mappedJson['venue_name'] = json['courts']['venues']['name'] ?? '';
      }
    }
    if (json['users'] != null && json['users'] is Map) {
      mappedJson['customer_name'] = json['users']['full_name'] ?? 'Khách hàng';
      mappedJson['customer_phone'] = json['users']['phone'];
      mappedJson['customer_avatar'] = json['users']['avatar_url'];
    }
    return _$OwnerPendingBookingModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── Recent review ──────────────────────────────────────────────────────────
@freezed
abstract class OwnerRecentReviewModel with _$OwnerRecentReviewModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerRecentReviewModel({
    required String id,
    required String venueName,
    String? courtName,
    required String reviewerName,
    String? reviewerAvatar,
    @Default(5) int overallRating,
    String? comment,
    String? ownerReply,
    required DateTime createdAt,
  }) = _OwnerRecentReviewModel;

  const OwnerRecentReviewModel._();

  bool get hasReplied => ownerReply != null && ownerReply!.isNotEmpty;

  factory OwnerRecentReviewModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'] ?? '';
    }
    if (json['bookings'] != null &&
        json['bookings'] is Map &&
        json['bookings']['courts'] != null) {
      mappedJson['court_name'] = json['bookings']['courts']['name'];
    }
    if (json['users'] != null && json['users'] is Map) {
      mappedJson['reviewer_name'] = json['users']['full_name'] ?? 'Ẩn danh';
      mappedJson['reviewer_avatar'] = json['users']['avatar_url'];
    }
    return _$OwnerRecentReviewModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── Venue summary for owner ────────────────────────────────────────────────
@freezed
abstract class OwnerVenueSummaryModel with _$OwnerVenueSummaryModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerVenueSummaryModel({
    required String id,
    required String name,
    String? thumbnailUrl,
    @Default('APPROVED') String status,
    @Default(true) bool isOpen,
    @Default(false) bool autoAccept,
    @Default(0.0) double rating,
    @Default(0) int totalReviews,
    @Default(0) int activeCourts,
    @Default('') String city,
    @Default('') String district,
  }) = _OwnerVenueSummaryModel;

  const OwnerVenueSummaryModel._();

  factory OwnerVenueSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerVenueSummaryModelFromJson(json);

  Map<String, dynamic> toJson();
}
