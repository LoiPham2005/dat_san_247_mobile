// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category_rut_gon/data/category_repository.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/errors/result.dart';
import 'package:dat_san_247_mobile/core/mixins/api_handler_mixin.dart';
import 'package:injectable/injectable.dart';

import 'category_model.dart';
import 'category_service.dart';

/// CategoryRepository — Gộp DataSource + Repository + UseCase
@LazySingleton()
class CategoryRutGonRepository with ApiHandlerMixin {
  final CategoryRutGonService _service;

  CategoryRutGonRepository(this._service);

  /// Lấy danh sách categories
  Future<Result<List<CategoryRutGonModel>>> getCategories({Map<String, dynamic>? params}) {
    return safeCall(() => _service.getCategories(params: params));
  }

  /// Lấy chi tiết category
  Future<Result<CategoryRutGonModel>> getCategoryDetail(String id) {
    return safeCall(() => _service.getCategoryDetail(id));
  }

  /// Tạo category mới
  Future<Result<CategoryRutGonModel>> createCategory(CategoryRutGonModel data) {
    return safeCall(() => _service.createCategory(data));
  }

  /// Cập nhật category
  Future<Result<CategoryRutGonModel>> updateCategory(String id, CategoryRutGonModel data) {
    return safeCall(() => _service.updateCategory(id, data));
  }

  /// Xóa category
  Future<Result<bool>> deleteCategory(String id) {
    return safeCallBool(() => _service.deleteCategory(id));
  }
}
