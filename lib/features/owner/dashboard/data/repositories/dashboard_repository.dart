import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/models/owner_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/services/dashboard_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DashboardRepository with ApiHandlerMixin {
  final DashboardService _service;

  DashboardRepository(this._service);

  /// 🏟️ Fetch Owner's venues
  Future<Result<List<OwnerVenueSummaryModel>>> getOwnerVenues() {
    return safeCallUnwrap(() => _service.getOwnerVenues());
  }

  /// 📈 Fetch stats for a specific venue or dashboard summary
  Future<Result<OwnerBookingStatsModel>> getStats({String? venueId}) {
    return safeCallUnwrap(() => _service.getDashboardStats(venueId: venueId));
  }

  /// 💰 Fetch revenue for dashboard
  Future<Result<OwnerRevenueModel>> getRevenue({String? venueId}) {
    return safeCallUnwrap(() => _service.getDashboardRevenue(venueId: venueId));
  }

  /// 📅 Fetch pending bookings
  Future<Result<List<OwnerPendingBookingModel>>> getPendingBookings(String vId) {
    return safeCallUnwrap(() => _service.getVenueBookings(vId, status: 'PENDING'));
  }

  /// 📝 Accept or reject booking
  Future<Result<bool>> updateBookingStatus(String bookingId, String status) {
    return safeCallUnwrap(() => _service.updateBookingStatus(bookingId, {'status': status}))
        .thenMap((_) => true);
  }
}
