import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_model.freezed.dart';
part 'venue_model.g.dart';

enum VenueStatus { PENDING, APPROVED, REJECTED, SUSPENDED }

@freezed
abstract class VenueModel with _$VenueModel {
  const factory VenueModel({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    required String slug,
    String? description,
    required String address,
    required String city,
    required String district,
    String? ward,
    String? phone,
    String? email,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @Default(VenueStatus.PENDING) VenueStatus status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'featured_until') DateTime? featuredUntil,
    @Default(0.0) double rating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'min_booking_hours') @Default(1) int minBookingHours,
  }) = _VenueModel;

  factory VenueModel.fromJson(Map<String, dynamic> json) => _$VenueModelFromJson(json);
}
