import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';

part 'favorite_venue_model.freezed.dart';
part 'favorite_venue_model.g.dart';

@freezed
abstract class FavoriteVenueModel with _$FavoriteVenueModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory FavoriteVenueModel({
    required String id,
    required String userId,
    required String venueId,
    required DateTime createdAt,
    VenueModel? venue,
  }) = _FavoriteVenueModel;

  const FavoriteVenueModel._();

  factory FavoriteVenueModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteVenueModelFromJson(json);

  Map<String, dynamic> toJson();
}
