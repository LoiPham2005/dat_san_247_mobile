import 'package:dat_san_247_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
import 'package:dat_san_247_mobile/features/home/presentation/controller/banner_controller.dart';
import 'package:dat_san_247_mobile/features/venue/data/repository/venue_repository.dart';
import 'package:dat_san_247_mobile/features/venue/presentation/controller/venue_controller.dart';
import 'package:get/get.dart';

class ControllerBinding implements Bindings {
  @override
  void dependencies() {
    // Permanent controllers
    Get.put(AuthController(), permanent: true);
    Get.put(SportCategoryController(), permanent: true);
    Get.put(VenueController(), permanent: true);
    Get.put(BannerController(), permanent: true);
  }
}
