import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/repositories/favorite_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_notifier.g.dart';

@riverpod
class FavoriteNotifier extends _$FavoriteNotifier
    with BaseNotifier<List<FavoriteVenueModel>> {
  late final FavoriteRepository _repository;

  @override
  Future<List<FavoriteVenueModel>> build() async {
    _repository = getIt<FavoriteRepository>();
    final result = await _repository.getFavorites();
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: _repository.getFavorites,
        mapper: (data) => data,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );

  /// Toggle favorite + reload list. Optimistic remove cho UX mượt.
  Future<void> toggleFavorite(String venueId) async {
    final snapshot = currentData ?? [];
    state = AsyncData(snapshot.where((v) => v.venueId != venueId).toList());
    final result = await _repository.toggleFavorite(venueId);
    if (result.isSuccess) {
      await refresh();
    } else {
      state = AsyncData(snapshot);
    }
  }
}
