import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/services/staff_schedule_service.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/cubit/staff_schedule_state.dart';
import 'package:dat_san_247_mobile/core/common/extensions/datetime_extensions.dart';
import 'package:injectable/injectable.dart';

@injectable
class StaffScheduleCubit extends Cubit<StaffScheduleState> {
  final StaffScheduleService _service;

  StaffScheduleCubit(this._service) : super(const StaffScheduleState()) {
    _init();
  }

  void _init() {
    final now = DateTime.now();
    emit(state.copyWith(selectedDate: now));
    fetchSchedule();
  }

  Future<void> fetchSchedule({bool isRefreshing = false}) async {
    if (isClosed) return;
    if (isRefreshing) {
      emit(state.copyWith(isRefreshing: true));
    } else {
      emit(state.copyWith(status: BaseStatus.loading));
    }

    try {
      final dateStr = state.selectedDate?.format('yyyy-MM-dd');
      final response = await _service.getSchedule(
        date: dateStr,
      );

      final bookings = response.data?.data ?? [];
      final grouped = _groupSchedules(bookings);

      if (isClosed) return;
      emit(state.copyWith(
        status: grouped.isEmpty ? BaseStatus.empty : BaseStatus.success,
        rawBookings: bookings,
        schedules: grouped,
        isRefreshing: false,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: BaseStatus.failure,
        errorMessage: e.toString(),
        isRefreshing: false,
      ));
    }
  }

  List<TodayCourtScheduleModel> _groupSchedules(List<CheckInBookingModel> bookings) {
    // Map of courtId -> TodayCourtScheduleModel
    final map = <String, TodayCourtScheduleModel>{};

    for (var b in bookings) {
      if (!map.containsKey(b.courtId)) {
        map[b.courtId] = TodayCourtScheduleModel(
          courtId: b.courtId,
          courtName: b.courtName,
          isIndoor: b.isIndoor,
          bookings: [],
        );
      }
      // Since it's a final list in the model, we can't just add to it if it's from @freezed or Equatable
      // But TodayCourtScheduleModel in check_in_models.dart is a simple class (though it uses Equatable)
    }

    // Re-iterate to add bookings (more efficient way: use a temporary mutable list map)
    final tempMap = <String, List<CheckInBookingModel>>{};
    for (var b in bookings) {
      tempMap.putIfAbsent(b.courtId, () => []).add(b);
    }

    return tempMap.entries.map((entry) {
      final first = entry.value.first;
      return TodayCourtScheduleModel(
        courtId: entry.key,
        courtName: first.courtName,
        isIndoor: first.isIndoor,
        bookings: entry.value,
      );
    }).toList();
  }

  void selectCourt(String? courtId) {
    emit(state.copyWith(selectedCourtId: courtId));
  }

  Future<void> updateBookingStatus(String id, BookingStatusVS status) async {
    try {
      await _service.updateStatus(id, {'status': status.name});
      // Refresh local data
      await fetchSchedule();
    } catch (e) {
      // Potentially show a toast or error
    }
  }
}

extension DateTimeFormatX on DateTime {
  String toYMD() => "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
}
