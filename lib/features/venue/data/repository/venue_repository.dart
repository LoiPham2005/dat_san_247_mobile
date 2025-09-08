import 'package:dat_san_247_mobile/features/venue/data/models/venue.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/config/api/api_path.dart';
import 'package:dat_san_247_mobile/core/config/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/api_helper.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/base_response.dart';

class VenueRepository {
  final DioClient dio = Get.find<DioClient>();

  Future<BaseResponse<List<Venue>>> getVenue() {
    return ApiHelper.handleListRequest(
      apiCall: () => dio.get(ApiPath.venue),
      fromJson: (json) => Venue.fromJson(json),
    );
  }

  // Future<BaseResponse<List<Venue>>> getVenue() async {
  //   final response = await dio.get(ApiPath.venue);
  //   // return BaseResponse.listFromResponse(
  //   //   response,
  //   //   (json) => Venue.fromJson(json),
  //   // );
  //   // final data = response.data['data'];
  //   return BaseResponse<List<Venue>>(
  //     success: true,
  //     message: response.data['message'],
  //     data: (response.data['data'] as List)
  //         .map((json) => Venue.fromJson(json))
  //         .toList()
  //   );
  // }
}
