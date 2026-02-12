// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/domain/entities/category.dart
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';

/// Category Entity — Pure Dart 3.x (Không cần freezed)
class Category extends Equatable {
  final int categoryId;
  final String categoryName;
  final String? description;
  final String? iconUrl;
  final String? cloudinaryId;
  final String status;
  final int displayOrder;
  final DateTime createdAt;

  const Category({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.iconUrl,
    this.cloudinaryId,
    required this.status,
    required this.displayOrder,
    required this.createdAt,
  });

  Category copyWith({
    int? categoryId,
    String? categoryName,
    String? description,
    String? iconUrl,
    String? cloudinaryId,
    String? status,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      cloudinaryId: cloudinaryId ?? this.cloudinaryId,
      status: status ?? this.status,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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

  @override
  String toString() =>
      'Category(categoryId: $categoryId, categoryName: $categoryName, status: $status)';
}
