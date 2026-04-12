import 'package:freezed_annotation/freezed_annotation.dart';

part 'waitlist_model.freezed.dart';
part 'waitlist_model.g.dart';

enum WaitlistStatus {
  @JsonValue('WAITING')
  WAITING,
  @JsonValue('NOTIFIED')
  NOTIFIED,
  @JsonValue('BOOKED')
  BOOKED,
  @JsonValue('EXPIRED')
  EXPIRED,
  @JsonValue('CANCELLED')
  CANCELLED;

  String get label {
    return switch (this) {
      WaitlistStatus.WAITING => 'Đang chờ',
      WaitlistStatus.NOTIFIED => 'Đã có sân',
      WaitlistStatus.BOOKED => 'Đã đặt',
      WaitlistStatus.EXPIRED => 'Hết hạn',
      WaitlistStatus.CANCELLED => 'Đã hủy',
    };
  }
}

@freezed
abstract class WaitlistModel with _$WaitlistModel {
  const factory WaitlistModel({
    required String id,
    @JsonKey(name: 'venue_name') required String venueName,
    @JsonKey(name: 'court_name') required String courtName,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required int priority,
    required WaitlistStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WaitlistModel;

  factory WaitlistModel.fromJson(Map<String, dynamic> json) => _$WaitlistModelFromJson(json);
}
