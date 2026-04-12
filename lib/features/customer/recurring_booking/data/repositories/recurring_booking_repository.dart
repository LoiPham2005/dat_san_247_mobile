import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/services/recurring_booking_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class RecurringBookingRepository with ApiHandlerMixin {
  final RecurringBookingService _service;

  RecurringBookingRepository(this._service);

  Future<Result<List<RecurringBookingModel>>> getMyRecurringBookings() {
    return safeCallUnwrap(
      () => _service.getMyRecurringBookings(),
    );
  }

  Future<Result<bool>> toggleRecurringBooking(String id, bool isActive) {
    return safeCallUnwrap(
      () => _service.toggleRecurringBooking(body: {
        'id': id,
        'is_active': isActive,
      }),
    );
  }

  Future<Result<RecurringBookingModel>> createRecurringBooking({
    required String venueId,
    required String courtId,
    required String startTime,
    required String endTime,
    required String repeatType, // DAILY, WEEKLY
    required List<int> days, // 0-6
    required String startDate,
    String? endDate,
  }) {
    // Map day indices back to enum names if needed, 
    // but better to assume the UI passed standard DayOfWeek names or indices.
    // Based on schema, we need [MONDAY, TUESDAY, ...]
    final dayNames = days.map((d) {
      const names = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
      return names[d % 7];
    }).toList();

    return safeCallUnwrap(
      () => _service.createRecurringBooking(body: {
        'venue_id': venueId,
        'court_id': courtId,
        'start_time': startTime,
        'end_time': endTime,
        'repeat_type': repeatType,
        'days': dayNames,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );
  }
}
