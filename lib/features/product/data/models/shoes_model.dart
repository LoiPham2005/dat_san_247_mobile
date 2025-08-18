import 'package:dat_san_247_mobile/features/product/data/models/product_model.dart';
import 'package:dat_san_247_mobile/features/product/data/models/variant_model.dart';

class Shoes {
  String? id;
  List<Media>? media;
  String? name;
  String? description;
  Brand? brandId;
  String? status;
  Category? categoryId;
  String? createdAt;
  String? updateAt;
  List<Variants>? variants;

  Shoes(
      {this.id,
      this.media,
      this.name,
      this.description,
      this.brandId,
      this.status,
      this.categoryId,
      this.createdAt,
      this.updateAt,
      this.variants});

  Shoes.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    name = json['name'];
    description = json['description'];
    brandId =
        json['brand_id'] != null ? new Brand.fromJson(json['brand_id']) : null;
    status = json['status'];
    categoryId = json['category_id'] != null
        ? new Category.fromJson(json['category_id'])
        : null;
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.brandId != null) {
      data['brand_id'] = this.brandId!.toJson();
    }
    data['status'] = this.status;
    if (this.categoryId != null) {
      data['category_id'] = this.categoryId!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
