import 'package:flutter_base_template/features/category/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.categoryId,
    required super.categoryName,
    super.description,
    super.iconUrl,
    super.cloudinaryId,
    required super.status,
    required super.displayOrder,
    required super.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      cloudinaryId: json['cloudinaryId'] as String?,
      status: json['status'] as String,
      displayOrder: json['displayOrder'] as int,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'iconUrl': iconUrl,
      'cloudinaryId': cloudinaryId,
      'status': status,
      'displayOrder': displayOrder,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Category toEntity() {
    return Category(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      iconUrl: iconUrl,
      cloudinaryId: cloudinaryId,
      status: status,
      displayOrder: displayOrder,
      createdAt: createdAt,
    );
  }
}
 