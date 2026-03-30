import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/repositories/owner_booking_repository.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

class OwnerCalendarState {
  final List<OwnerBookingModel> bookings;
  final List<OwnerCourtModel> courts;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final String? selectedCourtId;

  OwnerCalendarState({
    this.bookings = const [],
    this.courts = const [],
    required this.focusedDay,
    required this.selectedDay,
    this.selectedCourtId,
  });

  OwnerCalendarState copyWith({
    List<OwnerBookingModel>? bookings,
    List<OwnerCourtModel>? courts,
    DateTime? focusedDay,
    DateTime? selectedDay,
    String? selectedCourtId,
    bool clearCourt = false,
  }) =>
      OwnerCalendarState(
        bookings: bookings ?? this.bookings,
        courts: courts ?? this.courts,
        focusedDay: focusedDay ?? this.focusedDay,
        selectedDay: selectedDay ?? this.selectedDay,
        selectedCourtId: clearCourt ? null : (selectedCourtId ?? this.selectedCourtId),
      );

  List<OwnerBookingModel> get dayBookings {
    final sel = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    return bookings.where((b) {
      final bd = DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day);
      final matchDay = bd == sel;
      final matchCourt = selectedCourtId == null || b.courtId == selectedCourtId;
      return matchDay && matchCourt;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Set<DateTime> get daysWithBookings => bookings
      .map((b) => DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day))
      .toSet();

  Set<DateTime> get daysWithPending => bookings
      .where((b) => b.status == BookingStatus.PENDING)
      .map((b) => DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day))
      .toSet();
}

@injectable
class OwnerCalendarCubit extends BaseCubit<OwnerCalendarState> {
  final OwnerBookingRepository _repository;
  final OwnerVenueRepository _venueRepository;

  OwnerCalendarCubit(this._repository, this._venueRepository)
      : super(BaseState.success(
          data: OwnerCalendarState(
            focusedDay: DateTime.now(),
            selectedDay: DateTime.now(),
          ),
        ));

  Future<void> fetchAll(String venueId, {DateTime? month}) async {
    await fetchCourts(venueId);
    await fetchBookings(venueId, month: month);
  }

  Future<void> fetchCourts(String venueId) async {
    final result = await _venueRepository.getVenueCourts(venueId);
    result.fold(
      onFailure: (f) => null, // Keep existing courts or handle error
      onSuccess: (courts) {
        safeEmit(BaseState.success(data: state.data!.copyWith(courts: courts)));
      },
    );
  }

  Future<void> fetchBookings(String venueId, {DateTime? month}) async {
    final now = month ?? state.data?.focusedDay ?? DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1).subtract(const Duration(days: 7));
    final lastDay = DateTime(now.year, now.month + 1, 0).add(const Duration(days: 7));

    await run<List<OwnerBookingModel>>(
      action: () => _repository.getCalendarBookings(
        venueId,
        startDate: firstDay,
        endDate: lastDay,
      ),
      mapper: (bookings) => state.data!.copyWith(bookings: bookings),
    );
  }

  void updateDaySelection(DateTime sel, DateTime foc) {
    safeEmit(BaseState.success(data: state.data!.copyWith(selectedDay: sel, focusedDay: foc)));
  }

  void updatePage(DateTime foc) {
    safeEmit(BaseState.success(data: state.data!.copyWith(focusedDay: foc)));
  }

  void setCourt(String? courtId) {
    safeEmit(BaseState.success(
      data: state.data!.copyWith(
        selectedCourtId: courtId,
        clearCourt: courtId == null,
      ),
    ));
  }
}
