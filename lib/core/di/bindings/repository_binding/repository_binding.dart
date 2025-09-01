import 'package:dat_san_247_mobile/features/auth/data/repository/user_repository.dart';
import 'package:dat_san_247_mobile/features/category/data/repository/sport_category_repository.dart';
import 'package:dat_san_247_mobile/features/home/data/repository/banner_repository.dart';
import 'package:dat_san_247_mobile/features/venue/data/repository/venue_repository.dart';
import 'package:get/get.dart';

class RepositoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<VenueRepository>(() => VenueRepository());
    Get.lazyPut<BannerRepository>(() => BannerRepository());
    Get.lazyPut<SportCategoryRepository>(() => SportCategoryRepository());
    Get.lazyPut<VenueRepository>(() => VenueRepository());
    
  }
}
