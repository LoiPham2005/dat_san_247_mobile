import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/data/models/owner_dashboard_models.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_service.g.dart';

@RestApi()
@LazySingleton()
abstract class DashboardService {
  @factoryMethod
  factory DashboardService(Dio dio) = _DashboardService;

  /// 🏟️ Get list of owned venues
  @GET(ApiEndpoints.ownerVenues)
  Future<ApiResponse<List<OwnerVenueSummaryModel>>> getOwnerVenues();

  /// 📈 Get dashboard stats for a venue (or aggregated)
  @GET(ApiEndpoints.ownerStats)
  Future<ApiResponse<OwnerBookingStatsModel>> getDashboardStats({
    @Query('venue_id') String? venueId,
  });

  /// 📅 Get bookings for a venue (to extract pending)
  @GET(ApiEndpoints.ownerBookings)
  Future<ApiResponse<List<OwnerPendingBookingModel>>> getVenueBookings(
    @Path('vId') String vId, {
    @Query('status') String? status,
  });

  @PATCH(ApiEndpoints.updateBookingStatus)
  Future<ApiResponse<dynamic>> updateBookingStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  /// 💰 Get dashboard revenue stats
  @GET(ApiEndpoints.ownerRevenue)
  Future<ApiResponse<OwnerRevenueModel>> getDashboardRevenue({
    @Query('venue_id') String? venueId,
    @Query('year') int? year,
    @Query('month') int? month,
  });
}
