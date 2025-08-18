import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:dat_san_247_mobile/core/config/config_getx/base_controller.dart';
import 'package:dat_san_247_mobile/features/product/data/models/product_model.dart';
import 'package:dat_san_247_mobile/features/product/data/repository/product_repository.dart';

class ProductController extends BaseController {
  final ProductRepository productRepository = Get.find<ProductRepository>();

  // RxList lưu sản phẩm
  RxList<ProductModel> topSellingShoes = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTopSelling();
  }

  @override
  void onClose() {
    super.onClose();
    topSellingShoes.clear();
  }

  Future<void> getTopSelling() {
    print("bbbbbbbbbbbbbbbbb ${productRepository.getTopSelling()}");
    return performAction(
      action: () => productRepository.getTopSelling(),
      onSuccess: (data) {
        topSellingShoes.assignAll([data]);
      },
    );
  }

  
}
