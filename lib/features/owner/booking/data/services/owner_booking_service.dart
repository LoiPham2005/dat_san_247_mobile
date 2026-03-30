import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'owner_booking_service.g.dart';

@RestApi()
@LazySingleton()
abstract class OwnerBookingService {
  @factoryMethod
  factory OwnerBookingService(Dio dio) = _OwnerBookingService;

  /// 📅 Get bookings for calendar view (with range)
  @GET(ApiEndpoints.ownerBookings)
  Future<ApiResponse<List<OwnerBookingModel>>> getCalendarBookings(
    @Path('vId') String vId, {
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
    @Query('court_id') String? courtId,
    @Query('status') String? status,
  });

  /// 📝 Get booking detail
  @GET('/owner/bookings/detail/{id}')
  Future<ApiResponse<OwnerBookingModel>> getBookingDetail(@Path('id') String id);

  /// ✅ Update booking status
  @PATCH(ApiEndpoints.updateBookingStatus)
  Future<ApiResponse<dynamic>> updateBookingStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );
}
