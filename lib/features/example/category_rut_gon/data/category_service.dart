// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/data/category_service.dart
// ════════════════════════════════════════════════════════════════
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import 'category_model.dart';

part 'category_service.g.dart';

@RestApi()
@LazySingleton()
abstract class CategoryRutGonService {
  @factoryMethod
  factory CategoryRutGonService(Dio dio) = _CategoryRutGonService;

  @GET(ApiConstants.categories)
  Future<List<CategoryRutGonModel>> getCategories({@Queries() Map<String, dynamic>? params});

  @GET('${ApiConstants.categories}/{id}')
  Future<CategoryRutGonModel> getCategoryDetail(@Path('id') String id);

  @POST(ApiConstants.categories)
  Future<CategoryRutGonModel> createCategory(@Body() CategoryRutGonModel data);

  @PUT('${ApiConstants.categories}/{id}')
  Future<CategoryRutGonModel> updateCategory(
    @Path('id') String id,
    @Body() CategoryRutGonModel data,
  );

  @DELETE('${ApiConstants.categories}/{id}')
  Future<dynamic> deleteCategory(@Path('id') String id);
}
