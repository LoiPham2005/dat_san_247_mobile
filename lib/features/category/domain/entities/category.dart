import 'package:equatable/equatable.dart';

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
  
  @override
  List<Object?> get props => [
    categoryId, 
    categoryName, 
    description, 
    iconUrl, 
    cloudinaryId,
    status,
    displayOrder,
    createdAt
  ];
}