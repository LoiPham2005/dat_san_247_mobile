import 'package:dat_san_247_mobile/core/state_management/getx/base_controller.dart';
import 'package:get/get.dart';

import '../../../../../core/di/injection.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryRutGonGetXController extends BaseController<List<CategoryRutGonModel>> {
  final CategoryRutGonRepository _repository = getIt<CategoryRutGonRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch Data
  Future<void> fetchCategories() async {
    await execute(action: () => _repository.getCategories());
  }

  // Create
  Future<void> createCategory(CategoryRutGonModel category) async {
    await execute(
      action: () async {
        final result = await _repository.createCategory(category);
        // Map Result<Item> -> Result<List<Item>>
        return result.map((newItem) {
          final currentList = data ?? [];
          return [...currentList, newItem];
        });
      },
      successMessage: 'Đã thêm danh mục mới',
      onSuccess: (data) {
        Get.snackbar('Thành công', 'Đã thêm danh mục mới');
      },
      onFailure: (fail) {
        Get.snackbar('Lỗi', fail.message);
      },
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
  //     successMessage: 'Cập nhật thành công',
  //     onFailure: (fail) => Get.snackbar('Lỗi', fail.message),
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
  //     successMessage: 'Xóa thành công',
  //     onFailure: (fail) => Get.snackbar('Lỗi', fail.message),
  //   );
  // }
}
