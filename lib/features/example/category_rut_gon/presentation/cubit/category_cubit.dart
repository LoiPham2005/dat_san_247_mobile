import 'package:injectable/injectable.dart';

import '../../../../../core/base/state/bloc/base_state.dart';
import '../../../../../core/base/state/cubit/base_cubit.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

@injectable
class CategoryRutGonCubit extends BaseCubit<List<CategoryRutGonModel>> {
  final CategoryRutGonRepository _repository;

  CategoryRutGonCubit(this._repository) : super(BaseState.initial());

  /// 📥 Load List
  Future<void> loadCategories({Map<String, dynamic>? params}) async {
    await run(action: () => _repository.getCategories(params: params));
  }

  /// ➕ Create
  Future<void> createCategory(CategoryRutGonModel item) async {
    await run<CategoryRutGonModel>(
      action: () => _repository.createCategory(item),
      // 🎯 Mapper: Thêm item mới vào list hiện tại trong state
      mapper: (newItem) => [...(state.data ?? []), newItem],
      successMessage: 'Thêm danh mục thành công',
    );
  }

  /// ✏️ Update
  // Future<void> updateCategory(String id, CategoryRutGonModel item) async {
  //   await run<CategoryRutGonModel>(
  //     action: () => _repository.updateCategory(id, item),
  //     // 🎯 Mapper: Tìm và thay thế item trong list hiện tại
  //     mapper: (updatedItem) {
  //       final currentList = List<CategoryRutGonModel>.from(state.data ?? []);
  //       final index = currentList.indexWhere((e) => e.id == id);
  //       if (index != -1) currentList[index] = updatedItem;
  //       return currentList;
  //     },
  //     successMessage: 'Cập nhật thành công',
  //   );
  // }

  /// 🗑️ Delete
  // Future<void> deleteCategory(String id) async {
  //   await run<bool>(
  //     action: () => _repository.deleteCategory(id),
  //     // 🎯 Mapper: Lọc bỏ item đã xóa khỏi list hiện tại
  //     mapper: (_) {
  //       final currentList = List<CategoryRutGonModel>.from(state.data ?? []);
  //       currentList.removeWhere((e) => e.id == id);
  //       return currentList;
  //     },
  //     successMessage: 'Xóa thành công',
  //   );
  // }
}
