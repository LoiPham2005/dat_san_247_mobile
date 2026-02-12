// // ════════════════════════════════════════════════════════════════
// // 📁 lib/features/category_rut_gon/presentation/riverpod/category_riverpod_gencode.dart
// // ════════════════════════════════════════════════════════════════
// import 'package:dat_san_247_mobile/core/di/injection.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../data/category_model.dart';
// import '../../data/category_repository.dart';

// part 'category_riverpod_gencode.g.dart';

// /// ✅ Repository Provider using Code Gen
// @riverpod
// CategoryRutGonRepository categoryRutGonRepositoryGencode(Ref ref) {
//   return getIt<CategoryRutGonRepository>();
// }

// /// ✅ Main Notifier using Code Gen
// /// Note: To use BaseAsyncNotifier with Code Gen, we need to adapt the structure
// /// since riverpod_generator generates its own base class.
// @riverpod
// class CategoryRutGonGencodeNotifier extends _$CategoryRutGonGencodeNotifier {
//   late final CategoryRutGonRepository _repository;

//   // We can't easily inherit from BaseAsyncNotifier when using code gen
//   // because riverpod_generator generates the base class _$CategoryRutGonGencodeNotifier.
//   // However, we can still use the same logic pattern.

//   @override
//   FutureOr<List<CategoryRutGonModel>> build() {
//     _repository = ref.watch(categoryRutGonRepositoryGencodeProvider);
//     return [];
//   }

//   /// ✅ Lấy danh sách Categories
//   Future<void> loadCategories({Map<String, dynamic>? params}) async {
//     state = const AsyncLoading();
//     final result = await _repository.getCategories(params: params);

//     result.fold(
//       onSuccess: (data) => state = AsyncData(data),
//       onFailure: (failure) => state = AsyncError(failure, StackTrace.current),
//     );
//   }

//   /// ✅ Tạo mới Category
//   Future<void> createCategory(CategoryRutGonModel category) async {
//     final result = await _repository.createCategory(category);
//     result.fold(
//       onSuccess: (data) => loadCategories(),
//       onFailure: (failure) => state = AsyncError(failure, StackTrace.current),
//     );
//   }

//   /// ✅ Cập nhật Category
//   Future<void> updateCategory(String id, CategoryRutGonModel category) async {
//     final result = await _repository.updateCategory(id, category);
//     result.fold(
//       onSuccess: (data) => loadCategories(),
//       onFailure: (failure) => state = AsyncError(failure, StackTrace.current),
//     );
//   }

//   /// ✅ Xóa Category
//   Future<void> deleteCategory(String id) async {
//     final result = await _repository.deleteCategory(id);
//     result.fold(
//       onSuccess: (data) => loadCategories(),
//       onFailure: (failure) => state = AsyncError(failure, StackTrace.current),
//     );
//   }
// }














// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/presentation/riverpod/category_riverpod_gencode.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/result_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

part 'category_riverpod_gencode.g.dart';

/// ✅ Repository Provider using Code Gen
@riverpod
CategoryRutGonRepository categoryRutGonRepositoryGencode(Ref ref) {
  return getIt<CategoryRutGonRepository>();
}

/// ✅ Main Notifier using Code Gen with Helper Functions
///
/// Sử dụng helper functions để viết code ngắn gọn hơn:
/// - `executeWithLoading()`: Tự động xử lý loading + result
/// - `executeWithCallback()`: Xử lý mutation với callback
@riverpod
class CategoryRutGonGencodeNotifier extends _$CategoryRutGonGencodeNotifier {
  late final CategoryRutGonRepository _repository;

  @override
  FutureOr<List<CategoryRutGonModel>> build() {
    _repository = ref.watch(categoryRutGonRepositoryGencodeProvider);
    return [];
  }

  /// ✅ Lấy danh sách Categories
  Future<void> loadCategories({Map<String, dynamic>? params}) async {
    state = const AsyncLoading();
    state = await executeWithLoading(() => _repository.getCategories(params: params));
  }

  /// ✅ Tạo mới Category
  Future<void> createCategory(CategoryRutGonModel category) async {
    await executeWithCallback(
      () => _repository.createCategory(category),
      onSuccess: (_) => loadCategories(),
    );
  }

  /// ✅ Cập nhật Category
  Future<void> updateCategory(String id, CategoryRutGonModel category) async {
    await executeWithCallback(
      () => _repository.updateCategory(id, category),
      onSuccess: (_) => loadCategories(),
    );
  }

  /// ✅ Xóa Category
  Future<void> deleteCategory(String id) async {
    await executeWithCallback(
      () => _repository.deleteCategory(id),
      onSuccess: (_) => loadCategories(),
    );
  }
}
