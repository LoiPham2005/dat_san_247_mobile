import 'package:dat_san_247_mobile/core/config/api/api_path.dart';
import 'package:dat_san_247_mobile/core/config/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/api_helper.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/features/category/data/model/sport_category.dart';
import 'package:get/get.dart';

class SportCategoryRepository {
  final DioClient _dio = Get.find<DioClient>();

  Future<BaseResponse<List<SportCategory>>> getCategories() async {
    return ApiHelper.handleListRequest(
      apiCall: () => _dio.get(ApiPath.sportCategory),
      fromJson: (json) => SportCategory.fromJson(json),
    );
    // return ApiHelper.handleListRequest(
    //   apiCall: () => _dio.get(ApiPath.sportCategory),
    //   fromJson: (json) {
    //     print("SportCategoryRepository dataaaaaaaaaaaaaaaaaa: $json");
    //     return SportCategories.fromJson(json);
    //   },
    // );
  }
}
