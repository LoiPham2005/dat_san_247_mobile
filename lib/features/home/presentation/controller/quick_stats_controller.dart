import 'package:dat_san_247_mobile/core/config/app/config_getx/base_controller.dart';
import 'package:dat_san_247_mobile/features/home/data/repository/quick_stats_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QuickStatsController extends BaseController  {
  final _totalVenues = 0.obs;
  final _totalBookingsToday = 0.obs;
  final _totalUsers = 0.obs;
  // final _isLoading = false.obs;

  int get totalVenues => _totalVenues.value;
  int get totalBookingsToday => _totalBookingsToday.value;
  int get totalUsers => _totalUsers.value;
  // bool get isLoading => _isLoading.value;

  QuickStatsService quickStatsService = QuickStatsService();

  // Future<void> fetchQuickStats() async {
  //   try {
  //     _isLoading.value = true;
  //     final stats = await QuickStatsService.getQuickStats();
      
  //     _totalVenues.value = stats['totalVenues'] ?? 0;
  //     _totalBookingsToday.value = stats['totalBookingsToday'] ?? 0;
  //     _totalUsers.value = stats['totalUsers'] ?? 0;
  //   } catch (e) {
  //     print('Error fetching quick stats: $e');
  //   } finally {
  //     _isLoading.value = false;
  //   }
  // }

    @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchQuickStats();
  }

  Future<void> fetchQuickStats() {
    // return fetchList(
    //   action: () => quickStatsService.getQuickStats(),
    //   targetList: bannerList,
    // );
    return performAction(action: () => quickStatsService.getQuickStats() ,
    onSuccess: (data) {
      _totalVenues.value = data.totalVenues;
      _totalBookingsToday.value = data.totalBookingsToday;
      _totalUsers.value = data.totalUsers;
    });
  }
}