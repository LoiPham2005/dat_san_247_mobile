import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_detail_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/repositories/venue_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_detail_notifier.g.dart';

@riverpod
class VenueDetailNotifier extends _$VenueDetailNotifier
    with BaseNotifier<VenueDetailModel> {
  late final VenueDetailRepository _repository;
  late final String _slug;

  @override
  Future<VenueDetailModel> build(String slug) async {
    _repository = getIt<VenueDetailRepository>();
    _slug = slug;
    final result = await _repository.getVenueDetail(slug);
    return result.fold(
      onSuccess: (data) => data,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: () => _repository.getVenueDetail(_slug),
        mapper: (data) => data,
        keepPreviousOnLoading: true,
      );

  Future<void> toggleFavorite(String venueId) async {
    final result = await _repository.toggleFavorite(venueId);
    if (!result.isSuccess) return;
    final isFavorite = result.dataOrNull ?? false;
    final model = currentData;
    if (model == null) return;
    state = AsyncData(model.copyWith(isFavorite: isFavorite));
  }
}
