import 'package:json_annotation/json_annotation.dart';

part 'operating_hours_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum DayOfWeek {
  @JsonValue('MONDAY')
  monday,
  @JsonValue('TUESDAY')
  tuesday,
  @JsonValue('WEDNESDAY')
  wednesday,
  @JsonValue('THURSDAY')
  thursday,
  @JsonValue('FRIDAY')
  friday,
  @JsonValue('SATURDAY')
  saturday,
  @JsonValue('SUNDAY')
  sunday,
}

@JsonSerializable()
class OperatingHoursModel {
  final String id;
  @JsonKey(name: 'venue_id')
  final String venueId;
  @JsonKey(name: 'day_of_week')
  final DayOfWeek dayOfWeek;
  @JsonKey(name: 'open_time')
  final String openTime;
  @JsonKey(name: 'close_time')
  final String closeTime;
  @JsonKey(name: 'is_closed')
  final bool isClosed;

  OperatingHoursModel({
    required this.id,
    required this.venueId,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });

  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursModelFromJson(json);
  Map<String, dynamic> toJson() => _$OperatingHoursModelToJson(this);
}

@JsonSerializable()
class VenueScheduleExceptionModel {
  final String id;
  @JsonKey(name: 'venue_id')
  final String venueId;
  final DateTime date;
  @JsonKey(name: 'open_time')
  final String? openTime;
  @JsonKey(name: 'close_time')
  final String? closeTime;
  @JsonKey(name: 'is_closed')
  final bool isClosed;

  VenueScheduleExceptionModel({
    required this.id,
    required this.venueId,
    required this.date,
    this.openTime,
    this.closeTime,
    required this.isClosed,
  });

  factory VenueScheduleExceptionModel.fromJson(Map<String, dynamic> json) =>
      _$VenueScheduleExceptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueScheduleExceptionModelToJson(this);
}
