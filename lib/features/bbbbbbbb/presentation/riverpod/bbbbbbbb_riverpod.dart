import 'dart:async';

import 'package:dat_san_247_mobile/core/di/injection.dart';
import 'package:dat_san_247_mobile/core/state_management/riverpod/base_async_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bbbbbbbb_model.dart';
import '../../data/repositories/bbbbbbbb_repository.dart';

final bbbbbbbbRepositoryProvider = Provider<BbbbbbbbRepository>((ref) {
  return getIt<BbbbbbbbRepository>();
});

final bbbbbbbbProvider =
    AsyncNotifierProvider<BbbbbbbbNotifier, List<BbbbbbbbModel>>(
      BbbbbbbbNotifier.new,
    );

class BbbbbbbbNotifier extends BaseAsyncNotifier<List<BbbbbbbbModel>> {
  late final BbbbbbbbRepository _repository;

  @override
  FutureOr<List<BbbbbbbbModel>> build() {
    _repository = ref.watch(bbbbbbbbRepositoryProvider);
    return [];
  }

  Future<void> loadBbbbbbbbs({Map<String, dynamic>? params}) async {
    await onQuery(action: () => _repository.getBbbbbbbbs(params: params));
  }

  Future<void> createBbbbbbbb(BbbbbbbbModel bbbbbbbb) async {
    await onMutation(
      action: () async {
        final result = await _repository.createBbbbbbbb(bbbbbbbb);
        return result.map((_) => state.value ?? []);
      },
      successMessage: 'Tạo thành công',
      onSuccess: (_) => loadBbbbbbbbs(),
    );
  }
}
