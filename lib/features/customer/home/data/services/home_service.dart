import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/banner_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/sport_category_model.dart';
import 'package:dat_san_247_mobile/features/shared/promotion/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'home_service.g.dart';

@RestApi()
@LazySingleton()
abstract class HomeService {
  @factoryMethod
  factory HomeService(Dio dio) = _HomeService;

  @GET(ApiEndpoints.banners)
  Future<ApiResponse<List<BannerModel>>> getBanners({
    @Queries() Map<String, dynamic>? params,
  });

  @GET(ApiEndpoints.sportTypes)
  Future<ApiResponse<List<SportCategoryModel>>> getSportCategories({
    @Queries() Map<String, dynamic>? params,
  });

  @GET(ApiEndpoints.venues)
  Future<ApiResponse<List<VenueModel>>> getFeaturedVenues({
    @Queries() Map<String, dynamic>? params,
  });

  @GET(ApiEndpoints.promotions)
  Future<ApiResponse<List<PromotionModel>>> getActivePromotions({
    @Queries() Map<String, dynamic>? params,
  });

  @POST(ApiEndpoints.toggleFavorite)
  Future<ApiResponse<bool>> toggleFavorite({
    @Body() required Map<String, dynamic> body,
  });
}
