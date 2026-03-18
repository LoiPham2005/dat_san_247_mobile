import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'time_slot_model.dart';

part 'court_availability_model.g.dart';

@JsonSerializable()
class CourtAvailabilityModel extends Equatable {
  @JsonKey(name: 'court_id')
  final String courtId;
  
  final DateTime date;
  
  @JsonKey(name: 'is_closed')
  final bool isClosed;
  
  @JsonKey(name: 'close_reason')
  final String? closeReason; // From venue_schedule_exceptions
  
  final List<TimeSlotModel> slots; // Calculated from bookings, maintenance, pricing_rules...

  const CourtAvailabilityModel({
    required this.courtId,
    required this.date,
    this.isClosed = false,
    this.closeReason,
    this.slots = const [],
  });

  factory CourtAvailabilityModel.fromJson(Map<String, dynamic> json) => _$CourtAvailabilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourtAvailabilityModelToJson(this);

  @override
  List<Object?> get props => [courtId, date, isClosed, closeReason, slots];
}
