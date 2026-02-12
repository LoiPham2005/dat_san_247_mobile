import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/mixins/remote_data_source_mixin.dart';
import 'package:injectable/injectable.dart';

import '../models/category_model.dart';
import 'category_service.dart';

abstract class CategoryRemoteDataSource {
  Future<Result<List<CategoryModel>>> getCategories({Map<String, dynamic>? params});
  Future<Result<CategoryModel>> getCategoryDetail(String id);
  Future<Result<CategoryModel>> createCategory(Map<String, dynamic> data);
  Future<Result<CategoryModel>> updateCategory(String id, Map<String, dynamic> data);
  Future<Result<bool>> deleteCategory(String id);
}

@LazySingleton(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl with RemoteDataSourceMixin implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this._service);
  final CategoryService _service;

  @override
  Future<Result<List<CategoryModel>>> getCategories({Map<String, dynamic>? params}) =>
      call(() => _service.getCategories(params: params));

  @override
  Future<Result<CategoryModel>> getCategoryDetail(String id) =>
      call(() => _service.getCategoryDetail(id));

  @override
  Future<Result<CategoryModel>> createCategory(Map<String, dynamic> data) =>
      call(() => _service.createCategory(data));

  @override
  Future<Result<CategoryModel>> updateCategory(String id, Map<String, dynamic> data) =>
      call(() => _service.updateCategory(id, data));

  @override
  Future<Result<bool>> deleteCategory(String id) => callBool(() => _service.deleteCategory(id));
}
