import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/core/common/converters/json_converters.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

part 'owner_review_model.freezed.dart';
part 'owner_review_model.g.dart';

@freezed
abstract class OwnerReviewModel with _$OwnerReviewModel {
  const factory OwnerReviewModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'court_id') required String courtId,
    @StringToDoubleConverter() required double rating,
    @StringToDoubleConverter() @JsonKey(name: 'rating_cleanliness') @Default(0.0) double ratingCleanliness,
    @StringToDoubleConverter() @JsonKey(name: 'rating_facilities') @Default(0.0) double ratingFacilities,
    @StringToDoubleConverter() @JsonKey(name: 'rating_staff') @Default(0.0) double ratingStaff,
    String? comment,
    String? response,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    ReviewUserInfo? users,
    ReviewVenueInfo? venues,
    ReviewCourtInfo? courts,
    @JsonKey(name: 'media_attachments') @Default([]) List<MediaAttachmentModel> mediaAttachments,
  }) = _OwnerReviewModel;

  factory OwnerReviewModel.fromJson(Map<String, dynamic> json) => _$OwnerReviewModelFromJson(json);
}

@freezed
abstract class ReviewUserInfo with _$ReviewUserInfo {
  const factory ReviewUserInfo({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _ReviewUserInfo;

  factory ReviewUserInfo.fromJson(Map<String, dynamic> json) => _$ReviewUserInfoFromJson(json);
}

@freezed
abstract class ReviewVenueInfo with _$ReviewVenueInfo {
  const factory ReviewVenueInfo({
    required String id,
    required String name,
  }) = _ReviewVenueInfo;

  factory ReviewVenueInfo.fromJson(Map<String, dynamic> json) => _$ReviewVenueInfoFromJson(json);
}

@freezed
abstract class ReviewCourtInfo with _$ReviewCourtInfo {
  const factory ReviewCourtInfo({
    required String id,
    required String name,
  }) = _ReviewCourtInfo;

  factory ReviewCourtInfo.fromJson(Map<String, dynamic> json) => _$ReviewCourtInfoFromJson(json);
}
