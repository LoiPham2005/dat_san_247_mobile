import 'package:flutter_base_template/core/state_management/bloc/base_event.dart';
import 'package:flutter_base_template/core/state_management/bloc/base_state.dart';
import 'package:flutter_base_template/core/state_management/bloc/bloc_helper.dart';
import 'package:flutter_base_template/features/category/domain/entities/category.dart';
import 'package:flutter_base_template/features/category/domain/usecases/category_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class LoadCategories extends BaseEvent {
  final Map<String, dynamic>? params;
  final bool refresh;

  const LoadCategories({this.params, this.refresh = false});

  @override
  List<Object?> get props => [params, refresh];
}

@injectable
class CategoryBloc extends Bloc<BaseEvent, BaseState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryBloc({required GetCategoriesUseCase getCategoriesUseCase})
    : _getCategoriesUseCase = getCategoriesUseCase,
      super(BaseState.initial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<BaseState> emit,
  ) async {
    await execute<List<Category>, BaseState>(
      emit: emit,
      useCaseCall: () => _getCategoriesUseCase(params: event.params),
      stateBuilder: ({status, data, errorMessage}) => state.copyWith(
        status: status,
        data: data ?? state.data,
        error: errorMessage,
      ),
    );
  }
}
