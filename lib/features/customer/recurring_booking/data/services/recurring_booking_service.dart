import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'recurring_booking_service.g.dart';

@RestApi()
@LazySingleton()
abstract class RecurringBookingService {
  @factoryMethod
  factory RecurringBookingService(Dio dio) = _RecurringBookingService;

  @GET(ApiEndpoints.recurringBookings)
  Future<ApiResponse<List<RecurringBookingModel>>> getMyRecurringBookings();

  @POST(ApiEndpoints.recurringBookings)
  Future<ApiResponse<RecurringBookingModel>> createRecurringBooking({
    @Body() required Map<String, dynamic> body,
  });

  @PATCH(ApiEndpoints.recurringBookings)
  Future<ApiResponse<bool>> toggleRecurringBooking({
    @Body() required Map<String, dynamic> body,
  });
}
