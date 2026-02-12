import 'package:injectable/injectable.dart';

import '../../../../../core/usecases/params.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// ════════════════════════════════════════════════════════════════
/// 🎯 CATEGORY USE CASES (WORLD-CLASS IMPLEMENTATION)
/// ════════════════════════════════════════════════════════════════

@injectable
final class GetCategoriesUseCase extends UseCase<List<Category>, SearchParams?> {
  final CategoryRepository _repository;
  const GetCategoriesUseCase(this._repository);

  @override
  FutureResult<List<Category>> execute(SearchParams? params) {
    return _repository.getCategories(params: params?.toJson());
  }
}

@injectable
final class GetCategoryDetailUseCase extends UseCase<Category, String> {
  final CategoryRepository _repository;
  const GetCategoryDetailUseCase(this._repository);

  @override
  FutureResult<Category> execute(String id) {
    return _repository.getCategoryDetail(id);
  }
}

@injectable
final class CreateCategoryUseCase extends UseCase<Category, Map<String, dynamic>> {
  final CategoryRepository _repository;
  const CreateCategoryUseCase(this._repository);

  @override
  FutureResult<Category> execute(Map<String, dynamic> data) {
    return _repository.createCategory(data);
  }
}

@injectable
final class UpdateCategoryUseCase extends UseCase<Category, CategoryUpdateParams> {
  final CategoryRepository _repository;
  const UpdateCategoryUseCase(this._repository);

  @override
  FutureResult<Category> execute(CategoryUpdateParams params) {
    return _repository.updateCategory(params.id, params.data);
  }
}

@injectable
final class DeleteCategoryUseCase extends UseCase<bool, String> {
  final CategoryRepository _repository;
  const DeleteCategoryUseCase(this._repository);

  @override
  FutureBoolResult execute(String id) {
    return _repository.deleteCategory(id);
  }
}

/// Params for update operation
final class CategoryUpdateParams extends Params {
  final String id;
  final Map<String, dynamic> data;

  const CategoryUpdateParams({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];

  @override
  Map<String, dynamic> toJson() => data;
}
