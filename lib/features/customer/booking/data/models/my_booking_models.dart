import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_booking_models.freezed.dart';
part 'my_booking_models.g.dart';

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
      case PENDING:
        return 'Chờ xác nhận';
      case CONFIRMED:
        return 'Đã xác nhận';
      case CHECKED_IN:
        return 'Đang chơi';
      case COMPLETED:
        return 'Hoàn thành';
      case CANCELLED:
        return 'Đã hủy';
      case NO_SHOW:
        return 'Không đến';
    }
  }
}

enum PaymentStatus { PENDING, PAID, FAILED, REFUNDED, PARTIALLY_REFUNDED }

enum PaymentMethod { CASH, VNPAY, MOMO, ZALOPAY, BANK_TRANSFER, WALLET }

enum ActorRole { CUSTOMER, OWNER, VENUE_STAFF, STAFF, ADMIN, SUPER_ADMIN }

// ── booking_status_history ───────────────────────────────────────────────
@freezed
abstract class BookingStatusHistoryModel with _$BookingStatusHistoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BookingStatusHistoryModel({
    required String id,
    required String bookingId,
    required BookingStatus status,
    ActorRole? actorRole,
    String? note,
    required DateTime createdAt,
  }) = _BookingStatusHistoryModel;

  const BookingStatusHistoryModel._();

  factory BookingStatusHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$BookingStatusHistoryModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── booking_addons ───────────────────────────────────────────────────────
@freezed
abstract class BookingAddonDetailModel with _$BookingAddonDetailModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BookingAddonDetailModel({
    required String id,
    required String bookingId,
    required String serviceId,
    required String serviceName,
    required int quantity,
    required double pricePerUnit,
    required double totalPrice,
    String? note,
  }) = _BookingAddonDetailModel;

  const BookingAddonDetailModel._();

  factory BookingAddonDetailModel.fromJson(Map<String, dynamic> json) {
    // Porting manual logic from original fromJson for joined data
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['venue_services'] != null && json['venue_services'] is Map) {
      mappedJson['service_name'] = json['venue_services']['name'];
    }
    return _$BookingAddonDetailModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── payments ─────────────────────────────────────────────────────────────
@freezed
abstract class PaymentDetailModel with _$PaymentDetailModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PaymentDetailModel({
    required String id,
    required String bookingId,
    required double amount,
    required PaymentMethod paymentMethod,
    required PaymentStatus status,
    DateTime? paidAt,
    double? refundAmount,
    DateTime? refundedAt,
  }) = _PaymentDetailModel;

  const PaymentDetailModel._();

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── refund_rules ─────────────────────────────────────────────────────────
@freezed
abstract class RefundRuleModel with _$RefundRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RefundRuleModel({
    required String id,
    required int cancelBeforeHours,
    required double refundPercentage,
    String? description,
  }) = _RefundRuleModel;

  const RefundRuleModel._();

  factory RefundRuleModel.fromJson(Map<String, dynamic> json) =>
      _$RefundRuleModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── BookingListItemModel (cho C-09 danh sách) ────────────────────────────
@freezed
abstract class BookingListItemModel with _$BookingListItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BookingListItemModel({
    required String id,
    required String bookingCode,
    String? checkInCode,
    required String venueName,
    required String courtName,
    required String venueAddress,
    String? venueThumbnailUrl,
    required DateTime bookingDate,
    required String startTime, // HH:mm
    required String endTime, // HH:mm
    required BookingStatus status,
    required PaymentStatus paymentStatus,
    required double totalAmount,
    DateTime? cancellationDeadline,
    required DateTime createdAt,
  }) = _BookingListItemModel;

  const BookingListItemModel._();

  bool get canCancel {
    if (status == BookingStatus.CANCELLED ||
        status == BookingStatus.COMPLETED ||
        status == BookingStatus.NO_SHOW) return false;
    if (cancellationDeadline == null) return true;
    return DateTime.now().isBefore(cancellationDeadline!);
  }

  bool get isUpcoming =>
      status == BookingStatus.PENDING || status == BookingStatus.CONFIRMED;

  factory BookingListItemModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['venues'] != null && json['venues'] is Map) {
      mappedJson['venue_name'] = json['venues']['name'];
      mappedJson['venue_address'] = json['venues']['address'];
      mappedJson['venue_thumbnail_url'] = json['venues']['thumbnail_url'];
    }
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'];
    }
    // Porting start_time/end_time substring logic
    if (json['start_time'] != null) {
      mappedJson['start_time'] = json['start_time'].toString().substring(0, 5);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = json['end_time'].toString().substring(0, 5);
    }
    return _$BookingListItemModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── BookingDetailModel (cho C-10 chi tiết) ───────────────────────────────
@freezed
abstract class BookingDetailModel with _$BookingDetailModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BookingDetailModel({
    required String id,
    required String bookingCode,
    String? checkInCode,
    required String venueName,
    required String courtName,
    required String venueAddress,
    String? venueThumbnailUrl,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required double totalHours,
    required double pricePerHour,
    required double subTotal,
    required double discountAmount,
    required double vatRate,
    required double vatAmount,
    required double totalAmount,
    required double refundAmount,
    required double cancellationFee,
    String? promotionCode,
    String? note,
    required BookingStatus status,
    required PaymentStatus paymentStatus,
    String? paymentMethod,
    DateTime? paidAt,
    DateTime? cancellationDeadline,
    DateTime? cancelledAt,
    String? cancellationReason,
    DateTime? checkedInAt,
    required DateTime createdAt,

    // Relations
    @Default([]) List<BookingAddonDetailModel> addons,
    @Default([]) List<BookingStatusHistoryModel> statusHistory,
    @Default([]) List<PaymentDetailModel> payments,
    @Default(false) bool hasReview,
    @Default([]) List<RefundRuleModel> refundRules,
  }) = _BookingDetailModel;

  const BookingDetailModel._();

  bool get canCancel {
    if (status == BookingStatus.CANCELLED ||
        status == BookingStatus.COMPLETED ||
        status == BookingStatus.NO_SHOW) return false;
    if (cancellationDeadline == null) return true;
    return DateTime.now().isBefore(cancellationDeadline!);
  }

  bool get canReview => status == BookingStatus.COMPLETED && !hasReview;

  double computeRefundAmount(double totalAmount) {
    if (refundRules.isEmpty) return 0;
    final now = DateTime.now();
    final bookingDateTime =
        DateTime(bookingDate.year, bookingDate.month, bookingDate.day).add(
            Duration(
                hours: int.parse(startTime.split(':')[0]),
                minutes: int.parse(startTime.split(':')[1])));
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

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── ReviewSubmitModel (cho C-12) ──────────────────────────────────────────
@freezed
abstract class ReviewSubmitModel with _$ReviewSubmitModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ReviewSubmitModel({
    required String bookingId,
    required String venueId,
    required String courtId,
    required int rating,
    int? ratingCleanliness,
    int? ratingFacilities,
    int? ratingStaff,
    String? comment,
    @Default([]) List<String> imagePaths, // local file paths to upload
  }) = _ReviewSubmitModel;

  const ReviewSubmitModel._();

  factory ReviewSubmitModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewSubmitModelFromJson(json);

  Map<String, dynamic> toJson();
}
