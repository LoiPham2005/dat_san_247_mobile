import 'dart:async';

import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/base_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/{{feature_name.snakeCase()}}_model.dart';
import '../../data/repositories/{{feature_name.snakeCase()}}_repository.dart';

final {{feature_name.camelCase()}}RepositoryProvider = Provider<{{feature_name.pascalCase()}}Repository>((ref) {
  return getIt<{{feature_name.pascalCase()}}Repository>();
});

final {{feature_name.camelCase()}}Provider =
    AsyncNotifierProvider<{{feature_name.pascalCase()}}Notifier, List<{{feature_name.pascalCase()}}Model>>(
      {{feature_name.pascalCase()}}Notifier.new,
    );

class {{feature_name.pascalCase()}}Notifier extends BaseAsyncNotifier<List<{{feature_name.pascalCase()}}Model>> {
  late final {{feature_name.pascalCase()}}Repository _repository;

  @override
  FutureOr<List<{{feature_name.pascalCase()}}Model>> build() {
    _repository = ref.watch({{feature_name.camelCase()}}RepositoryProvider);
    return [];
  }

  Future<void> load{{feature_name.pascalCase()}}s({Map<String, dynamic>? params}) async {
    await onQuery(action: () => _repository.get{{feature_name.pascalCase()}}s(params: params));
  }

  Future<void> create{{feature_name.pascalCase()}}({{feature_name.pascalCase()}}Model {{feature_name.camelCase()}}) async {
    await onMutation(
      action: () async {
        final result = await _repository.create{{feature_name.pascalCase()}}({{feature_name.camelCase()}});
        return result.map((_) => state.value ?? []);
      },
      successMessage: 'Tạo thành công',
      onSuccess: (_) => load{{feature_name.pascalCase()}}s(),
    );
  }
}
