import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'staff_dashboard_service.g.dart';

@RestApi()
@LazySingleton()
abstract class StaffDashboardService {
  @factoryMethod
  factory StaffDashboardService(Dio dio) = _StaffDashboardService;

  @GET(ApiEndpoints.staffStats)
  Future<ApiResponse<StaffDashboardModel>> getDashboardStats();
}
