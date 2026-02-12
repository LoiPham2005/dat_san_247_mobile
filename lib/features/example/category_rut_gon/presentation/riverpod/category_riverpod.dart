// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/presentation/riverpod/category_riverpod.dart
// ════════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/base_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

/// ✅ Provider defined for CategoryRutGonRepository
final categoryRutGonRepositoryProvider = Provider<CategoryRutGonRepository>((ref) {
  return getIt<CategoryRutGonRepository>();
});

/// ✅ Main Provider for Category Rut Gon
final categoryRutGonProvider =
    AsyncNotifierProvider<CategoryRutGonNotifier, List<CategoryRutGonModel>>(
      CategoryRutGonNotifier.new,
    );

/// ✅ CategoryRutGonNotifier inherits from BaseAsyncNotifier
/// to reuse execute(), onQuery(), onMutation() logic.
class CategoryRutGonNotifier extends BaseAsyncNotifier<List<CategoryRutGonModel>> {
  late final CategoryRutGonRepository _repository;

  @override
  FutureOr<List<CategoryRutGonModel>> build() {
    _repository = ref.watch(categoryRutGonRepositoryProvider);
    // You can optionally call loadCategories() here to auto-fetch on initialization
    return [];
  }

  /// ✅ Get List of Categories
  Future<void> loadCategories({Map<String, dynamic>? params}) async {
    await onQuery(action: () => _repository.getCategories(params: params));
  }

  /// ✅ Create Category
  Future<void> createCategory(CategoryRutGonModel category) async {
    await onMutation(
      action: () async {
        final result = await _repository.createCategory(category);
        return result.map((_) => state.value ?? []);
      },
      successMessage: 'Tạo danh mục thành công',
      onSuccess: (_) => loadCategories(), // Refresh list after success
    );
  }

  /// ✅ Update Category
  Future<void> updateCategory(String id, CategoryRutGonModel category) async {
    await onMutation(
      action: () async {
        final result = await _repository.updateCategory(id, category);
        return result.map((_) => state.value ?? []);
      },
      successMessage: 'Cập nhật danh mục thành công',
      onSuccess: (_) => loadCategories(),
    );
  }

  /// ✅ Delete Category
  Future<void> deleteCategory(String id) async {
    await onMutation(
      action: () async {
        final result = await _repository.deleteCategory(id);
        return result.map((_) => state.value ?? []);
      },
      successMessage: 'Xóa danh mục thành công',
      onSuccess: (_) => loadCategories(),
    );
  }
}
