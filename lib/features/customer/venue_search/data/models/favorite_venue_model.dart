import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';

part 'favorite_venue_model.g.dart';

@JsonSerializable()
class FavoriteVenueModel extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'venue_id')
  final String venueId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  // Optional inclusion of venue details when fetching favorites
  final VenueModel? venue;

  const FavoriteVenueModel({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.createdAt,
    this.venue,
  });

  factory FavoriteVenueModel.fromJson(Map<String, dynamic> json) => _$FavoriteVenueModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteVenueModelToJson(this);

  @override
  List<Object?> get props => [id, userId, venueId, createdAt, venue];
}
