import 'package:json_annotation/json_annotation.dart';
import 'court_model.dart';
import 'operating_hours_model.dart';
part 'venue_detail_model.g.dart';

@JsonSerializable()
class VenueDetailModel {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  final String name;
  final String slug;
  final String? description;
  final String address;
  final String city;
  final String district;
  final String ward;
  final String? phone;
  final String? email;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  
  @JsonKey(name: 'fb_url')
  final String? fbUrl;
  @JsonKey(name: 'zalo_url')
  final String? zaloUrl;
  @JsonKey(name: 'instagram_url')
  final String? instagramUrl;
  @JsonKey(name: 'youtube_url')
  final String? youtubeUrl;

  final String status;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;

  final double rating;
  @JsonKey(name: 'rating_cleanliness')
  final double ratingCleanliness;
  @JsonKey(name: 'rating_facilities')
  final double ratingFacilities;
  @JsonKey(name: 'rating_staff')
  final double ratingStaff;
  @JsonKey(name: 'total_reviews')
  final int totalReviews;

  final List<CourtModel>? courts;
  @JsonKey(name: 'media_attachments')
  final List<MediaAttachmentModel>? mediaAttachments;
  @JsonKey(name: 'venue_operating_hours')
  final List<OperatingHoursModel>? operatingHours;
  @JsonKey(name: 'venue_schedule_exceptions')
  final List<VenueScheduleExceptionModel>? scheduleExceptions;
  final List<AmenityModel>? amenities;

  final double? latitude;
  final double? longitude;

  VenueDetailModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.slug,
    this.description,
    required this.address,
    required this.city,
    required this.district,
    required this.ward,
    this.phone,
    this.email,
    this.thumbnailUrl,
    this.fbUrl,
    this.zaloUrl,
    this.instagramUrl,
    this.youtubeUrl,
    required this.status,
    required this.isActive,
    required this.isFeatured,
    required this.rating,
    required this.ratingCleanliness,
    required this.ratingFacilities,
    required this.ratingStaff,
    required this.totalReviews,
    this.courts,
    this.mediaAttachments,
    this.operatingHours,
    this.scheduleExceptions,
    this.amenities,
    this.latitude,
    this.longitude,
  });

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VenueDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueDetailModelToJson(this);
}
