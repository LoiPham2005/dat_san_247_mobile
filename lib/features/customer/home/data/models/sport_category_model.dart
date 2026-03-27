import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_category_model.freezed.dart';
part 'sport_category_model.g.dart';

@freezed
abstract class SportCategoryModel with _$SportCategoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SportCategoryModel({
    required String id,
    required String name,
    required String label,
    String? icon,
    @Default(true) bool isSystem,
    @Default(true) bool isActive,
  }) = _SportCategoryModel;

  const SportCategoryModel._();

  factory SportCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SportCategoryModelFromJson(json);

  Map<String, dynamic> toJson();
}
