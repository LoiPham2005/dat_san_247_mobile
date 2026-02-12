// ════════════════════════════════════════════════════════════════
// 📁 category_toi_uu/presentation/bloc/category_bloc.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/state_management/bloc/base_bloc.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/category_repository.dart';
import 'category_event.dart';

/// 🎯 CategoryBloc — Optimized Hybrid Pattern
///
/// ✅ Bloc gọi thẳng Repository (bỏ UseCase cho CRUD đơn giản)
/// ✅ Dùng onQuery() cho GET requests (tự cancel request cũ)
/// ✅ Dùng onMutation() cho POST/PUT/DELETE (giữ data cũ khi lỗi)
/// ✅ Auto-refresh danh sách sau mỗi mutation thành công
@injectable
class CategoryBloc extends BaseBloc {
  final CategoryRepository _repository;

  CategoryBloc(this._repository) : super(BaseState.initial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadCategoryDetail>(_onLoadCategoryDetail);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  /// 📋 Load danh sách categories (GET — Query)
  Future<void> _onLoadCategories(LoadCategories event, Emitter<BaseState> emit) async {
    await onQuery(
      emit: emit,
      action: () => _repository.getCategories(params: event.params),
    );
  }

  /// 🔍 Load chi tiết category (GET — Query)
  Future<void> _onLoadCategoryDetail(LoadCategoryDetail event, Emitter<BaseState> emit) async {
    await onQuery(emit: emit, action: () => _repository.getCategoryDetail(event.id));
  }

  /// ➕ Tạo category mới (POST — Mutation)
  Future<void> _onCreateCategory(CreateCategory event, Emitter<BaseState> emit) async {
    await onMutation(
      emit: emit,
      action: () => _repository.createCategory(event.data),
      successMessage: 'Tạo danh mục thành công',
      onSuccess: (_) {
        // Auto-refresh danh sách sau khi tạo thành công
        add(const LoadCategories(refresh: true));
      },
    );
  }

  /// ✏️ Cập nhật category (PUT — Mutation)
  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<BaseState> emit) async {
    await onMutation(
      emit: emit,
      action: () => _repository.updateCategory(event.id, event.data),
      successMessage: 'Cập nhật danh mục thành công',
      onSuccess: (_) {
        add(const LoadCategories(refresh: true));
      },
    );
  }

  /// 🗑️ Xóa category (DELETE — Mutation)
  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<BaseState> emit) async {
    await onMutation(
      emit: emit,
      action: () => _repository.deleteCategory(event.id),
      successMessage: 'Xóa danh mục thành công',
      onSuccess: (_) {
        add(const LoadCategories(refresh: true));
      },
    );
  }
}
