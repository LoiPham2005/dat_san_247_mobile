import 'package:dat_san_247_mobile/features/venue/data/models/venue.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:dat_san_247_mobile/core/config/app/config_getx/base_controller.dart';
import 'package:dat_san_247_mobile/features/venue/data/repository/venue_repository.dart';

class VenueController extends BaseController {
  final VenueRepository repo = Get.find<VenueRepository>();

  // RxList lưu venue
  RxList<Venue> listVenue = <Venue>[].obs;

  @override
  void onInit() {
    super.onInit();
    getVenue();
  }

  @override
  void onClose() {
    super.onClose();
    listVenue.clear();
  }

  Future<void> getVenue() {
    // return fetchList(
    //   action: () => repo.getVenue(),
    //   targetList: listVenue
    //   );
    return performAction(action: () => repo.getVenue(), targetList: listVenue);
  }
}
