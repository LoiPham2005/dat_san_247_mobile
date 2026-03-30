import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history_model.freezed.dart';
part 'search_history_model.g.dart';

@freezed
abstract class SearchHistoryModel with _$SearchHistoryModel {
  const factory SearchHistoryModel({
    required String id,
    @JsonKey(name: 'keyword') String? searchQuery, // Matching backend format in venuesQueryService
    @JsonKey(name: 'searched_at') DateTime? createdAt, // Matching backend
    Map<String, dynamic>? filters, // Backend returns filters object
  }) = _SearchHistoryModel;

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => _$SearchHistoryModelFromJson(json);
}
