import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'booking_waitlist_model.g.dart';

enum WaitlistStatus {
  WAITING,
  NOTIFIED,
  BOOKED,
  EXPIRED,
  CANCELLED,
}

@JsonSerializable()
class BookingWaitlistModel extends Equatable {
  final String? id;
  
  @JsonKey(name: 'user_id')
  final String userId;
  
  @JsonKey(name: 'court_id')
  final String courtId;
  
  @JsonKey(name: 'booking_date')
  final DateTime bookingDate;
  
  @JsonKey(name: 'start_time')
  final String startTime;
  
  @JsonKey(name: 'end_time')
  final String endTime;
  
  final int priority;
  
  @JsonKey(name: 'is_notified')
  final bool isNotified;
  
  final WaitlistStatus status;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const BookingWaitlistModel({
    this.id,
    required this.userId,
    required this.courtId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    this.priority = 1,
    this.isNotified = false,
    this.status = WaitlistStatus.WAITING,
    this.createdAt,
  });

  factory BookingWaitlistModel.fromJson(Map<String, dynamic> json) => _$BookingWaitlistModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingWaitlistModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        courtId,
        bookingDate,
        startTime,
        endTime,
        priority,
        isNotified,
        status,
        createdAt,
      ];
}
