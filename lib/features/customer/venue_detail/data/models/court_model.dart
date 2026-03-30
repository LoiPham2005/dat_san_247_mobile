import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/core/common/converters/json_converters.dart';
import 'operating_hours_model.dart';

part 'court_model.freezed.dart';
part 'court_model.g.dart';

enum CourtSurfaceType {
  @JsonValue('GRASS')
  grass,
  @JsonValue('ARTIFICIAL_GRASS')
  artificialGrass,
  @JsonValue('CONCRETE')
  concrete,
  @JsonValue('WOOD')
  wood,
  @JsonValue('RUBBER')
  rubber,
  @JsonValue('CLAY')
  clay,
  @JsonValue('SAND')
  sand,
  @JsonValue('OTHER')
  other,
}

@freezed
abstract class AmenityModel with _$AmenityModel {
  const factory AmenityModel({
    required String id,
    @JsonKey(name: 'venue_id') String? venueId,
    @JsonKey(name: 'court_id') String? courtId,
    required String name,
    String? icon,
    @JsonKey(name: 'is_free') @Default(true) bool isFree,
  }) = _AmenityModel;

  factory AmenityModel.fromJson(Map<String, dynamic> json) => _$AmenityModelFromJson(json);
}

@freezed
abstract class PricingRuleModel with _$PricingRuleModel {
  const factory PricingRuleModel({
    required String id,
    @JsonKey(name: 'court_id') required String courtId,
    String? name,
    @JsonKey(name: 'day_of_week') DayOfWeek? dayOfWeek,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @StringToDoubleConverter() required double price,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @Default(1) int priority,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _PricingRuleModel;

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) => _$PricingRuleModelFromJson(json);
}

@freezed
abstract class MediaAttachmentModel with _$MediaAttachmentModel {
  const factory MediaAttachmentModel({
    required String id,
    @JsonKey(name: 'file_id') required String fileId,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'is_cover') @Default(false) bool isCover,
    String? caption,
    String? url,
  }) = _MediaAttachmentModel;

  factory MediaAttachmentModel.fromJson(Map<String, dynamic> json) => _$MediaAttachmentModelFromJson(json);
}

@freezed
abstract class CourtModel with _$CourtModel {
  const factory CourtModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    required String name,
    String? description,
    @StringToDoubleConverter() @JsonKey(name: 'price_per_hour') required double pricePerHour,
    @JsonKey(name: 'surface_type') CourtSurfaceType? surfaceType,
    String? size,
    @JsonKey(name: 'is_indoor') @Default(false) bool isIndoor,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    List<AmenityModel>? amenities,
    @JsonKey(name: 'pricing_rules') List<PricingRuleModel>? pricingRules,
    @JsonKey(name: 'media_attachments') List<MediaAttachmentModel>? mediaAttachments,
  }) = _CourtModel;

  factory CourtModel.fromJson(Map<String, dynamic> json) => _$CourtModelFromJson(json);
}
