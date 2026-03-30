import 'package:dat_san_247_mobile/core/base/errors/result.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/cubit/base_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/home_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/repositories/home_repository.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/banner_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/sport_category_model.dart';
import 'package:dat_san_247_mobile/features/shared/promotion/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeModel> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(BaseState.initial());

  Future<void> init() async {
    await fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    await run<HomeModel>(
      action: () async {
        final results = await Future.wait([
          _repository.getBanners(),
          _repository.getSportCategories(),
          _repository.getFeaturedVenues(),
          _repository.getRecentVenues(),
          _repository.getActivePromotions(),
        ]);

        final banners = (results[0] as Result<List<BannerModel>>).dataOrNull ?? [];
        final categories = (results[1] as Result<List<SportCategoryModel>>).dataOrNull ?? [];
        final featuredVenues = (results[2] as Result<List<VenueModel>>).dataOrNull ?? [];
        final recentVenues = (results[3] as Result<List<VenueModel>>).dataOrNull ?? [];
        final promotions = (results[4] as Result<List<PromotionModel>>).dataOrNull ?? [];

        return Result.success(HomeModel(
          banners: List.from(banners),
          categories: List.from(categories),
          featuredVenues: List.from(featuredVenues),
          recentVenues: List.from(recentVenues),
          activePromotions: List.from(promotions),
        ));
      },
    );
  }

  Future<void> toggleFavorite(String venueId) async {
    // We can use the repository to toggle
    final result = await _repository.toggleFavorite(venueId);
    if (result.isSuccess) {
      final isFavorite = result.dataOrNull ?? false;
      state.whenSuccess(
        (model, message) {
          // Update featuredVenues
          final updatedFeatured = model.featuredVenues.map((v) {
            if (v.id == venueId) return v.copyWith(isFavorite: isFavorite);
            return v;
          }).toList();
          
          // Update recentVenues
          final updatedRecent = model.recentVenues.map((v) {
            if (v.id == venueId) return v.copyWith(isFavorite: isFavorite);
            return v;
          }).toList();

          emit(BaseState.success(
            data: model.copyWith(
              featuredVenues: updatedFeatured,
              recentVenues: updatedRecent,
            ),
            message: isFavorite ? 'Đã thêm vào yêu thích' : 'Đã xóa khỏi yêu thích',
          ));
        },
      );
    }
  }
}
