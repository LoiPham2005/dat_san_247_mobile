// ════════════════════════════════════════════════════════════════
// 📁 lib/features/category/presentation/bloc/category_bloc.dart
// ════════════════════════════════════════════════════════════════
import 'package:dat_san_247_mobile/core/state_management/bloc/base_bloc.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/category_repository.dart';
import 'category_event.dart';

@injectable
class CategoryRutGonBloc extends BaseBloc {
  final CategoryRutGonRepository _repository;

  CategoryRutGonBloc(this._repository) : super(BaseState.initial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<BaseState> emit) async {
    await execute(
      emit: emit,
      action: () => _repository.getCategories(params: event.params),
    );
  }
}
