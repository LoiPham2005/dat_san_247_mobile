class Banner {
  int? bannerId;
  String? title;
  String? mediaUrl;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Banner(
      {this.bannerId,
      this.title,
      this.mediaUrl,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  Banner.fromJson(Map<String, dynamic> json) {
    bannerId = json['bannerId'];
    title = json['title'];
    mediaUrl = json['mediaUrl'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerId'] = this.bannerId;
    data['title'] = this.title;
    data['mediaUrl'] = this.mediaUrl;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
