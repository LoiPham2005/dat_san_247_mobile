import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history_model.freezed.dart';
part 'search_history_model.g.dart';

@freezed
abstract class SearchHistoryModel with _$SearchHistoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SearchHistoryModel({
    required String id,
    required String userId,
    String? sportType,
    String? city,
    String? district,
    String? searchQuery,
    required DateTime createdAt,
  }) = _SearchHistoryModel;

  const SearchHistoryModel._();

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryModelFromJson(json);

  Map<String, dynamic> toJson();
}
