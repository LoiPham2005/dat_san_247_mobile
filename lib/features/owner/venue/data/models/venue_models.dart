// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'dart:io';
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
enum CourtSurfaceType { GRASS, ARTIFICIAL_GRASS, CONCRETE, WOOD, CLAY, RUBBER, OTHER }

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

extension VerificationStatusExt on VerificationStatus {
  String get label => switch (this) {
        VerificationStatus.PENDING => 'Đang chờ duyệt',
        VerificationStatus.APPROVED => 'Đã xác minh',
        VerificationStatus.REJECTED => 'Bị từ chối',
      };
  String get emoji => switch (this) {
        VerificationStatus.PENDING => '⏳',
        VerificationStatus.APPROVED => '✅',
        VerificationStatus.REJECTED => '❌',
      };
}

// ── DayOfWeek ────────────────────────────────────────────────────────────────
enum OwnerDayOfWeek { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

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
  bool get isWeekend => this == OwnerDayOfWeek.SATURDAY || this == OwnerDayOfWeek.SUNDAY;
}

// ── VenueServiceType ────────────────────────────────────────────────────────
enum VenueServiceType { PRODUCT, SERVICE }

extension VenueServiceTypeExt on VenueServiceType {
  String get label => this == VenueServiceType.PRODUCT ? 'Sản phẩm' : 'Dịch vụ';
  String get emoji => this == VenueServiceType.PRODUCT ? '📦' : '🛎';
}

// ── ServiceUnit ─────────────────────────────────────────────────────────────
enum ServiceUnit { UNIT, SESSION, PERSON, HOUR }

extension ServiceUnitExt on ServiceUnit {
  String get label => switch (this) {
        ServiceUnit.UNIT => 'Cái/Chai',
        ServiceUnit.SESSION => 'Lượt/Trận',
        ServiceUnit.PERSON => 'Người',
        ServiceUnit.HOUR => 'Giờ',
      };
}

// ── VerificationDocStatus ───────────────────────────────────────────────────
enum VerificationDocStatus { PENDING, APPROVED, REJECTED }

// ── Helpers ──────────────────────────────────────────────────────────────────
double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

String _pt(dynamic v) {
  if (v == null) return '';
  if (v is String && v.length >= 5) return v.substring(0, 5);
  return v?.toString() ?? '';
}

Object? _readPublicUrl(Map json, String key) {
  return json['public_url'] ?? json['files']?['public_url'];
}

Object? _readMimeType(Map json, String key) {
  return json['file_type'] ?? json['files']?['mime_type'];
}

Object? _readCourtCount(Map json, String key) => json['_count']?['courts'];
Object? _readSportTypes(Map json, String key) => (json['sport_assignments'] as List?)?.map((s) => s['sport_type']).toList();

@freezed
abstract class VenueUploadResponse with _$VenueUploadResponse {
  const factory VenueUploadResponse({
    required String url,
  }) = _VenueUploadResponse;

  factory VenueUploadResponse.fromJson(Map<String, dynamic> json) => _$VenueUploadResponseFromJson(json);
}

// ── OwnerVenueModel ─────────────────────────────────────────────────────────
@freezed
abstract class OwnerVenueModel with _$OwnerVenueModel {
  const factory OwnerVenueModel({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    required String slug,
    String? description,
    required String address,
    required String city,
    required String district,
    String? ward,
    String? phone,
    String? email,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'fb_url') String? fbUrl,
    @JsonKey(name: 'instagram_url') String? instagramUrl,
    @JsonKey(name: 'zalo_url') String? zaloUrl,
    @JsonKey(name: 'youtube_url') String? youtubeUrl,
    @Default(VenueStatus.PENDING) VenueStatus status,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(fromJson: _toDouble) @Default(0.0) double rating,
    @JsonKey(name: 'rating_cleanliness', fromJson: _toDouble) @Default(0.0) double ratingCleanliness,
    @JsonKey(name: 'rating_facilities', fromJson: _toDouble) @Default(0.0) double ratingFacilities,
    @JsonKey(name: 'rating_staff', fromJson: _toDouble) @Default(0.0) double ratingStaff,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'commission_rate', fromJson: _toDouble) @Default(0.0) double commissionRate,
    @JsonKey(name: 'vat_rate', fromJson: _toDouble) @Default(0.0) double vatRate,
    @JsonKey(name: 'auto_accept_bookings') @Default(true) bool autoAcceptBookings,
    @JsonKey(name: 'min_booking_hours') @Default(1) int minBookingHours,
    @JsonKey(name: 'max_booking_hours') @Default(24) int maxBookingHours,
    @JsonKey(name: 'min_booking_before_hours') @Default(0) int minBookingBeforeHours,
    @JsonKey(name: 'cancellation_before_hours') @Default(24) int cancellationBeforeHours,
    @JsonKey(fromJson: _toDouble) double? latitude,
    @JsonKey(fromJson: _toDouble) double? longitude,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(readValue: _readCourtCount) @Default(0) int courtCount,
    @JsonKey(readValue: _readSportTypes) @Default([]) List<String> sportTypes,
  }) = _OwnerVenueModel;

  factory OwnerVenueModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerVenueModelFromJson(json);
}

// ── VenueOperatingHoursModel ────────────────────────────────────────────────
@freezed
abstract class VenueOperatingHoursModel with _$VenueOperatingHoursModel {
  const factory VenueOperatingHoursModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'day_of_week') required OwnerDayOfWeek dayOfWeek,
    @JsonKey(name: 'opening_time', fromJson: _pt) required String openingTime,
    @JsonKey(name: 'closing_time', fromJson: _pt) required String closingTime,
    @JsonKey(name: 'is_closed') @Default(false) bool isClosed,
  }) = _VenueOperatingHoursModel;

  factory VenueOperatingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$VenueOperatingHoursModelFromJson(json);
}

// ── AmenityModel ────────────────────────────────────────────────────────────
@freezed
abstract class AmenityModel with _$AmenityModel {
  const factory AmenityModel({
    required String id,
    @JsonKey(name: 'venue_id') String? venueId,
    @JsonKey(name: 'court_id') String? courtId,
    required String name,
    String? icon,
    @Default(true) bool isFree,
  }) = _AmenityModel;

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);
}

// ── OwnerCourtModel ──────────────────────────────────────────────────────────
@freezed
abstract class OwnerCourtModel with _$OwnerCourtModel {
  const factory OwnerCourtModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    required String name,
    String? description,
    @JsonKey(name: 'price_per_hour', fromJson: _toDouble) @Default(0.0) double pricePerHour,
    @JsonKey(name: 'court_type') String? courtType,
    @JsonKey(name: 'surface_type') CourtSurfaceType? surfaceType,
    String? size,
    @Default(false) bool isIndoor,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @Default([]) List<String> sportTypes,
    @Default([]) List<AmenityModel> amenities,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OwnerCourtModel;

  factory OwnerCourtModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerCourtModelFromJson(json);
}

// ── OwnerPricingRuleModel ────────────────────────────────────────────────────
@freezed
abstract class OwnerPricingRuleModel with _$OwnerPricingRuleModel {
  const factory OwnerPricingRuleModel({
    required String id,
    @JsonKey(name: 'court_id') required String courtId,
    @JsonKey(name: 'court_name') String? courtName,
    String? name,
    @JsonKey(name: 'day_of_week') String? dayOfWeek,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(fromJson: _toDouble) required double price,
    @Default(1) int priority,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OwnerPricingRuleModel;

  const OwnerPricingRuleModel._();

  factory OwnerPricingRuleModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerPricingRuleModelFromJson(json);

  bool get isWeekend => dayOfWeek == 'SATURDAY' || dayOfWeek == 'SUNDAY';
  bool get isPeakHour => priority >= 3;
  String get dayLabel {
    if (dayOfWeek == null) return 'Mọi ngày';
    return switch (dayOfWeek) {
      'MONDAY' => 'Thứ 2',
      'TUESDAY' => 'Thứ 3',
      'WEDNESDAY' => 'Thứ 4',
      'THURSDAY' => 'Thứ 5',
      'FRIDAY' => 'Thứ 6',
      'SATURDAY' => 'Thứ 7',
      'SUNDAY' => 'Chủ Nhật',
      _ => dayOfWeek!,
    };
  }
}

// ── RefundPolicyModel ───────────────────────────────────────────────────────
@freezed
abstract class RefundPolicyModel with _$RefundPolicyModel {
  const factory RefundPolicyModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    required String name,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default([]) List<RefundRuleModel> rules,
  }) = _RefundPolicyModel;

  factory RefundPolicyModel.fromJson(Map<String, dynamic> json) =>
      _$RefundPolicyModelFromJson(json);
}

@freezed
abstract class RefundRuleModel with _$RefundRuleModel {
  const RefundRuleModel._();

  const factory RefundRuleModel({
    required String id,
    @JsonKey(name: 'policy_id') required String policyId,
    @JsonKey(name: 'before_hours') required int beforeHours,
    @JsonKey(name: 'refund_percentage') required double refundPercentage,
    String? description,
  }) = _RefundRuleModel;

  factory RefundRuleModel.fromJson(Map<String, dynamic> json) =>
      _$RefundRuleModelFromJson(json);

  // Getter để map từ UI
  int get cancelBeforeHours => beforeHours;
}

// ── VenueScheduleExceptionModel ─────────────────────────────────────────────
@freezed
abstract class VenueScheduleExceptionModel with _$VenueScheduleExceptionModel {
  const factory VenueScheduleExceptionModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    required DateTime date,
    @JsonKey(name: 'is_closed') @Default(false) bool isClosed,
    @JsonKey(name: 'open_time') String? openTime,
    @JsonKey(name: 'close_time') String? closeTime,
    String? reason,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _VenueScheduleExceptionModel;

  factory VenueScheduleExceptionModel.fromJson(Map<String, dynamic> json) =>
      _$VenueScheduleExceptionModelFromJson(json);
}

// ── MediaAttachmentModel ────────────────────────────────────────────────────
@freezed
abstract class MediaAttachmentModel with _$MediaAttachmentModel {
  const factory MediaAttachmentModel({
    required String id,
    @JsonKey(readValue: _readPublicUrl) required String publicUrl,
    @JsonKey(name: 'is_cover', defaultValue: false) @Default(false) bool isCover,
    @JsonKey(readValue: _readMimeType) String? fileType,
  }) = _MediaAttachmentModel;

  factory MediaAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentModelFromJson(json);
}

// ── VenueServiceModel ───────────────────────────────────────────────────────
@freezed
abstract class VenueServiceModel with _$VenueServiceModel {
  const factory VenueServiceModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    required String name,
    String? description,
    @JsonKey(fromJson: _toDouble) required double price,
    @Default(ServiceUnit.UNIT) ServiceUnit unit,
    @Default(VenueServiceType.SERVICE) VenueServiceType type,
    String? category,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'track_inventory') @Default(false) bool trackInventory,
    @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VenueServiceModel;

  const VenueServiceModel._();

  factory VenueServiceModel.fromJson(Map<String, dynamic> json) =>
      _$VenueServiceModelFromJson(json);

  bool get isLowStock => trackInventory && stockQuantity > 0 && stockQuantity <= 5;
  bool get isOutOfStock => trackInventory && stockQuantity <= 0;
}

// ── VenueVerificationModel ──────────────────────────────────────────────────
@freezed
abstract class VenueVerificationModel with _$VenueVerificationModel {
  const factory VenueVerificationModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @Default(1) int version,
    @Default(VerificationStatus.PENDING) VerificationStatus status,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default([]) List<VerificationDocumentModel> documents,
    // Fields từ mock cho UI
    String? businessLicenseUrl,
    String? idCardFrontUrl,
    String? idCardBackUrl,
    String? ownerPhotoUrl,
  }) = _VenueVerificationModel;

  const VenueVerificationModel._();

  factory VenueVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$VenueVerificationModelFromJson(json);

  bool get isApproved => status == VerificationStatus.APPROVED;
  bool get isRejected => status == VerificationStatus.REJECTED;
  bool get isPending => status == VerificationStatus.PENDING;
  bool get canResubmit => isRejected || !isPending;
}

@freezed
abstract class VerificationDocumentModel with _$VerificationDocumentModel {
  const factory VerificationDocumentModel({
    required String id,
    @JsonKey(name: 'verification_id') String? verificationId,
    @JsonKey(name: 'document_type') required String documentType,
    @JsonKey(name: 'document_url') required String documentUrl,
    @Default(VerificationDocStatus.PENDING) VerificationDocStatus status,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
  }) = _VerificationDocumentModel;

  factory VerificationDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentModelFromJson(json);
}
// ── VenueHoursState ─────────────────────────────────────────────────────────
@freezed
abstract class VenueHoursState with _$VenueHoursState {
  const factory VenueHoursState({
    @Default([]) List<VenueOperatingHoursModel> hours,
    @Default([]) List<VenueScheduleExceptionModel> exceptions,
  }) = _VenueHoursState;

  factory VenueHoursState.fromJson(Map<String, dynamic> json) =>
      _$VenueHoursStateFromJson(json);
}
// ── VenueMediaState ─────────────────────────────────────────────────────────
@freezed
abstract class VenueMediaState with _$VenueMediaState {
  const factory VenueMediaState({
    @Default([]) List<MediaAttachmentModel> media,
    @JsonKey(includeFromJson: false, includeToJson: false) @Default([]) List<File> pendingFiles, // Local files to be uploaded
  }) = _VenueMediaState;

  factory VenueMediaState.fromJson(Map<String, dynamic> json) =>
      _$VenueMediaStateFromJson(json);
}
