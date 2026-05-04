import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/base_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/repositories/venue_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_venue_detail_notifier.g.dart';

@riverpod
class OwnerVenueDetailNotifier extends _$OwnerVenueDetailNotifier
    with BaseNotifier<OwnerVenueModel> {
  late final OwnerVenueRepository _repository;
  late final String _venueId;

  @override
  Future<OwnerVenueModel> build(String venueId) async {
    _repository = getIt<OwnerVenueRepository>();
    _venueId = venueId;
    final result = await _repository.getVenueDetail(venueId);
    return result.fold(
      onSuccess: (v) => v,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() => runResult(
        action: () => _repository.getVenueDetail(_venueId),
        mapper: (v) => v,
        keepPreviousOnLoading: true,
      );

  Future<void> updateVenue(Map<String, dynamic> data) => runResult(
        action: () => _repository.updateVenue(_venueId, data),
        mapper: (v) => v,
        keepPreviousOnLoading: true,
      );
}
