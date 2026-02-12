// ════════════════════════════════════════════════════════════════
// 📁 category_toi_uu/presentation/bloc/category_event.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';

/// Load danh sách categories
class LoadCategories extends BaseEvent {
  final Map<String, dynamic>? params;
  final bool refresh;

  const LoadCategories({this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}

/// Load chi tiết category
class LoadCategoryDetail extends BaseEvent {
  final String id;

  const LoadCategoryDetail(this.id);

  @override
  List<Object?> get props => [id];
}

/// Tạo category mới
class CreateCategory extends BaseEvent {
  final Map<String, dynamic> data;

  const CreateCategory(this.data);

  @override
  List<Object?> get props => [data];
}

/// Cập nhật category
class UpdateCategory extends BaseEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateCategory({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

/// Xóa category
class DeleteCategory extends BaseEvent {
  final String id;

  const DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}
