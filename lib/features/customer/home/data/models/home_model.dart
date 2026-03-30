import 'package:dat_san_247_mobile/features/customer/home/data/models/banner_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/sport_category_model.dart';
import 'package:dat_san_247_mobile/features/shared/promotion/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

@freezed
abstract class HomeModel with _$HomeModel {
  const factory HomeModel({
    @Default([]) List<BannerModel> banners,
    @Default([]) List<SportCategoryModel> categories,
    @Default([]) List<VenueModel> featuredVenues,
    @Default([]) List<VenueModel> recentVenues,
    @Default([]) List<PromotionModel> activePromotions,
  }) = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);
}
