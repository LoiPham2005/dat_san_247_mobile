import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/repositories/waitlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'waitlist_notifier.g.dart';

@riverpod
class WaitlistNotifier extends _$WaitlistNotifier
    with BaseNotifier<List<WaitlistModel>> {
  late final WaitlistRepository _repository;

  @override
  Future<List<WaitlistModel>> build() async {
    _repository = getIt<WaitlistRepository>();
    final result = await _repository.getMyWaitlist();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getMyWaitlist,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );

  Future<void> cancelWaitlist(String id) async {
    final result = await _repository.cancelWaitlist(id);
    if (result.isSuccess) await refresh();
  }
}
