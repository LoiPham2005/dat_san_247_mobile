import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'waitlist_service.g.dart';

@RestApi()
@LazySingleton()
abstract class WaitlistService {
  @factoryMethod
  factory WaitlistService(Dio dio) = _WaitlistService;

  @GET(ApiEndpoints.myWaitlist)
  Future<ApiResponse<List<WaitlistModel>>> getMyWaitlist();

  @DELETE(ApiEndpoints.cancelWaitlist)
  Future<ApiResponse<void>> cancelWaitlist(@Path('id') String id);
}
