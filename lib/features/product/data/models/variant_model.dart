
import 'package:dat_san_247_mobile/features/product/data/models/product_model.dart';

class Variants {
  String? id;
  String? shoesId;
  int? price;
  int? quantityInStock;
  SizeModel? sizeId;
  Color? colorId;
  String? status;
  String? createdAt;
  String? updateAt;

  Variants(
      {this.id,
      this.shoesId,
      this.price,
      this.quantityInStock,
      this.sizeId,
      this.colorId,
      this.status,
      this.createdAt,
      this.updateAt});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    shoesId = json['shoes_id'];
    price = json['price'];
    quantityInStock = json['quantity_in_stock'];
    sizeId = json['size_id'] != null
        ? new SizeModel.fromJson(json['size_id'])
        : null;
    colorId =
        json['color_id'] != null ? new Color.fromJson(json['color_id']) : null;
    status = json['status'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['shoes_id'] = this.shoesId;
    data['price'] = this.price;
    data['quantity_in_stock'] = this.quantityInStock;
    if (this.sizeId != null) {
      data['size_id'] = this.sizeId!.toJson();
    }
    if (this.colorId != null) {
      data['color_id'] = this.colorId!.toJson();
    }
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}