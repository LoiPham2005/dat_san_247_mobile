import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/network/api_client.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/api_constants.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Result<List<CategoryModel>>> getCategories({Map<String, dynamic>? params});
  Future<Result<CategoryModel>> getCategoryDetail(String id);
  Future<Result<CategoryModel>> createCategory(Map<String, dynamic> data);
  Future<Result<CategoryModel>> updateCategory(String id, Map<String, dynamic> data);
  Future<Result<bool>> deleteCategory(String id);
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<Result<List<CategoryModel>>> getCategories({Map<String, dynamic>? params}) async {
    return _apiClient.get(
      ApiConstants.categories,
      (json) => json.map((e) => CategoryModel.fromJson(e)).toList(),
      queryParameters: params,
    );
  }

  @override
  Future<Result<CategoryModel>> getCategoryDetail(String id) {
    return _apiClient.get('${ApiConstants.categories}/$id', (json) => CategoryModel.fromJson(json));
  }

  @override
  Future<Result<CategoryModel>> createCategory(Map<String, dynamic> data) {
    return _apiClient.post(
      ApiConstants.categories,
      (json) => CategoryModel.fromJson(json),
      data: data,
    );
  }

  @override
  Future<Result<CategoryModel>> updateCategory(String id, Map<String, dynamic> data) {
    return _apiClient.put(
      '${ApiConstants.categories}/$id',
      (json) => CategoryModel.fromJson(json),
      data: data,
    );
  }

  @override
  Future<Result<bool>> deleteCategory(String id) {
    return _apiClient.delete('${ApiConstants.categories}/$id');
  }
}
