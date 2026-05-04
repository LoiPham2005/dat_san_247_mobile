import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/repositories/owner_booking_repository.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_calendar_notifier.g.dart';

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
        selectedCourtId:
            clearCourt ? null : (selectedCourtId ?? this.selectedCourtId),
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
      .map((b) =>
          DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day))
      .toSet();

  Set<DateTime> get daysWithPending => bookings
      .where((b) => b.status == BookingStatus.PENDING)
      .map((b) =>
          DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day))
      .toSet();
}

@riverpod
class OwnerCalendarNotifier extends _$OwnerCalendarNotifier
    with BaseNotifier<OwnerCalendarState> {
  late final OwnerBookingRepository _repository;
  late final OwnerVenueRepository _venueRepository;
  late final String _venueId;

  @override
  Future<OwnerCalendarState> build(String venueId) async {
    _repository = getIt<OwnerBookingRepository>();
    _venueRepository = getIt<OwnerVenueRepository>();
    _venueId = venueId;

    final initial = OwnerCalendarState(
      focusedDay: DateTime.now(),
      selectedDay: DateTime.now(),
    );

    final coursesRes = await _venueRepository.getVenueCourts(venueId);
    final courts = coursesRes.fold(onSuccess: (c) => c, onFailure: (_) => <OwnerCourtModel>[]);

    final bookings = await _fetchBookings(initial.focusedDay);
    return initial.copyWith(courts: courts, bookings: bookings);
  }

  Future<List<OwnerBookingModel>> _fetchBookings(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1).subtract(const Duration(days: 7));
    final lastDay = DateTime(month.year, month.month + 1, 0).add(const Duration(days: 7));
    final result = await _repository.getCalendarBookings(
      _venueId,
      startDate: firstDay,
      endDate: lastDay,
    );
    return result.fold(
      onSuccess: (b) => b,
      onFailure: (f) => throw f,
    );
  }

  Future<void> fetchBookings({DateTime? month}) async {
    final current = currentData;
    if (current == null) return;
    final target = month ?? current.focusedDay;
    await runAsync(
      action: () async => current.copyWith(bookings: await _fetchBookings(target)),
      keepPreviousOnLoading: true,
    );
  }

  Future<void> fetchCourts() async {
    final current = currentData;
    if (current == null) return;
    final result = await _venueRepository.getVenueCourts(_venueId);
    result.fold(
      onSuccess: (courts) {
        state = AsyncData(current.copyWith(courts: courts));
      },
      onFailure: (_) {},
    );
  }

  void updateDaySelection(DateTime sel, DateTime foc) {
    final current = currentData;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedDay: sel, focusedDay: foc));
  }

  void updatePage(DateTime foc) {
    final current = currentData;
    if (current == null) return;
    state = AsyncData(current.copyWith(focusedDay: foc));
  }

  void setCourt(String? courtId) {
    final current = currentData;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      selectedCourtId: courtId,
      clearCourt: courtId == null,
    ));
  }
}
