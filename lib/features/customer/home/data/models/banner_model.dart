import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

enum BannerPosition { HOME_TOP, HOME_MIDDLE, VENUE_DETAIL, PROMOTION_MODAL }

enum BannerType { IMAGE, VIDEO }

enum BannerActionType { NONE, URL, VENUE, PROMOTION }

@freezed
abstract class BannerModel with _$BannerModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory BannerModel({
    required String id,
    required String title,
    @Default(BannerPosition.HOME_TOP) BannerPosition position,
    @Default(BannerType.IMAGE) BannerType type,
    String? desktopImageUrl,
    String? mobileImageUrl,
    @Default(BannerActionType.NONE) BannerActionType actionType,
    String? actionUrl,
    String? actionVenueId,
    String? actionPromotionId,
    DateTime? startDate,
    DateTime? endDate,
    @Default(true) bool isActive,
    @Default(true) bool autoSlide,
    @Default(5000) int slideDuration,
  }) = _BannerModel;

  const BannerModel._();

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson();
}
