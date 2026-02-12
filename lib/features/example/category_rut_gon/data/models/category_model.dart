// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/data/category_model.dart
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryRutGonModel extends Equatable {
  final int categoryId;
  final String categoryName;
  final String? description;
  final String? iconUrl;
  final String? cloudinaryId;
  final String status;
  final int displayOrder;
  final DateTime createdAt;

  const CategoryRutGonModel({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.iconUrl,
    this.cloudinaryId,
    required this.status,
    required this.displayOrder,
    required this.createdAt,
  });

  factory CategoryRutGonModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryRutGonModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryRutGonModelToJson(this);

  @override
  List<Object?> get props => [
    categoryId,
    categoryName,
    description,
    iconUrl,
    cloudinaryId,
    status,
    displayOrder,
    createdAt,
  ];
  
}
