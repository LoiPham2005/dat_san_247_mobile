import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/search_history_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/services/venue_search_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class VenueSearchRepository with ApiHandlerMixin {
  final VenueSearchService _service;

  VenueSearchRepository(this._service);

  Future<Result<List<VenueSearchResultModel>>> searchVenues(Map<String, dynamic> params) {
    return safeCallUnwrap(() => _service.searchVenues(queries: params));
  }

  Future<Result<List<SearchHistoryModel>>> getSearchHistory() {
    return safeCallUnwrap(() => _service.getSearchHistory());
  }

  Future<Result<bool>> saveSearchHistory(String keyword, {String? sportType}) {
    return safeCallUnwrap(() => _service.saveSearchHistory(body: {
      'keyword': keyword,
      if (sportType != null) 'sport_type': sportType,
    }));
  }

  Future<Result<bool>> clearSearchHistory() {
    return safeCallUnwrap(() => _service.clearSearchHistory());
  }

  Future<Result<bool>> toggleFavorite(String venueId) {
    return safeCallUnwrap(() => _service.toggleFavorite(body: {'venue_id': venueId}));
  }
}
