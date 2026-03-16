import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'venue_search_result_model.g.dart';

@JsonSerializable()
class VenueSearchResultModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String address;
  final String city;
  final String district;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  
  final double rating;
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  
  @JsonKey(name: 'min_price_per_hour')
  final double? minPricePerHour;
  @JsonKey(name: 'max_price_per_hour')
  final double? maxPricePerHour;
  
  @JsonKey(name: 'sport_types')
  final List<String> sportTypes;
  final List<String> amenities;

  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;

  const VenueSearchResultModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.address,
    required this.city,
    required this.district,
    this.thumbnailUrl,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.minPricePerHour,
    this.maxPricePerHour,
    this.sportTypes = const [],
    this.amenities = const [],
    this.isFeatured = false,
    this.isFavorite = false,
  });

  factory VenueSearchResultModel.fromJson(Map<String, dynamic> json) => _$VenueSearchResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueSearchResultModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        address,
        city,
        district,
        thumbnailUrl,
        rating,
        totalReviews,
        minPricePerHour,
        maxPricePerHour,
        sportTypes,
        amenities,
        isFeatured,
        isFavorite,
      ];
}
