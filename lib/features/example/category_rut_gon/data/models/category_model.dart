// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/data/category_model.dart
// ════════════════════════════════════════════════════════════════
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryRutGonModel with _$CategoryRutGonModel {
  const factory CategoryRutGonModel({
    required int categoryId,
    required String categoryName,
    String? description,
    String? iconUrl,
    String? cloudinaryId,
    required String status,
    required int displayOrder,
    required DateTime createdAt,
  }) = _CategoryRutGonModel;

  factory CategoryRutGonModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryRutGonModelFromJson(json);
}
