import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/core/common/extensions/datetime_extensions.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/data/services/staff_schedule_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_schedule_notifier.freezed.dart';
part 'staff_schedule_notifier.g.dart';

@freezed
abstract class StaffScheduleData with _$StaffScheduleData {
  const factory StaffScheduleData({
    @Default([]) List<TodayCourtScheduleModel> schedules,
    @Default([]) List<CheckInBookingModel> rawBookings,
    DateTime? selectedDate,
    String? selectedCourtId,
  }) = _StaffScheduleData;
}

@riverpod
class StaffScheduleNotifier extends _$StaffScheduleNotifier
    with BaseNotifier<StaffScheduleData> {
  late final StaffScheduleService _service;

  @override
  Future<StaffScheduleData> build() async {
    _service = getIt<StaffScheduleService>();
    final now = DateTime.now();
    return _fetch(selectedDate: now);
  }

  Future<StaffScheduleData> _fetch({DateTime? selectedDate, String? courtId}) async {
    final date = selectedDate ?? currentData?.selectedDate ?? DateTime.now();
    final dateStr = date.format('yyyy-MM-dd');
    final response = await _service.getSchedule(date: dateStr);
    final bookings = response.data?.data ?? [];
    return StaffScheduleData(
      rawBookings: bookings,
      schedules: _groupSchedules(bookings),
      selectedDate: date,
      selectedCourtId: courtId ?? currentData?.selectedCourtId,
    );
  }

  Future<void> fetchSchedule({bool isRefreshing = false}) => runAsync(
        action: () => _fetch(),
        keepPreviousOnLoading: isRefreshing,
      );

  List<TodayCourtScheduleModel> _groupSchedules(List<CheckInBookingModel> bookings) {
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
    final current = currentData;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedCourtId: courtId));
  }

  Future<void> updateBookingStatus(String id, BookingStatusVS status) async {
    try {
      await _service.updateStatus(id, {'status': status.name});
      await fetchSchedule(isRefreshing: true);
    } catch (_) {}
  }
}
