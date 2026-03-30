import 'package:freezed_annotation/freezed_annotation.dart';

part 'operating_hours_model.freezed.dart';
part 'operating_hours_model.g.dart';

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

@freezed
abstract class OperatingHoursModel with _$OperatingHoursModel {
  const factory OperatingHoursModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    @JsonKey(name: 'day_of_week') required DayOfWeek dayOfWeek,
    @JsonKey(name: 'open_time') required String openTime,
    @JsonKey(name: 'close_time') required String closeTime,
    @JsonKey(name: 'is_closed') @Default(false) bool isClosed,
  }) = _OperatingHoursModel;

  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) => _$OperatingHoursModelFromJson(json);
}

@freezed
abstract class VenueScheduleExceptionModel with _$VenueScheduleExceptionModel {
  const factory VenueScheduleExceptionModel({
    required String id,
    @JsonKey(name: 'venue_id') required String venueId,
    required DateTime date,
    @JsonKey(name: 'open_time') String? openTime,
    @JsonKey(name: 'close_time') String? closeTime,
    @JsonKey(name: 'is_closed') @Default(false) bool isClosed,
  }) = _VenueScheduleExceptionModel;

  factory VenueScheduleExceptionModel.fromJson(Map<String, dynamic> json) => _$VenueScheduleExceptionModelFromJson(json);
}
