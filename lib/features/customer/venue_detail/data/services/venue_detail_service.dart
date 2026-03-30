import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'venue_detail_service.g.dart';

@RestApi()
@LazySingleton()
abstract class VenueDetailService {
  @factoryMethod
  factory VenueDetailService(Dio dio) = _VenueDetailService;

  @GET(ApiEndpoints.venueDetail)
  Future<ApiResponse<VenueDetailModel>> getVenueDetail({
    @Path('slug') required String slug,
  });

  @GET(ApiEndpoints.venueSchedule)
  Future<ApiResponse<dynamic>> getVenueSchedule({
    @Path('slug') required String slug,
    @Query('date') String? date,
  });
  
  @POST(ApiEndpoints.toggleFavorite)
  Future<ApiResponse<bool>> toggleFavorite({
    @Body() required Map<String, dynamic> body,
  });
}
