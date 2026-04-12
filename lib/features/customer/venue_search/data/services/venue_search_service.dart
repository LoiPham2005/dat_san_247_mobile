import 'package:dat_san_247_mobile/core/common/constants/api_endpoints.dart';
import 'package:dat_san_247_mobile/core/data/network/api_response.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'venue_search_service.g.dart';

@RestApi()
@LazySingleton()
abstract class VenueSearchService {
  @factoryMethod
  factory VenueSearchService(Dio dio) = _VenueSearchService;

  @GET(ApiEndpoints.venues)
  Future<ApiResponse<List<VenueSearchResultModel>>> searchVenues({
    @Queries() Map<String, dynamic>? queries,
  });

  @GET(ApiEndpoints.searchHistory)
  Future<ApiResponse<List<SearchHistoryModel>>> getSearchHistory();

  @DELETE(ApiEndpoints.searchHistory)
  Future<ApiResponse<bool>> clearSearchHistory();
  
  @POST(ApiEndpoints.searchHistory)
  Future<ApiResponse<bool>> saveSearchHistory({
    @Body() required Map<String, dynamic> body,
  });

  @GET(ApiEndpoints.favorites)
  Future<ApiResponse<List<FavoriteVenueModel>>> getFavorites();

  @POST(ApiEndpoints.toggleFavorite)
  Future<ApiResponse<bool>> toggleFavorite({
    @Body() required Map<String, dynamic> body,
  });
}
