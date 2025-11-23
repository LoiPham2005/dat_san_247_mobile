class Amenities {
  String? name;
  bool? available;

  Amenities({this.name, this.available});

  Amenities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['available'] = this.available;
    return data;
  }
}