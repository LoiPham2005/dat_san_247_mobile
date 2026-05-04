import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_overview_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/repositories/venue_detail_repository.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_overview_notifier.g.dart';

@riverpod
class VenueOverviewNotifier extends _$VenueOverviewNotifier
    with BaseNotifier<VenueOverviewModel> {
  late final VenueDetailRepository _repository;
  late final String _slug;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  @override
  Future<VenueOverviewModel> build(String slug) async {
    _repository = getIt<VenueDetailRepository>();
    _slug = slug;
    return _fetchSchedule(_selectedDate);
  }

  Future<VenueOverviewModel> _fetchSchedule(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final result = await _repository.getVenueSchedule(_slug, date: dateStr);
    return result.fold(
      onSuccess: (data) => _mapResponseToOverview(data, date),
      onFailure: (f) => throw f,
    );
  }

  Future<void> fetchSchedule(DateTime date) async {
    _selectedDate = date;
    await runAsync(
      action: () => _fetchSchedule(date),
      keepPreviousOnLoading: true,
    );
  }

  VenueOverviewModel _mapResponseToOverview(Map<String, dynamic> data, DateTime date) {
    final courtsJson = data['courts'] as List<dynamic>? ?? [];
    final bookingsJson = data['bookings'] as List<dynamic>? ?? [];
    final dayOfWeek = DateFormat('EEEE').format(date).toUpperCase();

    final timeSlots = <String>[];
    for (int h = 5; h <= 23; h++) {
      timeSlots.add('${h.toString().padLeft(2, '0')}:00');
      timeSlots.add('${h.toString().padLeft(2, '0')}:30');
    }

    final courts = courtsJson.map((c) {
      final courtId = c['id'] as String;
      final courtName = c['name'] as String;
      final defaultPrice = (c['price_per_hour'] as num?)?.toDouble() ?? 0.0;
      final pricingRules = (c['pricing_rules'] as List<dynamic>? ?? []);

      final slots = timeSlots.map((time) {
        double slotPrice = defaultPrice / 2;
        final matchingRule = pricingRules.firstWhere((pr) {
          final ruleStart = pr['start_time'] as String;
          final ruleEnd = pr['end_time'] as String;
          final ruleDay = pr['day_of_week'] as String?;
          final sameDay = ruleDay == null || ruleDay == dayOfWeek;
          final inRange = time.compareTo(ruleStart) >= 0 && time.compareTo(ruleEnd) < 0;
          return sameDay && inRange;
        }, orElse: () => null);

        if (matchingRule != null) {
          slotPrice = (matchingRule['price'] as num).toDouble() / 2;
        }

        final isBooked = bookingsJson.any((b) {
          return b['court_id'] == courtId &&
              time.compareTo(b['start_time'] as String) >= 0 &&
              time.compareTo(b['end_time'] as String) < 0;
        });

        final timeParts = time.split(':');
        int hour = int.parse(timeParts[0]);
        int min = int.parse(timeParts[1]) + 30;
        if (min >= 60) {
          hour += 1;
          min = 0;
        }
        final endTime = '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';

        return TimeSlotModel(
          startTime: time,
          endTime: endTime,
          isAvailable: !isBooked,
          price: slotPrice,
        );
      }).toList();

      return CourtOverviewModel(id: courtId, name: courtName, slots: slots);
    }).toList();

    return VenueOverviewModel(
      venueId: data['venue']['id'] as String,
      venueName: data['venue']['name'] as String,
      venueAddress: data['venue']['address'] as String,
      courts: courts,
    );
  }

  void setBookingMode(VenueBookingMode mode, {RecurringBookingConfig? config}) {
    final model = currentData;
    if (model == null) return;
    final updatedCourts = model.courts.map((court) {
      final updatedSlots =
          court.slots.map((slot) => slot.copyWith(isSelected: false)).toList();
      return court.copyWith(slots: updatedSlots);
    }).toList();
    state = AsyncData(model.copyWith(
      courts: updatedCourts,
      bookingMode: mode,
      recurringConfig: config,
    ));
  }

  void toggleSlot(String courtId, String startTime) {
    final model = currentData;
    if (model == null) return;
    final updatedCourts = model.courts.map((court) {
      if (court.id == courtId) {
        final updatedSlots = court.slots.map((slot) {
          if (slot.startTime == startTime) {
            return slot.copyWith(isSelected: !slot.isSelected);
          }
          return slot;
        }).toList();
        return court.copyWith(slots: updatedSlots);
      }
      return court;
    }).toList();
    state = AsyncData(model.copyWith(courts: updatedCourts));
  }
}
