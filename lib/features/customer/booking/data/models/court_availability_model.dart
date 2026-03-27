import 'package:freezed_annotation/freezed_annotation.dart';

import 'time_slot_model.dart';

part 'court_availability_model.freezed.dart';
part 'court_availability_model.g.dart';

@freezed
abstract class CourtAvailabilityModel with _$CourtAvailabilityModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CourtAvailabilityModel({
    required String courtId,
    required DateTime date,
    @Default(false) bool isClosed,
    String? closeReason, // From venue_schedule_exceptions
    @Default([])
    List<TimeSlotModel> slots, // Calculated from bookings, maintenance, pricing_rules...
  }) = _CourtAvailabilityModel;

  factory CourtAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$CourtAvailabilityModelFromJson(json);
}
