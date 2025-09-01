import 'package:dat_san_247_mobile/core/config/config_getx/base_controller.dart';
import 'package:dat_san_247_mobile/features/category/data/model/sport_category.dart';
import 'package:dat_san_247_mobile/features/category/data/repository/sport_category_repository.dart';
import 'package:dat_san_247_mobile/features/category/presentation/pages/sport_category_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SportCategoryController extends BaseController {
  final repo = Get.find<SportCategoryRepository>();
  RxList<SportCategory> listCategory = <SportCategory>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    return fetchList(
      action: () => repo.getCategories(),
      targetList: listCategory,
    );

    // return performAction(
    //   action: () => repo.getCategories(),
    //   targetList: listCategory,
    //   onSuccess: (data) {
    //     listCategory.assignAll(data);
    //   },
    // );
  }
}
