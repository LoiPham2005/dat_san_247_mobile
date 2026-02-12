// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/data/models/category_model.dart
// ════════════════════════════════════════════════════════════════
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/// CategoryModel — Dùng json_serializable (Không cần freezed)
@JsonSerializable()
class CategoryModel {
  final int categoryId;
  final String categoryName;
  final String? description;
  final String? iconUrl;
  final String? cloudinaryId;
  final String status;
  final int displayOrder;
  final DateTime createdAt;

  const CategoryModel({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.iconUrl,
    this.cloudinaryId,
    required this.status,
    required this.displayOrder,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Model → Entity
  Category toEntity() => Category(
    categoryId: categoryId,
    categoryName: categoryName,
    description: description,
    iconUrl: iconUrl,
    cloudinaryId: cloudinaryId,
    status: status,
    displayOrder: displayOrder,
    createdAt: createdAt,
  );

  /// Entity → Model
  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
    categoryId: entity.categoryId,
    categoryName: entity.categoryName,
    description: entity.description,
    iconUrl: entity.iconUrl,
    cloudinaryId: entity.cloudinaryId,
    status: entity.status,
    displayOrder: entity.displayOrder,
    createdAt: entity.createdAt,
  );

  @override
  String toString() =>
      'CategoryModel(categoryId: $categoryId, categoryName: $categoryName, status: $status)';
}
