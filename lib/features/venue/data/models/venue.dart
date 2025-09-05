import 'package:dat_san_247_mobile/features/auth/data/models/user_model.dart';
import 'package:dat_san_247_mobile/features/category/data/model/sport_category.dart';
import 'package:dat_san_247_mobile/features/venue/data/models/amenities.dart';
import 'package:dat_san_247_mobile/features/venue/data/models/venue_images.dart';
import 'package:dat_san_247_mobile/features/venue/data/models/venue_rules.dart';

class Venue {
  int? venueId;
  int? ownerId;
  User? owner;
  String? venueName;
  String? description;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  int? categoryId;
  SportCategory? category;
  int? capacity;
  String? status;
  String? averageRating;
  int? totalReviews;
  int? totalBookings;
  List<Amenities>? amenities;
  List<VenueRules>? venueRules;
  String? createdAt;
  String? updatedAt;
  int? mainImageId;        // <- thay Null? bằng int?
  dynamic mainImage;       // <- thay Null? bằng dynamic (có thể null, String, Map)
  List<VenueImages>? images;

  Venue(
      {this.venueId,
      this.ownerId,
      this.owner,
      this.venueName,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.phone,
      this.email,
      this.categoryId,
      this.category,
      this.capacity,
      this.status,
      this.averageRating,
      this.totalReviews,
      this.totalBookings,
      this.amenities,
      this.venueRules,
      this.createdAt,
      this.updatedAt,
      this.mainImageId,
      this.mainImage,
      this.images});

  Venue.fromJson(Map<String, dynamic> json) {
    venueId = json['venueId'];
    ownerId = json['ownerId'];
    owner = json['owner'] != null ? new User.fromJson(json['owner']) : null;
    venueName = json['venueName'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    email = json['email'];
    categoryId = json['categoryId'];
    category = json['category'] != null
        ? new SportCategory.fromJson(json['category'])
        : null;
    capacity = json['capacity'];
    status = json['status'];
    averageRating = json['averageRating'];
    totalReviews = json['totalReviews'];
    totalBookings = json['totalBookings'];
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(new Amenities.fromJson(v));
      });
    }
    if (json['venueRules'] != null) {
      venueRules = <VenueRules>[];
      json['venueRules'].forEach((v) {
        venueRules!.add(new VenueRules.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    mainImageId = json['mainImageId'];
    mainImage = json['mainImage'];
    if (json['images'] != null) {
      images = <VenueImages>[];
      json['images'].forEach((v) {
        images!.add(new VenueImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['venueId'] = this.venueId;
    data['ownerId'] = this.ownerId;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    data['venueName'] = this.venueName;
    data['description'] = this.description;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['categoryId'] = this.categoryId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['capacity'] = this.capacity;
    data['status'] = this.status;
    data['averageRating'] = this.averageRating;
    data['totalReviews'] = this.totalReviews;
    data['totalBookings'] = this.totalBookings;
    if (this.amenities != null) {
      data['amenities'] = this.amenities!.map((v) => v.toJson()).toList();
    }
    if (this.venueRules != null) {
      data['venueRules'] = this.venueRules!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['mainImageId'] = this.mainImageId;
    data['mainImage'] = this.mainImage;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

