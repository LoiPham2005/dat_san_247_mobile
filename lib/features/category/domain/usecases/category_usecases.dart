import 'package:injectable/injectable.dart';

import '../../../../core/errors/result.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

// ✅ 1. Lấy danh sách danh mục
@injectable
class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Result<List<Category>>> call({Map<String, dynamic>? params}) {
    return repository.getCategories(params: params);
  }
}

// ✅ 2. Lấy chi tiết danh mục
@injectable
class GetCategoryDetailUseCase {
  final CategoryRepository repository;

  GetCategoryDetailUseCase(this.repository);

  Future<Result<Category>> call(String id) {
    return repository.getCategoryDetail(id);
  }
}

// ✅ 3. Tạo danh mục mới
class CreateCategoryUseCase {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<Result<Category>> call(Map<String, dynamic> data) {
    return repository.createCategory(data);
  }
}

// ✅ 4. Cập nhật danh mục
class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Result<Category>> call(String id, Map<String, dynamic> data) {
    return repository.updateCategory(id, data);
  }
}

// ✅ 5. Xóa danh mục
class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<Result<bool>> call(String id) {
    return repository.deleteCategory(id);
  }
}
