import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_overview_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/repositories/venue_detail_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class VenueOverviewCubit extends BaseCubit<VenueOverviewModel> {
  final VenueDetailRepository _repository;
  DateTime _selectedDate = DateTime.now();

  VenueOverviewCubit(this._repository) : super(BaseState.initial());

  DateTime get selectedDate => _selectedDate;

  Future<void> init(String slug) async {
    await fetchSchedule(slug, _selectedDate);
  }

  Future<void> fetchSchedule(String slug, DateTime date) async {
    _selectedDate = date;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    await run<Map<String, dynamic>>(
      action: () => _repository.getVenueSchedule(slug, date: dateStr),
      mapper: (data) => _mapResponseToOverview(data, date),
    );
  }

  VenueOverviewModel _mapResponseToOverview(Map<String, dynamic> data, DateTime date) {
    final courtsJson = data['courts'] as List<dynamic>? ?? [];
    final bookingsJson = data['bookings'] as List<dynamic>? ?? [];
    final dayOfWeek = DateFormat('EEEE').format(date).toUpperCase(); // e.g., MONDAY

    final List<String> timeSlots = [];
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
        // Price Calculation
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

        // Availability Calculation
        final isBooked = bookingsJson.any((b) {
          return b['court_id'] == courtId && 
                 time.compareTo(b['start_time'] as String) >= 0 && 
                 time.compareTo(b['end_time'] as String) < 0;
        });

        // 30 mins interval end time
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

      return CourtOverviewModel(
        id: courtId,
        name: courtName,
        slots: slots,
      );
    }).toList();

    return VenueOverviewModel(
      venueId: data['venue']['id'] as String,
      venueName: data['venue']['name'] as String,
      venueAddress: data['venue']['address'] as String,
      courts: courts,
    );
  }

  void setBookingMode(VenueBookingMode mode, {RecurringBookingConfig? config}) {
    state.mapSuccess((model) {
      // Clear all selected slots when switching mode to avoid confusion
      final updatedCourts = model.courts.map((court) {
        final updatedSlots = court.slots.map((slot) => slot.copyWith(isSelected: false)).toList();
        return court.copyWith(slots: updatedSlots);
      }).toList();

      safeEmit(BaseState.success(
        data: model.copyWith(
          courts: updatedCourts,
          bookingMode: mode,
          recurringConfig: config,
        ),
      ));
      return BaseState.success(data: model);
    });
  }

  void toggleSlot(String courtId, String startTime) {
    state.mapSuccess((model) {
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

      safeEmit(BaseState.success(data: model.copyWith(courts: updatedCourts)));
      return BaseState.success(data: model.copyWith(courts: updatedCourts)); // dummy return
    });
  }
}
