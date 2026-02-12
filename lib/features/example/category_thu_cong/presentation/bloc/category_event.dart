// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/presentation/bloc/category_event.dart
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
