import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_search_result_model.freezed.dart';
part 'venue_search_result_model.g.dart';

@freezed
abstract class VenueSearchResultModel with _$VenueSearchResultModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueSearchResultModel({
    required String id,
    required String name,
    required String slug,
    required String address,
    required String city,
    required String district,
    String? thumbnailUrl,
    @Default(0.0) double rating,
    @Default(0) int totalReviews,
    double? minPricePerHour,
    double? maxPricePerHour,
    @Default([]) List<String> sportTypes,
    @Default([]) List<String> amenities,
    @Default(false) bool isFeatured,
    @Default(false) bool isFavorite,
    double? latitude,
    double? longitude,
    bool? isOpen,
  }) = _VenueSearchResultModel;

  const VenueSearchResultModel._();

  factory VenueSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$VenueSearchResultModelFromJson(json);

  Map<String, dynamic> toJson();
}
