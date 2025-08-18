class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? sex;
  String? role;
  String? birthDate;
  String? refreshToken;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.phone,
      this.sex,
      this.role,
      this.birthDate,
      this.refreshToken,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    sex = json['sex'];
    role = json['role'];
    birthDate = json['birthDate'];
    refreshToken = json['refreshToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['sex'] = this.sex;
    data['role'] = this.role;
    data['birthDate'] = this.birthDate;
    data['refreshToken'] = this.refreshToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
