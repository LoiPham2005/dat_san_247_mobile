import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'favorite_service.g.dart';

@RestApi()
@LazySingleton()
abstract class FavoriteService {
  @factoryMethod
  factory FavoriteService(Dio dio) = _FavoriteService;

  @GET(ApiEndpoints.favorites)
  Future<ApiResponse<List<FavoriteVenueModel>>> getFavorites();

  @POST(ApiEndpoints.toggleFavorite)
  Future<ApiResponse<bool>> toggleFavorite({
    @Body() required Map<String, dynamic> body,
  });
}
