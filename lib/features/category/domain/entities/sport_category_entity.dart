import 'package:equatable/equatable.dart';

class SportCategoryEntity extends Equatable {
  int? categoryId;
  String? categoryName;
  String? description;
  String? iconUrl;
  String? status;
  int? displayOrder;
  String? createdAt;

  SportCategoryEntity({
    this.categoryId,
    this.categoryName,
    this.description,
    this.iconUrl,
    this.status,
    this.displayOrder,
    this.createdAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        categoryId,
        categoryName,
        description,
        iconUrl,
        status,
        displayOrder,
        createdAt,
      ];
}
