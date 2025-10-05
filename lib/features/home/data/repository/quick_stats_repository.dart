import 'package:dat_san_247_mobile/core/config/api/api_path.dart';
import 'package:dat_san_247_mobile/core/config/api/dio_client.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/api_helper.dart';
import 'package:dat_san_247_mobile/core/config/app/repository_helper/base_response.dart';
import 'package:dat_san_247_mobile/features/home/data/models/quick_stats.dart';
import 'package:dat_san_247_mobile/features/home/data/models/venue_statistic_model.dart';

class QuickStatsService {
  DioClient _dio = DioClient();
  
 Future<BaseResponse<QuickStats>> getQuickStats()  {
    // try {
    //   final response = await _dio.get('${ApiPath.domain}/venue-statistics/quick-stats');
    //   return response.data['data'];
    // } catch (e) {
    //   throw Exception('Không thể lấy thống kê: $e');
    // }

      return ApiHelper.handleRequest(
      apiCall: () => _dio.get(ApiPath.venueStatistics),
      fromJson: (json) => QuickStats.fromJson(json),
    );
  }
}