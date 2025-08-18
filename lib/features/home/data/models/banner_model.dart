class BannerModel {
  String? id;
  String? media;
  String? createdAt;
  String? updatedAt;

  BannerModel({this.id, this.media, this.createdAt, this.updatedAt});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    media = json['media'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['media'] = this.media;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
