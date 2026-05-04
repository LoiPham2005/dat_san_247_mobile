import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/home_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier with BaseNotifier<HomeModel> {
  late final HomeRepository _repository;

  @override
  Future<HomeModel> build() async {
    _repository = getIt<HomeRepository>();
    return _fetchAll();
  }

  Future<HomeModel> _fetchAll() async {
    final results = await Future.wait([
      _repository.getBanners(),
      _repository.getSportCategories(),
      _repository.getFeaturedVenues(),
      _repository.getRecentVenues(),
      _repository.getActivePromotions(),
    ]);

    return HomeModel(
      banners: List.from(results[0].dataOrNull ?? []),
      categories: List.from(results[1].dataOrNull ?? []),
      featuredVenues: List.from(results[2].dataOrNull ?? []),
      recentVenues: List.from(results[3].dataOrNull ?? []),
      activePromotions: List.from(results[4].dataOrNull ?? []),
    );
  }

  Future<void> refresh() => runAsync(
        action: _fetchAll,
        keepPreviousOnLoading: true,
      );

  Future<void> toggleFavorite(String venueId) async {
    final result = await _repository.toggleFavorite(venueId);
    if (!result.isSuccess) return;
    final isFavorite = result.dataOrNull ?? false;
    final model = currentData;
    if (model == null) return;

    state = AsyncData(model.copyWith(
      featuredVenues: model.featuredVenues
          .map((v) => v.id == venueId ? v.copyWith(isFavorite: isFavorite) : v)
          .toList(),
      recentVenues: model.recentVenues
          .map((v) => v.id == venueId ? v.copyWith(isFavorite: isFavorite) : v)
          .toList(),
    ));
  }
}
