import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/services/favorite_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FavoriteRepository with ApiHandlerMixin {
  final FavoriteService _service;

  FavoriteRepository(this._service);

  Future<Result<List<FavoriteVenueModel>>> getFavorites() {
    return safeCallUnwrap(() => _service.getFavorites());
  }

  Future<Result<bool>> toggleFavorite(String venueId) {
    return safeCallUnwrap(() => _service.toggleFavorite(body: {'venue_id': venueId}));
  }
}
