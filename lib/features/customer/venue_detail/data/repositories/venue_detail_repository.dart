import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_detail_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/services/venue_detail_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class VenueDetailRepository with ApiHandlerMixin {
  final VenueDetailService _service;

  VenueDetailRepository(this._service);

  Future<Result<VenueDetailModel>> getVenueDetail(String slug) {
    return safeCallUnwrap(() => _service.getVenueDetail(slug: slug));
  }

  Future<Result<Map<String, dynamic>>> getVenueSchedule(String slug, {String? date}) async {
    final result = await safeCallUnwrap(() => _service.getVenueSchedule(slug: slug, date: date));
    return result.map((data) => data as Map<String, dynamic>);
  }

  Future<Result<bool>> toggleFavorite(String venueId) {
    return safeCallUnwrap(() => _service.toggleFavorite(body: {'venue_id': venueId}));
  }
}
