import 'package:freezed_annotation/freezed_annotation.dart';
import 'operating_hours_model.dart';

part 'court_model.freezed.dart';
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

@freezed
abstract class AmenityModel with _$AmenityModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AmenityModel({
    required String id,
    String? venueId,
    String? courtId,
    required String name,
    String? icon,
    required bool isFree,
  }) = _AmenityModel;

  const AmenityModel._();

  factory AmenityModel.fromJson(Map<String, dynamic> json) =>
      _$AmenityModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class PricingRuleModel with _$PricingRuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PricingRuleModel({
    required String id,
    required String courtId,
    String? name,
    DayOfWeek? dayOfWeek,
    required String startTime,
    required String endTime,
    required double price,
    DateTime? startDate,
    DateTime? endDate,
    required int priority,
    required bool isActive,
  }) = _PricingRuleModel;

  const PricingRuleModel._();

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) =>
      _$PricingRuleModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class MediaAttachmentModel with _$MediaAttachmentModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MediaAttachmentModel({
    required String id,
    required String fileId,
    required int displayOrder,
    required bool isCover,
    String? caption,
    String? url,
  }) = _MediaAttachmentModel;

  const MediaAttachmentModel._();

  factory MediaAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$MediaAttachmentModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class CourtModel with _$CourtModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CourtModel({
    required String id,
    required String venueId,
    required String name,
    String? description,
    required double pricePerHour,
    CourtSurfaceType? surfaceType,
    String? size,
    required bool isIndoor,
    required bool isActive,
    required int displayOrder,
    String? thumbnailUrl,
    List<AmenityModel>? amenities,
    List<PricingRuleModel>? pricingRules,
    List<MediaAttachmentModel>? mediaAttachments,
  }) = _CourtModel;

  const CourtModel._();

  factory CourtModel.fromJson(Map<String, dynamic> json) =>
      _$CourtModelFromJson(json);

  Map<String, dynamic> toJson();
}
