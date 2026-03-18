import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'time_slot_model.g.dart';

enum TimeSlotStatus {
  AVAILABLE,
  BOOKED,
  MAINTENANCE,
  CLOSED,
}

@JsonSerializable()
class TimeSlotModel extends Equatable {
  @JsonKey(name: 'start_time')
  final String startTime; // Format: "HH:mm" (e.g., "07:00")
  
  @JsonKey(name: 'end_time')
  final String endTime;   // Format: "HH:mm" (e.g., "08:00")
  
  final double price;     // Real-time calculated price based on pricing_rules & holidays
  
  final TimeSlotStatus status;

  const TimeSlotModel({
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => _$TimeSlotModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);

  @override
  List<Object?> get props => [startTime, endTime, price, status];
}
