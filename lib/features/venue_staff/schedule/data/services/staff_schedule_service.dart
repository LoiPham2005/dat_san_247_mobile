import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_paginated_data.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'staff_schedule_service.g.dart';

@RestApi()
@LazySingleton()
abstract class StaffScheduleService {
  @factoryMethod
  factory StaffScheduleService(Dio dio) = _StaffScheduleService;

  @GET(ApiEndpoints.venueStaffSchedule)
  Future<ApiResponse<ApiPaginatedData<CheckInBookingModel>>> getSchedule({
    @Query('venue_id') String? venueId,
    @Query('date') String? date,
    @Query('status') String? status,
    @Query('search') String? search,
    @Query('page') int page = 1,
    @Query('limit') int limit = 50,
  });

  @PATCH('/bookings/venue-staff/{id}/status')
  Future<ApiResponse<CheckInBookingModel>> updateStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
