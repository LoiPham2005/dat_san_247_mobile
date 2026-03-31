import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_schedule_state.freezed.dart';

@freezed
abstract class StaffScheduleState with _$StaffScheduleState {
  const factory StaffScheduleState({
    @Default(BaseStatus.initial) BaseStatus status,
    @Default([]) List<TodayCourtScheduleModel> schedules,
    @Default([]) List<CheckInBookingModel> rawBookings,
    String? errorMessage,
    DateTime? selectedDate,
    String? selectedCourtId,
    @Default(false) bool isRefreshing,
  }) = _StaffScheduleState;
}
