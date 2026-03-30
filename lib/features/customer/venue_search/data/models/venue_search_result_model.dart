import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/core/common/converters/json_converters.dart';

part 'venue_search_result_model.freezed.dart';
part 'venue_search_result_model.g.dart';

@freezed
abstract class VenueSearchResultModel with _$VenueSearchResultModel {
  const factory VenueSearchResultModel({
    required String id,
    required String name,
    required String slug,
    required String address,
    required String city,
    required String district,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @StringToDoubleConverter() @Default(0.0) double rating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @StringToDoubleNullableConverter() @JsonKey(name: 'min_price') double? minPricePerHour,
    @StringToDoubleNullableConverter() @JsonKey(name: 'max_price') double? maxPricePerHour,
    @JsonKey(name: 'sports') @Default([]) List<String> sportTypes,
    @Default([]) List<String> amenities,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @StringToDoubleNullableConverter() double? latitude,
    @StringToDoubleNullableConverter() double? longitude,
    @JsonKey(name: 'is_open') bool? isOpen,
  }) = _VenueSearchResultModel;

  factory VenueSearchResultModel.fromJson(Map<String, dynamic> json) => _$VenueSearchResultModelFromJson(json);
}
