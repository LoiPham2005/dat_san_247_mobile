// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/presentation/bloc/category_bloc.dart
// ════════════════════════════════════════════════════════════════
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/base/state/bloc/base_bloc.dart';
import '../../../../../core/base/state/bloc/base_state.dart';
import '../../data/repositories/category_repository.dart';
import 'category_event.dart';

@injectable
class CategoryRutGonBloc extends BaseBloc {
  final CategoryRutGonRepository _repository;

  CategoryRutGonBloc(this._repository) : super(BaseState.initial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<BaseState> emit,
  ) async {
    await run(
      emit: emit,
      action: () => _repository.getCategories(params: event.params),
    );
  }
}
