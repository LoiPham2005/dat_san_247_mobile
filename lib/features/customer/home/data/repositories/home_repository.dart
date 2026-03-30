import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/common/mixins/api_handler_mixin.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/banner_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/sport_category_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/services/home_service.dart';
import 'package:dat_san_247_mobile/features/shared/promotion/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class HomeRepository with ApiHandlerMixin {
  final HomeService _service;

  HomeRepository(this._service);

  Future<Result<List<BannerModel>>> getBanners() {
    return safeCallUnwrap(() => _service.getBanners(params: {
      'is_active': true,
      'position': 'HOME_TOP',
    }));
  }

  Future<Result<List<SportCategoryModel>>> getSportCategories() {
    return safeCallUnwrap(() => _service.getSportCategories(params: {'is_active': true}));
  }

  Future<Result<List<VenueModel>>> getFeaturedVenues() {
    return safeCallUnwrap(() => _service.getFeaturedVenues(params: {
      'is_featured': true,
      'is_active': true,
    }));
  }

  Future<Result<List<VenueModel>>> getRecentVenues() {
    return safeCallUnwrap(() => _service.getFeaturedVenues(params: {
      'is_active': true,
      'limit': 10,
    }));
  }

  Future<Result<List<PromotionModel>>> getActivePromotions() {
    return safeCallUnwrap(() => _service.getActivePromotions(params: {'status': 'ACTIVE'}));
  }

  Future<Result<bool>> toggleFavorite(String venueId) {
    return safeCallUnwrap(() => _service.toggleFavorite(body: {'venue_id': venueId}));
  }
}
