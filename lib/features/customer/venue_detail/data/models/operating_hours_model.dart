import 'package:freezed_annotation/freezed_annotation.dart';

part 'operating_hours_model.freezed.dart';
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

@freezed
abstract class OperatingHoursModel with _$OperatingHoursModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OperatingHoursModel({
    required String id,
    required String venueId,
    required DayOfWeek dayOfWeek,
    required String openTime,
    required String closeTime,
    required bool isClosed,
  }) = _OperatingHoursModel;

  const OperatingHoursModel._();

  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursModelFromJson(json);

  Map<String, dynamic> toJson();
}

@freezed
abstract class VenueScheduleExceptionModel with _$VenueScheduleExceptionModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory VenueScheduleExceptionModel({
    required String id,
    required String venueId,
    required DateTime date,
    String? openTime,
    String? closeTime,
    required bool isClosed,
  }) = _VenueScheduleExceptionModel;

  const VenueScheduleExceptionModel._();

  factory VenueScheduleExceptionModel.fromJson(Map<String, dynamic> json) =>
      _$VenueScheduleExceptionModelFromJson(json);

  Map<String, dynamic> toJson();
}
