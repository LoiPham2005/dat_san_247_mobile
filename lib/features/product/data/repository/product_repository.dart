import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/api/api_path.dart';
import 'package:dat_san_247_mobile/core/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/config/repository_helper/api_helper.dart';
import 'package:dat_san_247_mobile/core/config/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/features/product/data/models/product_model.dart';

class ProductRepository {
  final DioClient dio = Get.find<DioClient>();

  Future<BaseResponse<ProductModel>> getTopSelling() {
    return ApiHelper.handleRequest(
      apiCall: () => dio.get(ApiPath.shoesTopSelling),
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }
}
