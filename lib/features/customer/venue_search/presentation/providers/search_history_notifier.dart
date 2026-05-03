import 'dart:async';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/providers/app_auth_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/repositories/venue_search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/di/injection.dart';

part 'search_history_notifier.g.dart';

@riverpod
class SearchHistoryNotifier extends _$SearchHistoryNotifier with BaseNotifier<List<SearchHistoryModel>> {
  late final VenueSearchRepository _repository;

  @override
  FutureOr<List<SearchHistoryModel>> build() async {
    _repository = getIt<VenueSearchRepository>();

    // Nếu chưa đăng nhập thì trả về list trống
    final authState = ref.watch(appAuth);
    if (!authState.isAuthenticated) {
      return [];
    }

    return _fetchSearchHistory();
  }

  Future<List<SearchHistoryModel>> _fetchSearchHistory() async {
    final result = await _repository.getSearchHistory();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> getSearchHistory() async {
    final authState = ref.read(appAuth);
    if (!authState.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }

    await runAsync(
      action: () => _fetchSearchHistory(),
      keepPreviousOnLoading: true,
    );
  }

  Future<void> saveSearchHistory(String keyword, {String? sportType}) async {
    final authState = ref.read(appAuth);
    if (!authState.isAuthenticated) return;

    final result = await _repository.saveSearchHistory(keyword, sportType: sportType);
    if (result.isSuccess) {
      await getSearchHistory(); // Refresh
    }
  }

  Future<void> clearSearchHistory() async {
    final authState = ref.read(appAuth);
    if (!authState.isAuthenticated) return;

    final result = await _repository.clearSearchHistory();
    if (result.isSuccess) {
      state = const AsyncData([]);
    }
  }
}
