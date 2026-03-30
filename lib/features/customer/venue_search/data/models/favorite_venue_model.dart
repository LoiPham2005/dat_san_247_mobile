import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_venue_model.freezed.dart';
part 'favorite_venue_model.g.dart';

@freezed
abstract class FavoriteVenueModel with _$FavoriteVenueModel {
  const factory FavoriteVenueModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    VenueModel? venue,
  }) = _FavoriteVenueModel;

  factory FavoriteVenueModel.fromJson(Map<String, dynamic> json) => _$FavoriteVenueModelFromJson(json);
}
