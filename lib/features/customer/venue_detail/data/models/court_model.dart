import 'package:json_annotation/json_annotation.dart';
import 'operating_hours_model.dart';
part 'court_model.g.dart';

@JsonEnum(alwaysCreate: true)
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

@JsonSerializable()
class AmenityModel {
  final String id;
  @JsonKey(name: 'venue_id')
  final String? venueId;
  @JsonKey(name: 'court_id')
  final String? courtId;
  final String name;
  final String? icon;
  @JsonKey(name: 'is_free')
  final bool isFree;

  AmenityModel({
    required this.id,
    this.venueId,
    this.courtId,
    required this.name,
    this.icon,
    required this.isFree,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);
  Map<String, dynamic> toJson() => _$AmenityModelToJson(this);
}

@JsonSerializable()
class PricingRuleModel {
  final String id;
  @JsonKey(name: 'court_id')
  final String courtId;
  final String? name;
  @JsonKey(name: 'day_of_week')
  final DayOfWeek? dayOfWeek;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  final double price;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final int priority;
  @JsonKey(name: 'is_active')
  final bool isActive;

  PricingRuleModel({
    required this.id,
    required this.courtId,
    this.name,
    this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.price,
    this.startDate,
    this.endDate,
    required this.priority,
    required this.isActive,
  });

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) =>
      _$PricingRuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$PricingRuleModelToJson(this);
}

@JsonSerializable()
class MediaAttachmentModel {
  final String id;
  @JsonKey(name: 'file_id')
  final String fileId;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'is_cover')
  final bool isCover;
  final String? caption;
  
  // Custom field to get direct URL from response, or use files relation
  final String? url;

  MediaAttachmentModel({
    required this.id,
    required this.fileId,
    required this.displayOrder,
    required this.isCover,
    this.caption,
    this.url,
  });

  factory MediaAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$MediaAttachmentModelToJson(this);
}

@JsonSerializable()
class CourtModel {
  final String id;
  @JsonKey(name: 'venue_id')
  final String venueId;
  final String name;
  final String? description;
  @JsonKey(name: 'price_per_hour')
  final double pricePerHour;
  @JsonKey(name: 'surface_type')
  final CourtSurfaceType? surfaceType;
  final String? size;
  @JsonKey(name: 'is_indoor')
  final bool isIndoor;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  final List<AmenityModel>? amenities;
  @JsonKey(name: 'pricing_rules')
  final List<PricingRuleModel>? pricingRules;
  @JsonKey(name: 'media_attachments')
  final List<MediaAttachmentModel>? mediaAttachments;

  CourtModel({
    required this.id,
    required this.venueId,
    required this.name,
    this.description,
    required this.pricePerHour,
    this.surfaceType,
    this.size,
    required this.isIndoor,
    required this.isActive,
    required this.displayOrder,
    this.thumbnailUrl,
    this.amenities,
    this.pricingRules,
    this.mediaAttachments,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) =>
      _$CourtModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourtModelToJson(this);
}
