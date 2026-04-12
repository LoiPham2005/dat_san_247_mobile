import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/customer/promotions/data/models/user_voucher_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'promotion_service.g.dart';

@RestApi()
@LazySingleton()
abstract class PromotionService {
  @factoryMethod
  factory PromotionService(Dio dio) = _PromotionService;

  @GET(ApiEndpoints.publicPromotions)
  Future<ApiResponse<List<PromotionModel>>> getPromotions({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET(ApiEndpoints.myVouchers)
  Future<ApiResponse<List<UserVoucherModel>>> getMyVouchers();

  @POST(ApiEndpoints.collectPromotion)
  Future<ApiResponse<void>> collectPromotion(@Path('id') String id);
}
