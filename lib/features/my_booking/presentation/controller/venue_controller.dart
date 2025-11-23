// import 'package:dat_san_247_mobile/features/home/presentation2/widgets/nearby_venues_section.dart';
// import 'package:dat_san_247_mobile/features/my_booking/data/models/venue.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:dat_san_247_mobile/core/config/app/config_getx/base_controller.dart';
// import 'package:dat_san_247_mobile/features/my_booking/data/repository/venue_repository.dart';
//
// class VenueController extends BaseController {
//   final VenueRepository repo = Get.find<VenueRepository>();
//   final RxList<VenueCardItem> nearbyVenues = <VenueCardItem>[].obs;
// final RxBool isLoadingNearby = false.obs;
//
//   // RxList lưu venue
//   RxList<Venue> listVenue = <Venue>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getVenue();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//     listVenue.clear();
//   }
//
//   Future<void> getVenue() {
//     return performAction(action: () => repo.getVenue(), targetList: listVenue);
//   }
//
//   Future<void> getIdVenue(int venueId) {
//     return performAction(
//       action: () => repo.getIdVenue(venueId),
//       targetList: listVenue,
//     );
//   }
//
//   Future<void> getNearbyVenues() async {
//     try {
//       isLoadingNearby.value = true;
//       // TODO: Get actual location
//       const lat = 21.0285;
//       const lng = 105.8542;
//
//       final venues = await repo.getNearbyVenues(
//         lat: lat,
//         lng: lng,
//         radius: 5,
//       );
//
//       nearbyVenues.value = venues;
//     } catch (e) {
//       print('Error getting nearby venues: $e');
//     } finally {
//       isLoadingNearby.value = false;
//     }
//
//     // return performAction(
//     //   action: () => repo.getNearbyVenues(
//     //             lat: lat,
//     //     lng: lng,
//     //     radius: 5,
//     //   ),
//     //   targetList: nearbyVenues,
//     // );
//   }
// }
