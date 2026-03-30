import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/core/common/converters/json_converters.dart';
import 'court_model.dart';
import 'operating_hours_model.dart';

part 'venue_detail_model.freezed.dart';
part 'venue_detail_model.g.dart';

@freezed
abstract class VenueReviewModel with _$VenueReviewModel {
  const factory VenueReviewModel({
    required String id,
    @JsonKey(name: 'customer_name') required String customerName,
    @StringToDoubleConverter() required double rating,
    String? comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _VenueReviewModel;

  factory VenueReviewModel.fromJson(Map<String, dynamic> json) => _$VenueReviewModelFromJson(json);
}

@freezed
abstract class VenueDetailModel with _$VenueDetailModel {
  const factory VenueDetailModel({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    required String slug,
    String? description,
    required String address,
    required String city,
    required String district,
    @Default('') String ward,
    String? phone,
    String? email,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'fb_url') String? fbUrl,
    @JsonKey(name: 'zalo_url') String? zaloUrl,
    @JsonKey(name: 'instagram_url') String? instagramUrl,
    @JsonKey(name: 'youtube_url') String? youtubeUrl,
    required String status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @StringToDoubleConverter() @Default(0.0) double rating,
    @StringToDoubleConverter() @JsonKey(name: 'rating_cleanliness') @Default(0.0) double ratingCleanliness,
    @StringToDoubleConverter() @JsonKey(name: 'rating_facilities') @Default(0.0) double ratingFacilities,
    @StringToDoubleConverter() @JsonKey(name: 'rating_staff') @Default(0.0) double ratingStaff,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    List<CourtModel>? courts,
    @JsonKey(name: 'media_attachments') List<MediaAttachmentModel>? mediaAttachments,
    @JsonKey(name: 'operating_hours') List<OperatingHoursModel>? operatingHours,
    @JsonKey(name: 'venue_schedule_exceptions') List<VenueScheduleExceptionModel>? scheduleExceptions,
    List<AmenityModel>? amenities,
    @StringToDoubleNullableConverter() double? latitude,
    @StringToDoubleNullableConverter() double? longitude,
    List<VenueReviewModel>? reviews,
    @StringToDoubleConverter() @JsonKey(name: 'min_price') @Default(0.0) double minPrice,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _VenueDetailModel;

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) => _$VenueDetailModelFromJson(json);
}
