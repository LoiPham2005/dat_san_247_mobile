import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

enum BannerPosition { HOME_TOP, HOME_MIDDLE, VENUE_DETAIL, PROMOTION_MODAL }
enum BannerType { IMAGE, VIDEO }
enum BannerActionType { NONE, URL, VENUE, PROMOTION }

@freezed
class BannerModel with _$BannerModel {
  const factory BannerModel({
    required String id,
    required String title,
    @Default(BannerPosition.HOME_TOP) BannerPosition position,
    @Default(BannerType.IMAGE) BannerType type,
    @JsonKey(name: 'desktop_image_url') String? desktopImageUrl,
    @JsonKey(name: 'mobile_image_url') String? mobileImageUrl,
    @JsonKey(name: 'action_type') @Default(BannerActionType.NONE) BannerActionType actionType,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'action_venue_id') String? actionVenueId,
    @JsonKey(name: 'action_promotion_id') String? actionPromotionId,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'auto_slide') @Default(true) bool autoSlide,
    @JsonKey(name: 'slide_duration') @Default(5000) int slideDuration,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);
}
