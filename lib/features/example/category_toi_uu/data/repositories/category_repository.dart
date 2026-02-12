// ════════════════════════════════════════════════════════════════
// 📁 category_toi_uu/data/repositories/category_repository.dart
// ════════════════════════════════════════════════════════════════
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/result.dart';
import '../../../../../core/mixins/api_handler_mixin.dart';
import '../../domain/entities/category_entity.dart';
import '../services/category_service.dart';

/// 🎯 CategoryRepository — Optimized Hybrid Pattern
///
/// ✅ Gộp DataSource + Repository (bỏ DataSource layer dư thừa)
/// ✅ Dùng ApiHandlerMixin cho error handling (safeCall/safeCallBool)
/// ✅ Transform Model → Entity tại đây (single responsibility)
/// ✅ Trả về Entity cho presentation layer (UI không biết về Model)
@LazySingleton()
class CategoryRepository with ApiHandlerMixin {
  final CategoryService _service;

  CategoryRepository(this._service);

  /// Lấy danh sách categories
  Future<Result<List<CategoryEntity>>> getCategories({Map<String, dynamic>? params}) async {
    final result = await safeCall(() => _service.getCategories(params: params));
    // Transform List<Model> → List<Entity>
    return result.mapItems((model) => model.toEntity());
  }

  /// Lấy chi tiết category theo ID
  Future<Result<CategoryEntity>> getCategoryDetail(String id) async {
    final result = await safeCall(() => _service.getCategoryDetail(id));
    return result.map((model) => model.toEntity());
  }

  /// Tạo category mới
  Future<Result<CategoryEntity>> createCategory(Map<String, dynamic> data) async {
    final result = await safeCall(() => _service.createCategory(data));
    return result.map((model) => model.toEntity());
  }

  /// Cập nhật category
  Future<Result<CategoryEntity>> updateCategory(String id, Map<String, dynamic> data) async {
    final result = await safeCall(() => _service.updateCategory(id, data));
    return result.map((model) => model.toEntity());
  }

  /// Xóa category
  Future<Result<bool>> deleteCategory(String id) {
    return safeCallBool(() => _service.deleteCategory(id));
  }
}
