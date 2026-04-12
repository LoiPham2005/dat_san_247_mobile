import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_venue_model.freezed.dart';
part 'favorite_venue_model.g.dart';

@freezed
abstract class FavoriteVenueModel with _$FavoriteVenueModel {
  const factory FavoriteVenueModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required FavoriteVenueDetail venue,
  }) = _FavoriteVenueModel;

  factory FavoriteVenueModel.fromJson(Map<String, dynamic> json) => _$FavoriteVenueModelFromJson(json);
}

@freezed
abstract class FavoriteVenueDetail with _$FavoriteVenueDetail {
  const factory FavoriteVenueDetail({
    required String id,
    required String name,
    required String slug,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    required String address,
    @JsonKey(name: 'average_rating') @Default(0.0) double averageRating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @Default([]) List<String> sports,
    @JsonKey(name: 'min_price') @Default(0.0) double minPrice,
  }) = _FavoriteVenueDetail;

  factory FavoriteVenueDetail.fromJson(Map<String, dynamic> json) => _$FavoriteVenueDetailFromJson(json);
}
