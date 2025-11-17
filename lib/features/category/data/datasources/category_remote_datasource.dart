import 'package:flutter_base_template/core/errors/result.dart';
import 'package:flutter_base_template/core/network/api_client.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Result<List<CategoryModel>>> getCategories({
    Map<String, dynamic>? params,
  });
  Future<Result<CategoryModel>> getCategoryDetail(String id);
  Future<Result<CategoryModel>> createCategory(Map<String, dynamic> data);
  Future<Result<CategoryModel>> updateCategory(
    String id,
    Map<String, dynamic> data,
  );
  Future<Result<bool>> deleteCategory(String id);
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<Result<List<CategoryModel>>> getCategories({
    Map<String, dynamic>? params,
  }) async {
    return _apiClient.getResult(ApiConstants.categories, (json) {
      final list = (json['item']['category'] ?? json) as List;
      return list.map((e) => CategoryModel.fromJson(e)).toList();
    }, queryParameters: params);
  }

  @override
  Future<Result<CategoryModel>> getCategoryDetail(String id) {
    return _apiClient.getResult(
      '${ApiConstants.categories}/$id',
      (json) => CategoryModel.fromJson(json['data'] ?? json),
    );
  }

  @override
  Future<Result<CategoryModel>> createCategory(Map<String, dynamic> data) {
    return _apiClient.postResult(
      ApiConstants.categories,
      (json) => CategoryModel.fromJson(json['data'] ?? json),
      data: data,
    );
  }

  @override
  Future<Result<CategoryModel>> updateCategory(
    String id,
    Map<String, dynamic> data,
  ) {
    return _apiClient.putResult(
      '${ApiConstants.categories}/$id',
      (json) => CategoryModel.fromJson(json['data'] ?? json),
      data: data,
    );
  }

  @override
  Future<Result<bool>> deleteCategory(String id) {
    return _apiClient.deleteResult('${ApiConstants.categories}/$id');
  }
}
