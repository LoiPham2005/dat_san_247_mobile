import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../models/category_model.dart';

part 'category_service.g.dart';

@RestApi()
@LazySingleton()
abstract class CategoryService {
  @factoryMethod
  factory CategoryService(Dio dio) = _CategoryService;

  @GET(ApiConstants.categories)
  Future<List<CategoryModel>> getCategories({@Queries() Map<String, dynamic>? params});

  @GET('${ApiConstants.categories}/{id}')
  Future<CategoryModel> getCategoryDetail(@Path('id') String id);

  @POST(ApiConstants.categories)
  Future<CategoryModel> createCategory(@Body() Map<String, dynamic> data);

  @PUT('${ApiConstants.categories}/{id}')
  Future<CategoryModel> updateCategory(@Path('id') String id, @Body() Map<String, dynamic> data);

  @DELETE('${ApiConstants.categories}/{id}')
  Future<dynamic> deleteCategory(@Path('id') String id);
}
