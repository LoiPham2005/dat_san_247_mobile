import 'package:injectable/injectable.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Category>>> getCategories({
    Map<String, dynamic>? params,
  }) async {
    final result = await _remoteDataSource.getCategories(params: params);
    return result.mapList((model) => model.toEntity());
  }

  @override
  Future<Result<Category>> getCategoryDetail(String id) async {
    final result = await _remoteDataSource.getCategoryDetail(id);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Result<Category>> createCategory(Map<String, dynamic> data) async {
    final result = await _remoteDataSource.createCategory(data);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Result<Category>> updateCategory(
    String id,
    Map<String, dynamic> data,
  ) async {
    final result = await _remoteDataSource.updateCategory(id, data);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Result<bool>> deleteCategory(String id) async {
    // Không cần map vì trả về bool
    return await _remoteDataSource.deleteCategory(id);
  }
}
