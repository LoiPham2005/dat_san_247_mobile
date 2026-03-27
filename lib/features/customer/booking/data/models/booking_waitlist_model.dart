import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_waitlist_model.freezed.dart';
part 'booking_waitlist_model.g.dart';

enum WaitlistStatus {
  WAITING,
  NOTIFIED,
  BOOKED,
  EXPIRED,
  CANCELLED,
}

@freezed
abstract class BookingWaitlistModel with _$BookingWaitlistModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BookingWaitlistModel({
    String? id,
    required String userId,
    required String courtId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    @Default(1) int priority,
    @Default(false) bool isNotified,
    @Default(WaitlistStatus.WAITING) WaitlistStatus status,
    DateTime? createdAt,
  }) = _BookingWaitlistModel;

  factory BookingWaitlistModel.fromJson(Map<String, dynamic> json) =>
      _$BookingWaitlistModelFromJson(json);
}
