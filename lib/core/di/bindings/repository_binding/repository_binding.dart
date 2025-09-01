import 'package:dat_san_247_mobile/features/auth/data/repository/user_repository.dart';
import 'package:dat_san_247_mobile/features/category/data/repository/sport_category_repository.dart';
import 'package:dat_san_247_mobile/features/home/data/repository/banner_repository.dart';
import 'package:dat_san_247_mobile/features/venue/data/repository/venue_repository.dart';
import 'package:get/get.dart';

class RepositoryBinding implements Bindings {
  @override
  void dependencies() {
    // Register all repositories as singletons
    Get.put(AuthRepository(), permanent: true);
    Get.put(VenueRepository(), permanent: true);
    Get.put(BannerRepository(), permanent: true);
    Get.put(SportCategoryRepository(), permanent: true);
  }
}
