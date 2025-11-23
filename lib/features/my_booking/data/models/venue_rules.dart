class VenueRules {
  String? rule;

  VenueRules({this.rule});

  VenueRules.fromJson(Map<String, dynamic> json) {
    rule = json['rule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rule'] = this.rule;
    return data;
  }
}