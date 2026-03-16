import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'search_history_model.g.dart';

@JsonSerializable()
class SearchHistoryModel extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'sport_type')
  final String? sportType;
  final String? city;
  final String? district;
  @JsonKey(name: 'search_query')
  final String? searchQuery;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const SearchHistoryModel({
    required this.id,
    required this.userId,
    this.sportType,
    this.city,
    this.district,
    this.searchQuery,
    required this.createdAt,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => _$SearchHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchHistoryModelToJson(this);

  @override
  List<Object?> get props => [id, userId, sportType, city, district, searchQuery, createdAt];
}
