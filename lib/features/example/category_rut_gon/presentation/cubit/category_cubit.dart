import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/state_management/cubit/base_cubit.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

// 🎯 Sửa: Cubit quản lý List<Model> thay vì Model lẻ
@injectable
class CategoryRutGonCubit extends BaseCubit {
  final CategoryRutGonRepository _repository;

  CategoryRutGonCubit(this._repository) : super(BaseState.initial());

  /// 📥 Load List - Khớp type T = List<Model> nên dùng execute được
  Future<void> loadCategories({Map<String, dynamic>? params}) async {
    await execute(action: () => _repository.getCategories(params: params));
  }

  /// ➕ Create - Result trả về Model (T'), không phải List (T)
  /// -> Không dùng được execute mặc định vì nó sẽ emit(state.copyWith(data: Model)) -> Sai type
  /// -> Phải handle thủ công
  Future<void> createCategory(CategoryRutGonModel data) async {
    safeEmit(BaseState.loading(previousData: state.data));

    final result = await _repository.createCategory(data);

    result.fold(
      onSuccess: (newItem) {
        // Optimistic Update: Thêm vào list cũ
        final currentList = List<CategoryRutGonModel>.from(state.data ?? []);
        currentList.add(newItem);

        safeEmit(BaseState.success(data: currentList, message: 'Tạo thành công'));
      },
      onFailure: (failure) {
        safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
      },
    );
  }

  /// ✏️ Update
  // Future<void> updateCategory(String id, CategoryRutGonModel data) async {
  //   safeEmit(BaseState.loading(previousData: state.data));

  //   final result = await _repository.updateCategory(id, data);

  //   result.fold(
  //     onSuccess: (updatedItem) {
  //       final currentList = List<CategoryRutGonModel>.from(state.data ?? []);
  //       final index = currentList.indexWhere((element) => element.id == id);

  //       if (index != -1) {
  //         currentList[index] = updatedItem;
  //       }

  //       safeEmit(BaseState.success(data: currentList, message: 'Cập nhật thành công'));
  //     },
  //     onFailure: (failure) {
  //       safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
  //     },
  //   );
  // }

  /// 🗑️ Delete
  // Future<void> deleteCategory(String id) async {
  //   safeEmit(BaseState.loading(previousData: state.data));

  //   final result = await _repository.deleteCategory(id);

  //   result.fold(
  //     onSuccess: (_) {
  //       final currentList = List<CategoryRutGonModel>.from(state.data ?? []);
  //       currentList.removeWhere((element) => element.id == id);

  //       safeEmit(BaseState.success(data: currentList, message: 'Xóa thành công'));
  //     },
  //     onFailure: (failure) {
  //       safeEmit(BaseState.failure(error: failure.message, previousData: state.data));
  //     },
  //   );
  // }
}
