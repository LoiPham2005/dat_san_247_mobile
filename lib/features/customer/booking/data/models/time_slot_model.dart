import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_model.freezed.dart';
part 'time_slot_model.g.dart';

enum TimeSlotStatus {
  AVAILABLE,
  BOOKED,
  MAINTENANCE,
  CLOSED,
}

@freezed
abstract class TimeSlotModel with _$TimeSlotModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TimeSlotModel({
    required String startTime, // Format: "HH:mm" (e.g., "07:00")
    required String endTime, // Format: "HH:mm" (e.g., "08:00")
    required double price, // Real-time calculated price based on pricing_rules & holidays
    required TimeSlotStatus status,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => _$TimeSlotModelFromJson(json);
}
