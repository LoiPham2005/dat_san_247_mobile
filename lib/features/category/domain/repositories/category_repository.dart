// lib/features/category/domain/repositories/category_repository.dart
import '../../../../core/errors/result.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getCategories({Map<String, dynamic>? params});
  Future<Result<Category>> getCategoryDetail(String id);
  Future<Result<Category>> createCategory(Map<String, dynamic> data);
  Future<Result<Category>> updateCategory(String id, Map<String, dynamic> data);
  Future<Result<bool>> deleteCategory(String id);
}
