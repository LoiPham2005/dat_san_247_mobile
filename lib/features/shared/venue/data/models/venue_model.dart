// ignore_for_file: constant_identifier_names
// Reason: enum values are intentionally UPPER_SNAKE_CASE to match backend Postgres enum string values 1:1.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dat_san_247_mobile/core/common/converters/json_converters.dart';

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
    @StringToDoubleConverter() @Default(0.0) double rating,
    @JsonKey(name: 'total_reviews') @Default(0) int totalReviews,
    @JsonKey(name: 'min_booking_hours') @Default(1) int minBookingHours,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _VenueModel;

  factory VenueModel.fromJson(Map<String, dynamic> json) => _$VenueModelFromJson(json);
}
