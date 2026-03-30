import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/repositories/venue_search_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class VenueSearchCubit extends BaseCubit<List<VenueSearchResultModel>> {
  final VenueSearchRepository _repository;

  VenueSearchCubit(this._repository) : super(BaseState.initial());

  Future<void> searchVenues(Map<String, dynamic> params) async {
    await run<List<VenueSearchResultModel>>(
      action: () => _repository.searchVenues(params),
    );
  }

  Future<void> toggleFavorite(String venueId) async {
    final result = await _repository.toggleFavorite(venueId);
    if (result.isSuccess) {
      // Opt-in: can refresh state or just rely on toast
    }
  }
}
