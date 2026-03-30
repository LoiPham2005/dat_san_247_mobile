import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/services/owner_booking_service.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@LazySingleton()
class OwnerBookingRepository with ApiHandlerMixin {
  final OwnerBookingService _service;

  OwnerBookingRepository(this._service);

  /// 📅 Get calendar bookings for a venue and date range
  Future<Result<List<OwnerBookingModel>>> getCalendarBookings(
    String venueId, {
    DateTime? startDate,
    DateTime? endDate,
    String? courtId,
    String? status,
  }) {
    final fmt = DateFormat('yyyy-MM-dd');
    return safeCallUnwrap(() => _service.getCalendarBookings(
          venueId,
          startDate: startDate != null ? fmt.format(startDate) : null,
          endDate: endDate != null ? fmt.format(endDate) : null,
          courtId: courtId,
          status: status,
        ));
  }

  /// 📝 Get booking detail
  Future<Result<OwnerBookingModel>> getBookingDetail(String id) {
    return safeCallUnwrap(() => _service.getBookingDetail(id));
  }

  /// ✅ Update booking status (ACCEPT, REJECT, CHECK_IN, NO_SHOW, CANCEL)
  Future<Result<bool>> updateBookingStatus(String bookingId, String status) {
    return safeCallUnwrap(() => _service.updateBookingStatus(bookingId, {'status': status}))
        .thenMap((_) => true);
  }
}
