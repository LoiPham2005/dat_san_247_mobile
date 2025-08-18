// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dat_san_247_mobile/features/product/data/models/shoes_model.dart';

class ProductModel {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  List<Shoes>? shoes;

  ProductModel(
      {this.currentPage,
      this.totalPages,
      this.totalItems,
      this.itemsPerPage,
      this.shoes});

  ProductModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
    if (json['shoes'] != null) {
      shoes = <Shoes>[];
      json['shoes'].forEach((v) {
        shoes!.add(new Shoes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalItems'] = this.totalItems;
    data['itemsPerPage'] = this.itemsPerPage;
    if (this.shoes != null) {
      data['shoes'] = this.shoes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Media {
  String? type;
  String? url;
  String? id;

  Media({this.type, this.url, this.id});

  Media.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['_id'] = this.id;
    return data;
  }
}

class Brand {
  String? id;
  String? media;
  String? name;
  String? createdAt;
  String? updatedAt;

  Brand({this.id, this.media, this.name, this.createdAt, this.updatedAt});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    media = json['media'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['media'] = this.media;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Category {
  String? id;
  String? media;
  String? name;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.media, this.name, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    media = json['media'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['media'] = this.media;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}


class SizeModel {
  String? sizeValue;
  String? createdAt;
  String? updatedAt;
  String? id;

  SizeModel({this.sizeValue, this.createdAt, this.updatedAt, this.id});

  SizeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sizeValue = json['size_value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['size_value'] = this.sizeValue;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
  

  SizeModel copyWith({
    String? sizeValue,
    String? createdAt,
    String? updatedAt,
    String? id,
  }) {
    return SizeModel(
      sizeValue: sizeValue ?? this.sizeValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
    );
  }
}

class Color {
  String? id;
  String? name;
  String? value;
  String? createdAt;
  String? updatedAt;

  Color({this.id, this.name, this.value, this.createdAt, this.updatedAt});

  Color.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    value = json['value'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
