import 'package:dat_san_247_mobile/core/state_management/providers/base_provider.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryRutGonProvider extends BaseProvider<List<CategoryRutGonModel>> {
  final CategoryRutGonRepository _repository;

  CategoryRutGonProvider(this._repository);

  // Load
  Future<void> loadCategories() async {
    await execute(action: () => _repository.getCategories());
  }

  // Create
  Future<void> createCategory(CategoryRutGonModel category) async {
    await execute(
      action: () async {
        final result = await _repository.createCategory(category);
        return result.map((newItem) {
          final currentList = data ?? [];
          return [...currentList, newItem];
        });
      },
      successMessage: 'Tạo danh mục thành công',
    );
  }

  // Update
  // Future<void> updateCategory(String id, CategoryRutGonModel category) async {
  //   await execute(
  //     action: () async {
  //       final result = await _repository.updateCategory(id, category);
  //       return result.map((updatedItem) {
  //         final currentList = [...(data ?? [])];
  //         final index = currentList.indexWhere((e) => e.id == id);
  //         if (index != -1) currentList[index] = updatedItem;
  //         return currentList;
  //       });
  //     },
  //     successMessage: 'Cập nhật danh mục thành công',
  //   );
  // }

  // Delete
  // Future<void> deleteCategory(String id) async {
  //   await execute(
  //     action: () async {
  //       final result = await _repository.deleteCategory(id);
  //       return result.map((_) {
  //         final currentList = [...(data ?? [])];
  //         currentList.removeWhere((e) => e.id == id);
  //         return currentList;
  //       });
  //     },
  //     successMessage: 'Xóa danh mục thành công',
  //   );
  // }
}
