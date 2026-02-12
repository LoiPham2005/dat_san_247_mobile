// import 'package:dat_san_247_mobile/core/constants/api_constants.dart';
// import 'package:dat_san_247_mobile/core/network/api_client.dart';
// import 'package:dat_san_247_mobile/core/network/api_response.dart';
// import 'package:dat_san_247_mobile/features/home/data/models/quick_stats.dart';
// import 'package:dat_san_247_mobile/features/home/data/models/venue_statistic_model.dart';
//
// class QuickStatsService {
//   ApiClient _api = ApiClient();
//
//  Future<ApiResponse<QuickStats>> getQuickStats()  {
//     // try {
//     //   final response = await _dio.get('${ApiPath.domain}/venue-statistics/quick-stats');
//     //   return response.data['data'];
//     // } catch (e) {
//     //   throw Exception('Không thể lấy thống kê: $e');
//     // }
//
//       return
//       _api.(
//       apiCall: () => _dio.get(ApiConstants.venueStatistics),
//       fromJson: (json) => QuickStats.fromJson(json),
//     );
//   }
// }
