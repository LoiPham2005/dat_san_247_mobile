import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_models.freezed.dart';
part 'venue_models.g.dart';

// ── VenueStatus enum ─────────────────────────────────────────
enum VenueStatus { PENDING, APPROVED, REJECTED, SUSPENDED }

extension VenueStatusExt on VenueStatus {
  String get label => switch (this) {
        VenueStatus.PENDING => 'Chờ duyệt',
        VenueStatus.APPROVED => 'Đã duyệt',
        VenueStatus.REJECTED => 'Bị từ chối',
        VenueStatus.SUSPENDED => 'Bị tạm khóa',
      };
}

// ── CourtSurfaceType enum ─────────────────────────────────────────────────────
enum CourtSurfaceType {
  GRASS,
  ARTIFICIAL_GRASS,
  CONCRETE,
  WOOD,
  CLAY,
  RUBBER,
  OTHER
}

extension CourtSurfaceTypeExt on CourtSurfaceType {
  String get label => switch (this) {
        CourtSurfaceType.GRASS => 'Sân cỏ tự nhiên',
        CourtSurfaceType.ARTIFICIAL_GRASS => 'Sân cỏ nhân tạo',
        CourtSurfaceType.CONCRETE => 'Sân bê tông',
        CourtSurfaceType.WOOD => 'Sân gỗ',
        CourtSurfaceType.CLAY => 'Sân đất nện',
        CourtSurfaceType.RUBBER => 'Sân cao su',
        CourtSurfaceType.OTHER => 'Khác',
      };
}

// ── VerificationStatus ────────────────────────────────────────────────────────
enum VerificationStatus { PENDING, APPROVED, REJECTED }

// ── DayOfWeek ────────────────────────────────────────────────────────────────
enum OwnerDayOfWeek {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY
}

extension OwnerDayOfWeekExt on OwnerDayOfWeek {
  String get short => switch (this) {
        OwnerDayOfWeek.MONDAY => 'T2',
        OwnerDayOfWeek.TUESDAY => 'T3',
        OwnerDayOfWeek.WEDNESDAY => 'T4',
        OwnerDayOfWeek.THURSDAY => 'T5',
        OwnerDayOfWeek.FRIDAY => 'T6',
        OwnerDayOfWeek.SATURDAY => 'T7',
        OwnerDayOfWeek.SUNDAY => 'CN',
      };
  bool get isWeekend =>
      this == OwnerDayOfWeek.SATURDAY || this == OwnerDayOfWeek.SUNDAY;
}

// ── OwnerVenueModel ─────────────────────────────────────────────────────────
@freezed
abstract class OwnerVenueModel with _$OwnerVenueModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerVenueModel({
    required String id,
    required String ownerId,
    required String name,
    required String slug,
    String? description,
    required String address,
    required String city,
    required String district,
    String? ward,
    String? phone,
    String? email,
    String? thumbnailUrl,
    String? fbUrl,
    String? instagramUrl,
    String? zaloUrl,
    String? youtubeUrl,
    required VenueStatus status,
    String? rejectionReason,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    @Default(0) double rating,
    @Default(0) double ratingCleanliness,
    @Default(0) double ratingFacilities,
    @Default(0) double ratingStaff,
    @Default(0) int totalReviews,
    @Default(0) double commissionRate,
    @Default(0) double vatRate,
    @Default(true) bool autoAcceptBookings,
    @Default(1) int minBookingHours,
    @Default(24) int maxBookingHours,
    @Default(0) int minBookingBeforeHours,
    @Default(24) int cancellationBeforeHours,
    DateTime? approvedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int courtCount,
    @Default([]) List<String> sportTypes,
  }) = _OwnerVenueModel;

  const OwnerVenueModel._();

  factory OwnerVenueModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['_count'] != null && json['_count'] is Map) {
      mappedJson['court_count'] = json['_count']['courts'] ?? 0;
    }
    if (json['sport_assignments'] != null && json['sport_assignments'] is List) {
      mappedJson['sport_types'] = (json['sport_assignments'] as List)
          .map((s) => s['sport_type'].toString())
          .toList();
    }
    return _$OwnerVenueModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── VenueOperatingHoursModel ────────────────────────────────────────────────
@freezed
abstract class VenueOperatingHoursModel with _$VenueOperatingHoursModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueOperatingHoursModel({
    required String id,
    required String venueId,
    required OwnerDayOfWeek dayOfWeek,
    required String openingTime,
    required String closingTime,
    @Default(false) bool isClosed,
  }) = _VenueOperatingHoursModel;

  const VenueOperatingHoursModel._();

  factory VenueOperatingHoursModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['opening_time'] != null) {
      mappedJson['opening_time'] = _pt(json['opening_time']);
    }
    if (json['closing_time'] != null) {
      mappedJson['closing_time'] = _pt(json['closing_time']);
    }
    return _$VenueOperatingHoursModelFromJson(mappedJson);
  }

  static String _pt(dynamic t) {
    if (t == null) return '00:00';
    final s = t.toString();
    if (s.contains('T')) {
      final dt = DateTime.tryParse(s);
      if (dt != null)
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return s.length >= 5 ? s.substring(0, 5) : s;
  }

  Map<String, dynamic> toJson();
}

// ── VenueScheduleExceptionModel ──────────────────────────────────────────────
@freezed
abstract class VenueScheduleExceptionModel with _$VenueScheduleExceptionModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueScheduleExceptionModel({
    required String id,
    required String venueId,
    required DateTime date,
    @Default(true) bool isClosed,
    String? openTime,
    String? closeTime,
    String? reason,
    required DateTime createdAt,
  }) = _VenueScheduleExceptionModel;

  const VenueScheduleExceptionModel._();

  factory VenueScheduleExceptionModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['open_time'] != null) {
      mappedJson['open_time'] = VenueOperatingHoursModel._pt(json['open_time']);
    }
    if (json['close_time'] != null) {
      mappedJson['close_time'] = VenueOperatingHoursModel._pt(json['close_time']);
    }
    return _$VenueScheduleExceptionModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── AmenityModel ─────────────────────────────────────────────────────────────
@freezed
abstract class AmenityModel with _$AmenityModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AmenityModel({
    required String id,
    String? venueId,
    String? courtId,
    required String name,
    String? icon,
    @Default(true) bool isFree,
  }) = _AmenityModel;

  const AmenityModel._();

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── OwnerCourtModel ──────────────────────────────────────────────────────────
@freezed
abstract class OwnerCourtModel with _$OwnerCourtModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerCourtModel({
    required String id,
    required String venueId,
    required String name,
    String? description,
    required double pricePerHour,
    CourtSurfaceType? surfaceType,
    String? size,
    @Default(false) bool isIndoor,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    String? thumbnailUrl,
    @Default([]) List<String> sportTypes,
    @Default([]) List<AmenityModel> amenities,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OwnerCourtModel;

  const OwnerCourtModel._();

  factory OwnerCourtModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['sport_assignments'] != null && json['sport_assignments'] is List) {
      mappedJson['sport_types'] = (json['sport_assignments'] as List)
          .map((s) => s['sport_type'].toString())
          .toList();
    }
    return _$OwnerCourtModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── OwnerPricingRuleModel ───────────────────────────────────────────────────
@freezed
abstract class OwnerPricingRuleModel with _$OwnerPricingRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OwnerPricingRuleModel({
    required String id,
    required String courtId,
    @Default('') String courtName,
    String? name,
    String? dayOfWeek,
    required String startTime,
    required String endTime,
    required double price,
    DateTime? startDate,
    DateTime? endDate,
    @Default(1) int priority,
    @Default(true) bool isActive,
    required DateTime updatedAt,
  }) = _OwnerPricingRuleModel;

  const OwnerPricingRuleModel._();

  String get dayLabel {
    const map = {
      'MONDAY': 'T2',
      'TUESDAY': 'T3',
      'WEDNESDAY': 'T4',
      'THURSDAY': 'T5',
      'FRIDAY': 'T6',
      'SATURDAY': 'T7',
      'SUNDAY': 'CN'
    };
    return dayOfWeek != null ? (map[dayOfWeek] ?? dayOfWeek!) : 'Tất cả ngày';
  }

  bool get isPeakHour {
    final h = int.tryParse(startTime.split(':')[0]) ?? 0;
    return h >= 17 && h <= 21;
  }

  bool get isWeekend => dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY';

  factory OwnerPricingRuleModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['courts'] != null && json['courts'] is Map) {
      mappedJson['court_name'] = json['courts']['name'] ?? '';
    }
    if (json['start_time'] != null) {
      mappedJson['start_time'] = VenueOperatingHoursModel._pt(json['start_time']);
    }
    if (json['end_time'] != null) {
      mappedJson['end_time'] = VenueOperatingHoursModel._pt(json['end_time']);
    }
    return _$OwnerPricingRuleModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── MediaAttachmentModel ────────────────────────────────────────────────────
@freezed
abstract class MediaAttachmentModel with _$MediaAttachmentModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MediaAttachmentModel({
    required String id,
    required String fileId,
    required String publicUrl,
    String? caption,
    @Default(false) bool isCover,
    @Default(0) int displayOrder,
  }) = _MediaAttachmentModel;

  const MediaAttachmentModel._();

  factory MediaAttachmentModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mappedJson = Map<String, dynamic>.from(json);
    if (json['files'] != null && json['files'] is Map) {
      mappedJson['public_url'] = json['files']['public_url'] ?? mappedJson['public_url'] ?? '';
    }
    return _$MediaAttachmentModelFromJson(mappedJson);
  }

  Map<String, dynamic> toJson();
}

// ── Venue Verification Models ───────────────────────────────────────────────
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

@freezed
abstract class VenueVerificationModel with _$VenueVerificationModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueVerificationModel({
    required String id,
    required String venueId,
    required int version,
    required String businessLicenseUrl,
    required String idCardFrontUrl,
    required String idCardBackUrl,
    required String ownerPhotoUrl,
    required VerificationDocStatus status,
    DateTime? verifiedAt,
    String? rejectionReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VenueVerificationModel;

  const VenueVerificationModel._();

  bool get isPending  => status == VerificationDocStatus.PENDING;
  bool get isApproved => status == VerificationDocStatus.APPROVED;
  bool get isRejected => status == VerificationDocStatus.REJECTED;
  bool get canResubmit => status == VerificationDocStatus.REJECTED;

  factory VenueVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$VenueVerificationModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── VenueService Models ─────────────────────────────────────────────────────
enum VenueServiceType { PRODUCT, SERVICE }

extension VenueServiceTypeX on VenueServiceType {
  String get label => switch (this) {
    VenueServiceType.PRODUCT => 'Sản phẩm',
    VenueServiceType.SERVICE => 'Dịch vụ',
  };
  String get emoji => switch (this) {
    VenueServiceType.PRODUCT => '📦',
    VenueServiceType.SERVICE => '🛎️',
  };
}

enum ServiceUnit { UNIT, HOUR, SESSION, PERSON, SET }

extension ServiceUnitX on ServiceUnit {
  String get label => switch (this) {
    ServiceUnit.UNIT    => 'cái',
    ServiceUnit.HOUR    => 'giờ',
    ServiceUnit.SESSION => 'buổi',
    ServiceUnit.PERSON  => 'người',
    ServiceUnit.SET     => 'bộ',
  };
}

@freezed
abstract class VenueServiceModel with _$VenueServiceModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueServiceModel({
    required String id,
    required String venueId,
    required String name,
    String? description,
    required double price,
    @Default(ServiceUnit.UNIT) ServiceUnit unit,
    @Default(VenueServiceType.SERVICE) VenueServiceType type,
    String? category,
    @Default(true) bool isAvailable,
    @Default(false) bool trackInventory,
    @Default(0) int stockQuantity,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _VenueServiceModel;

  const VenueServiceModel._();

  bool get isLowStock => trackInventory && stockQuantity <= 3 && stockQuantity > 0;
  bool get isOutOfStock => trackInventory && stockQuantity <= 0;

  factory VenueServiceModel.fromJson(Map<String, dynamic> json) =>
      _$VenueServiceModelFromJson(json);

  Map<String, dynamic> toJson();
}

// ── RefundPolicy Models ─────────────────────────────────────────────────────
@freezed
abstract class RefundRuleModel with _$RefundRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RefundRuleModel({
    required String id,
    required String policyId,
    required int cancelBeforeHours,
    required double refundPercentage,
    String? description,
  }) = _RefundRuleModel;

  const RefundRuleModel._();

  String get label {
    if (cancelBeforeHours >= 24) return 'Hủy trước ${cancelBeforeHours ~/ 24} ngày';
    return 'Hủy trước ${cancelBeforeHours}h';
  }

  factory RefundRuleModel.fromJson(Map<String, dynamic> json) =>
      _$RefundRuleModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class RefundPolicyModel with _$RefundPolicyModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RefundPolicyModel({
    required String id,
    String? venueId,
    required String name,
    String? description,
    @Default(true) bool isActive,
    @Default(false) bool isDefault,
    @Default([]) List<RefundRuleModel> rules,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RefundPolicyModel;

  const RefundPolicyModel._();

  factory RefundPolicyModel.fromJson(Map<String, dynamic> json) =>
      _$RefundPolicyModelFromJson(json);

  Map<String, dynamic> toJson();
}
