import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_category_model.freezed.dart';
part 'sport_category_model.g.dart';

@freezed
abstract class SportCategoryModel with _$SportCategoryModel {
  const factory SportCategoryModel({
    required String id,
    required String name,
    required String label,
    String? icon,
    @JsonKey(name: 'is_system') @Default(true) bool isSystem,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _SportCategoryModel;

  factory SportCategoryModel.fromJson(Map<String, dynamic> json) => _$SportCategoryModelFromJson(json);
}
