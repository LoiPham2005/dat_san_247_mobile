// ════════════════════════════════════════════════════════════════
// 📁 bricks/feature/__brick__/lib/features/{{feature_name.snakeCase()}}/presentation/bloc/{{feature_name.snakeCase()}}_bloc.dart (FIXED)
// ════════════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_event.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/state_management/bloc/base_bloc.dart';
import 'package:dat_san_247_mobile/core/utils/logger.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}.dart';
import '../../domain/usecases/{{feature_name.snakeCase()}}_usecases.dart';

// ════════════════════════════════════════════════════════════════
// EVENTS
// ════════════════════════════════════════════════════════════════

{{#has_list}}
/// Fetch {{feature_name.lowerCase()}}s list
class Fetch{{feature_name.pascalCase()}}sEvent extends void BaseEvent {
  final Map<String, dynamic>? params;
  final bool refresh;

  const Fetch{{feature_name.pascalCase()}}sEvent({
    this.params,
    this.refresh = false,
  });

  @override
  List<Object?> get List<Object?> props => [params, refresh];
}
{{/has_list}}

{{#has_detail}}
/// Fetch {{feature_name.lowerCase()}} detail
class Fetch{{feature_name.pascalCase()}}DetailEvent extends void BaseEvent {
  final String id;

  const Fetch{{feature_name.pascalCase()}}DetailEvent(this.id);

  @override
  List<Object?> get List<String> props => [id];
}
{{/has_detail}}

{{#has_create}}
/// Create {{feature_name.lowerCase()}}
class Create{{feature_name.pascalCase()}}Event extends void BaseEvent {
  final Map<String, dynamic> data;

  const Create{{feature_name.pascalCase()}}Event(this.data);

  @override
  List<Object?> get List<Map<String, dynamic>> props => [data];
}
{{/has_create}}

{{#has_update}}
/// Update {{feature_name.lowerCase()}}
class Update{{feature_name.pascalCase()}}Event extends void BaseEvent {
  final String id;
  final Map<String, dynamic> data;

  const Update{{feature_name.pascalCase()}}Event(this.id, this.data);

  @override
  List<Object?> get List<Object> props => [id, data];
}
{{/has_update}}

{{#has_delete}}
/// Delete {{feature_name.lowerCase()}}
class Delete{{feature_name.pascalCase()}}Event extends void BaseEvent {
  final String id;

  const Delete{{feature_name.pascalCase()}}Event(this.id);

  @override
  List<Object?> get List<String> props => [id];
}
{{/has_delete}}

// ════════════════════════════════════════════════════════════════
// BLOC
// ════════════════════════════════════════════════════════════════

@injectable
class {{feature_name.pascalCase()}}Bloc extends void BaseBloc {
  {{#has_list}}final Get{{feature_name.pascalCase()}}sUseCase get{{feature_name.pascalCase()}}sUseCase;{{/has_list}}
  {{#has_detail}}final Get{{feature_name.pascalCase()}}DetailUseCase get{{feature_name.pascalCase()}}DetailUseCase;{{/has_detail}}
  {{#has_create}}final Create{{feature_name.pascalCase()}}UseCase create{{feature_name.pascalCase()}}UseCase;{{/has_create}}
  {{#has_update}}final Update{{feature_name.pascalCase()}}UseCase update{{feature_name.pascalCase()}}UseCase;{{/has_update}}
  {{#has_delete}}final Delete{{feature_name.pascalCase()}}UseCase delete{{feature_name.pascalCase()}}UseCase;{{/has_delete}}

  {{feature_name.pascalCase()}}Bloc({
    {{#has_list}}required Get{{feature_name.pascalCase()}}sUseCase get{{feature_name.pascalCase()}}sUseCase,{{/has_list}}
    {{#has_detail}}required Get{{feature_name.pascalCase()}}DetailUseCase get{{feature_name.pascalCase()}}DetailUseCase,{{/has_detail}}
    {{#has_create}}required Create{{feature_name.pascalCase()}}UseCase create{{feature_name.pascalCase()}}UseCase,{{/has_create}}
    {{#has_update}}required Update{{feature_name.pascalCase()}}UseCase update{{feature_name.pascalCase()}}UseCase,{{/has_update}}
    {{#has_delete}}required Delete{{feature_name.pascalCase()}}UseCase delete{{feature_name.pascalCase()}}UseCase,{{/has_delete}}
  }) : {{#has_list}}get{{feature_name.pascalCase()}}sUseCase = get{{feature_name.pascalCase()}}sUseCase,{{/has_list}}
       {{#has_detail}}get{{feature_name.pascalCase()}}DetailUseCase = get{{feature_name.pascalCase()}}DetailUseCase,{{/has_detail}}
       {{#has_create}}create{{feature_name.pascalCase()}}UseCase = create{{feature_name.pascalCase()}}UseCase,{{/has_create}}
       {{#has_update}}update{{feature_name.pascalCase()}}UseCase = update{{feature_name.pascalCase()}}UseCase,{{/has_update}}
       {{#has_delete}}delete{{feature_name.pascalCase()}}UseCase = delete{{feature_name.pascalCase()}}UseCase,{{/has_delete}}
       super(BaseState.initial()) {
    {{#has_list}}on<Fetch{{feature_name.pascalCase()}}sEvent>(onFetch{{feature_name.pascalCase()}}s);{{/has_list}}
    {{#has_detail}}on<Fetch{{feature_name.pascalCase()}}DetailEvent>(onFetch{{feature_name.pascalCase()}}Detail);{{/has_detail}}
    {{#has_create}}on<Create{{feature_name.pascalCase()}}Event>(onCreate{{feature_name.pascalCase()}});{{/has_create}}
    {{#has_update}}on<Update{{feature_name.pascalCase()}}Event>(onUpdate{{feature_name.pascalCase()}});{{/has_update}}
    {{#has_delete}}on<Delete{{feature_name.pascalCase()}}Event>(onDelete{{feature_name.pascalCase()}});{{/has_delete}}
  }

  {{#has_list}}
  /// ✅ Fetch {{feature_name.lowerCase()}}s - dùng execute() hoặc executeRefresh()
  Future<void> onFetch{{feature_name.pascalCase()}}Future<void> s(
    Fetch{{feature_name.pascalCase()}}sEvent event,
    Emitter<BaseState> emit,
  ) async {
    if (event.refresh) {
      // Pull-to-refresh
      await executeRefresh<List<{{feature_name.pascalCase()}}>>(
        event: event,
        emit: emit,
        action: () => get{{feature_name.pascalCase()}}sUseCase(params: event.params),
        onSuccess: (data) {
          Logger.info('✅ Loaded {{feature_name.lowerCase()}}s: ${data.length} items');
        },
        onFailure: (failure) {
          Logger.error('❌ Failed to load {{feature_name.lowerCase()}}s', error: failure.message);
        },
      );
    } else {
      // Initial load
      await execute<List<{{feature_name.pascalCase()}}>>(
        event: event,
        emit: emit,
        action: () => get{{feature_name.pascalCase()}}sUseCase(params: event.params),
        onSuccess: (data) {
          Logger.info('✅ Loaded {{feature_name.lowerCase()}}s: ${data.length} items');
        },
        onFailure: (failure) {
          Logger.error('❌ Failed to load {{feature_name.lowerCase()}}s', error: failure.message);
        },
      );
    }
  }
  {{/has_list}}

  {{#has_detail}}
  /// ✅ Fetch {{feature_name.lowerCase()}} detail
  Future<void> onFetch{{feature_name.pascalCase()}}Future<void> Detail(
    Fetch{{feature_name.pascalCase()}}DetailEvent event,
    Emitter<BaseState> emit,
  ) async {
    await execute<{{feature_name.pascalCase()}}>(
      event: event,
      emit: emit,
      action: () => get{{feature_name.pascalCase()}}DetailUseCase(event.id),
      onSuccess: (data) {
        Logger.info('✅ Loaded {{feature_name.lowerCase()}} detail');
      },
      onFailure: (failure) {
        Logger.error('❌ Failed to load {{feature_name.lowerCase()}} detail', error: failure.message);
      },
    );
  }
  {{/has_detail}}

  {{#has_create}}
  /// ✅ Create {{feature_name.lowerCase()}} - dùng executeMutation()
  Future<void> onCreate{{feature_name.pascalCase()}}(
    Create{{feature_name.pascalCase()}}Event event,
    Emitter<BaseState> emit,
  ) async {
    await executeMutation<{{feature_name.pascalCase()}}>(
      event: event,
      emit: emit,
      action: () => create{{feature_name.pascalCase()}}UseCase(event.data),
      successMessage: '{{feature_name.titleCase()}} created successfully',
      onSuccess: (data) {
        Logger.success('✅ {{feature_name.titleCase()}} created');
      },
      onFailure: (failure) {
        Logger.error('❌ Failed to create {{feature_name.lowerCase()}}', error: failure.message);
      },
    );
  }
  {{/has_create}}

  {{#has_update}}
  /// ✅ Update {{feature_name.lowerCase()}} - dùng executeMutation()
  Future<void> onUpdate{{feature_name.pascalCase()}}(
    Update{{feature_name.pascalCase()}}Event event,
    Emitter<BaseState> emit,
  ) async {
    await executeMutation<{{feature_name.pascalCase()}}>(
      event: event,
      emit: emit,
      action: () => update{{feature_name.pascalCase()}}UseCase(event.id, event.data),
      successMessage: '{{feature_name.titleCase()}} updated successfully',
      onSuccess: (data) {
        Logger.success('✅ {{feature_name.titleCase()}} updated');
      },
      onFailure: (failure) {
        Logger.error('❌ Failed to update {{feature_name.lowerCase()}}', error: failure.message);
      },
    );
  }
  {{/has_update}}

  {{#has_delete}}
  /// ✅ Delete {{feature_name.lowerCase()}} - dùng executeMutation()
  Future<void> onDelete{{feature_name.pascalCase()}}(
    Delete{{feature_name.pascalCase()}}Event event,
    Emitter<BaseState> emit,
  ) async {
    await executeMutation<bool>(
      event: event,
      emit: emit,
      action: () => delete{{feature_name.pascalCase()}}UseCase(event.id),
      successMessage: '{{feature_name.titleCase()}} deleted successfully',
      onSuccess: (_) {
        Logger.success('✅ {{feature_name.titleCase()}} deleted');
      },
      onFailure: (failure) {
        Logger.error('❌ Failed to delete {{feature_name.lowerCase()}}', error: failure.message);
      },
    );
  }
  {{/has_delete}}
}
