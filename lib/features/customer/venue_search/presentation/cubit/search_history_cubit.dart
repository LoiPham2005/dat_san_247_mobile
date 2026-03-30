import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/core/services/app_auth/app_auth_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/repositories/venue_search_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchHistoryCubit extends BaseCubit<List<SearchHistoryModel>> {
  final VenueSearchRepository _repository;
  final AppAuthCubit _authCubit;

  SearchHistoryCubit(this._repository, this._authCubit) : super(BaseState.initial());

  bool get _isAuthenticated => _authCubit.state.isAuthenticated;

  Future<void> getSearchHistory() async {
    if (!_isAuthenticated) {
      safeEmit(BaseState.success(data: []));
      return;
    }
    await run<List<SearchHistoryModel>>(
      action: () => _repository.getSearchHistory(),
    );
  }

  Future<void> saveSearchHistory(String keyword, {String? sportType}) async {
    if (!_isAuthenticated) return;
    final result = await _repository.saveSearchHistory(keyword, sportType: sportType);
    if (result.isSuccess) {
      await getSearchHistory(); // Refresh
    }
  }

  Future<void> clearSearchHistory() async {
    if (!_isAuthenticated) return;
    final result = await _repository.clearSearchHistory();
    if (result.isSuccess) {
      safeEmit(BaseState.success(data: []));
    }
  }
}
