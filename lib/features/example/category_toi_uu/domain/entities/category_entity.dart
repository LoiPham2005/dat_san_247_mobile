// ════════════════════════════════════════════════════════════════
// 📁 category_toi_uu/domain/entities/category_entity.dart
// ════════════════════════════════════════════════════════════════
import 'package:equatable/equatable.dart';

/// 🎯 Category Entity — Pure Dart 3.x (Domain Layer)
///
/// Entity chỉ chứa business data, KHÔNG phụ thuộc API/Framework.
/// Dùng Equatable để so sánh value-based (tránh rebuild UI không cần thiết).
class CategoryEntity extends Equatable {
  final int categoryId;
  final String categoryName;
  final String? description;
  final String? iconUrl;
  final String? cloudinaryId;
  final String status;
  final int displayOrder;
  final DateTime createdAt;

  const CategoryEntity({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.iconUrl,
    this.cloudinaryId,
    required this.status,
    required this.displayOrder,
    required this.createdAt,
  });

  /// Kiểm tra category có đang active không
  bool get isActive => status.toLowerCase() == 'active';

  /// copyWith — Tạo bản sao với một vài field thay đổi
  CategoryEntity copyWith({
    int? categoryId,
    String? categoryName,
    String? description,
    String? iconUrl,
    String? cloudinaryId,
    String? status,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return CategoryEntity(
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
  String toString() => 'CategoryEntity(id: $categoryId, name: $categoryName, status: $status)';
}
