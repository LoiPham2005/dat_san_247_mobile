import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/repositories/venue_search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_search_notifier.g.dart';

@riverpod
class VenueSearchNotifier extends _$VenueSearchNotifier
    with BaseNotifier<List<VenueSearchResultModel>> {
  late final VenueSearchRepository _repository;

  @override
  Future<List<VenueSearchResultModel>> build() async {
    _repository = getIt<VenueSearchRepository>();
    final result = await _repository.searchVenues({});
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> searchVenues(Map<String, dynamic> params) => runResult(
        action: () => _repository.searchVenues(params),
        mapper: (data) => data,
        cancelPrevious: true,
        keepPreviousOnLoading: true,
        emitEmptyForEmptyList: true,
      );

  Future<void> toggleFavorite(String venueId) async {
    await _repository.toggleFavorite(venueId);
  }
}
