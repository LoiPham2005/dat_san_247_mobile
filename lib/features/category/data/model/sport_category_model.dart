import 'package:dat_san_247_mobile/features/category/domain/entities/sport_category_entity.dart';

class SportCategoryModel extends SportCategoryEntity {
  int? categoryId;
  String? categoryName;
  String? description;
  String? iconUrl;
  String? status;
  int? displayOrder;
  String? createdAt;

  SportCategoryModel(
      {this.categoryId,
      this.categoryName,
      this.description,
      this.iconUrl,
      this.status,
      this.displayOrder,
      this.createdAt});

  SportCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    description = json['description'];
    iconUrl = json['iconUrl'];
    status = json['status'];
    displayOrder = json['displayOrder'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['description'] = this.description;
    data['iconUrl'] = this.iconUrl;
    data['status'] = this.status;
    data['displayOrder'] = this.displayOrder;
    data['createdAt'] = this.createdAt;
    return data;
  }

  SportCategoryEntity toEntity() {
    return SportCategoryEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      iconUrl: iconUrl,
      status: status,
      displayOrder: displayOrder,
      createdAt: createdAt,
    );
  }
}
