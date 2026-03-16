// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/data/category_service.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/common/constants/api_endpoints.dart';
import '../models/category_model.dart';

part 'category_service.g.dart';

@RestApi()
@LazySingleton()
abstract class CategoryRutGonService {
  @factoryMethod
  factory CategoryRutGonService(Dio dio) = _CategoryRutGonService;

  @GET(ApiEndpoints.categories)
  Future<List<CategoryRutGonModel>> getCategories({
    @Queries() Map<String, dynamic>? params,
  });

  @GET('${ApiEndpoints.categories}/{id}')
  Future<CategoryRutGonModel> getCategoryDetail(@Path('id') String id);

  @POST(ApiEndpoints.categories)
  Future<CategoryRutGonModel> createCategory(@Body() CategoryRutGonModel data);

  @PUT('${ApiEndpoints.categories}/{id}')
  Future<CategoryRutGonModel> updateCategory(
    @Path('id') String id,
    @Body() CategoryRutGonModel data,
  );

  @DELETE('${ApiEndpoints.categories}/{id}')
  Future<dynamic> deleteCategory(@Path('id') String id);
}
