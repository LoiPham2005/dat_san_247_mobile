import 'package:dat_san_247_mobile/core/api/api_path.dart';
import 'package:dat_san_247_mobile/core/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/config/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/core/config/repository_helper/api_helper.dart';
import 'package:dat_san_247_mobile/features/home/data/models/banner_model.dart';

class BannerRepository {
  DioClient _dio = DioClient();

  Future<BaseResponse<List<Banner>>> getBanner() async {
    // try {
    //   final response = await _dio.get(ApiPath.banner);

    //   return BaseResponse.listFromResponse(
    //     response,
    //     (json) => BannerModel.fromJson(json),
    //   );
    // } catch (e) {
    //   return BaseResponse.handleError(e);
    // }

    return ApiHelper.handleListRequest(
      apiCall: () => _dio.get(ApiPath.banner),
      fromJson: (json) => Banner.fromJson(json),
    );
  }
}
