import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/data/network/api_response.dart';
import '../models/promotion_model.dart';

part 'deals_service.g.dart';

@RestApi()
@LazySingleton()
abstract class DealsService {
  @factoryMethod
  factory DealsService(Dio dio) = _DealsService;

  @GET('/public/promotions')
  Future<ApiResponse<List<PromotionModel>>> getDeals({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('status') String? status,
    @Query('is_public') bool? isPublic,
  });
}
