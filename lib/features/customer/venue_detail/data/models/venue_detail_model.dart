import 'package:freezed_annotation/freezed_annotation.dart';
import 'court_model.dart';
import 'operating_hours_model.dart';

part 'venue_detail_model.freezed.dart';
part 'venue_detail_model.g.dart';

@freezed
abstract class VenueDetailModel with _$VenueDetailModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueDetailModel({
    required String id,
    required String ownerId,
    required String name,
    required String slug,
    String? description,
    required String address,
    required String city,
    required String district,
    required String ward,
    String? phone,
    String? email,
    String? thumbnailUrl,
    String? fbUrl,
    String? zaloUrl,
    String? instagramUrl,
    String? youtubeUrl,
    required String status,
    required bool isActive,
    required bool isFeatured,
    required double rating,
    required double ratingCleanliness,
    required double ratingFacilities,
    required double ratingStaff,
    required int totalReviews,
    List<CourtModel>? courts,
    List<MediaAttachmentModel>? mediaAttachments,
    @JsonKey(name: 'venue_operating_hours') List<OperatingHoursModel>? operatingHours,
    @JsonKey(name: 'venue_schedule_exceptions') List<VenueScheduleExceptionModel>? scheduleExceptions,
    List<AmenityModel>? amenities,
    double? latitude,
    double? longitude,
  }) = _VenueDetailModel;

  const VenueDetailModel._();

  factory VenueDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VenueDetailModelFromJson(json);

  Map<String, dynamic> toJson();
}
