import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_overview_model.freezed.dart';
part 'venue_overview_model.g.dart';

@freezed
abstract class VenueOverviewModel with _$VenueOverviewModel {
  const factory VenueOverviewModel({
    required String venueId,
    required String venueName,
    required String venueAddress,
    required List<CourtOverviewModel> courts,
  }) = _VenueOverviewModel;

  factory VenueOverviewModel.fromJson(Map<String, dynamic> json) => _$VenueOverviewModelFromJson(json);
}

@freezed
abstract class CourtOverviewModel with _$CourtOverviewModel {
  const factory CourtOverviewModel({
    required String id,
    required String name,
    @Default([]) List<TimeSlotModel> slots,
  }) = _CourtOverviewModel;

  factory CourtOverviewModel.fromJson(Map<String, dynamic> json) => _$CourtOverviewModelFromJson(json);
}

@freezed
abstract class TimeSlotModel with _$TimeSlotModel {
  const factory TimeSlotModel({
    required String startTime,
    required String endTime,
    required bool isAvailable,
    @Default(0.0) double price,
    @Default(false) bool isSelected,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => _$TimeSlotModelFromJson(json);
}
