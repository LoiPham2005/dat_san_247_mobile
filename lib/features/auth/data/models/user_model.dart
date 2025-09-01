class User {
  final int? id;
  final String? fullname;
  final String? username;
  final String? email;
  final String? phone;
  final String? gender;
  final String? birthDate;
  final String? avatar;
  final String? role;
  final bool? isVerified;
  final bool? isActive;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? provider;
  final String? providerId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  User({
    this.id,
    this.fullname,
    this.username,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.avatar,
    this.role,
    this.isVerified,
    this.isActive,
    this.emailVerified,
    this.phoneVerified,
    this.address,
    this.latitude,
    this.longitude,
    this.provider,
    this.providerId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      avatar: json['avatar'],
      role: json['role'],
      isVerified: json['isVerified'],
      isActive: json['isActive'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      provider: json['provider'],
      providerId: json['providerId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birthDate': birthDate,
      'avatar': avatar,
      'role': role,
      'isVerified': isVerified,
      'isActive': isActive,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'provider': provider,
      'providerId': providerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
