import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_booking_model.freezed.dart';
part 'recurring_booking_model.g.dart';

// ── Enums ──────────────────────────────────────────────────────────────────

enum RecurringType {
  DAILY,
  WEEKLY,
  MONTHLY;

  String get label {
    switch (this) {
      case DAILY:
        return 'Hằng ngày';
      case WEEKLY:
        return 'Hằng tuần';
      case MONTHLY:
        return 'Hằng tháng';
    }
  }
}

enum DayOfWeek {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY;

  String get label {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return labels[index];
  }

  String get fullLabel {
    const labels = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật'
    ];
    return labels[index];
  }
}

// ── recurring_bookings model ───────────────────────────────────────────────
@freezed
abstract class RecurringDayModel with _$RecurringDayModel {
  const factory RecurringDayModel({
    @JsonKey(name: 'day_of_week') required DayOfWeek dayOfWeek,
  }) = _RecurringDayModel;

  factory RecurringDayModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringDayModelFromJson(json);
}

@freezed
abstract class RecurringBookingModel with _$RecurringBookingModel {
  const RecurringBookingModel._();

  const factory RecurringBookingModel({
    required String id,
    @JsonKey(name: 'venue_name') String? venueName,
    @JsonKey(name: 'court_name') String? courtName,
    @JsonKey(name: 'repeat_type') required RecurringType repeatType,
    @JsonKey(name: 'start_time') required String startTime, // HH:mm or ISO
    @JsonKey(name: 'end_time') required String endTime, // HH:mm or ISO
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'recurring_days') @Default([]) List<RecurringDayModel> recurringDays,
    @JsonKey(name: 'total_bookings_generated') @Default(0) int totalBookingsGenerated,
  }) = _RecurringBookingModel;

  factory RecurringBookingModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringBookingModelFromJson(json);

  List<DayOfWeek> get days => recurringDays.map((e) => e.dayOfWeek).toList();
}
