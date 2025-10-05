import 'package:dat_san_247_mobile/features/home/presentation2/widgets/nearby_venues_section.dart';
import 'package:dat_san_247_mobile/features/my_booking/data/models/venue.dart';
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

  Future<BaseResponse<Venue>> getIdVenue(int venueId) async {
    // return ApiHelper.handleRequest(
    //   apiCall: () => dio.get('${ApiPath.venue}/$venueId'),
    //   fromJson: (json) => Venue.fromJson(json),
    // );

    return BaseResponse.fromResponse(
      await dio.get('${ApiPath.venue}/$venueId'),
       Venue.fromJson,
      // dataKey: 'data',
      // extract: (map) => map['data']?['venue'],
    );
  }


   Future<List<VenueCardItem>> getNearbyVenues({
    required double lat,
    required double lng,
    double radius = 5,
  }) async {
    try {
      final response = await dio.get(
        '${ApiPath.venue}/nearby',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'radius': radius,
        },
      );

      final List<VenueCardItem> venues = (response.data['data'] as List)
          .map((item) => VenueCardItem(
                name: item['name'],
                address: item['address'],
                price: item['price'].toDouble(),
                rating: item['rating'].toDouble(),
                reviewCount: item['reviewCount'],
                imageUrl: item['imageUrl'],
                distance: '${item['distance']} km',
                isPromoted: item['isPromoted'],
              ))
          .toList();

      return venues;
    } catch (e) {
      throw Exception('Không thể lấy danh sách sân gần đây: $e');
    }
  }
}
