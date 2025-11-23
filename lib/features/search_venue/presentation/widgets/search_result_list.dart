import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/list_venue.dart';
import 'package:dat_san_247_mobile/features/my_booking/presentation/controller/venue_controller.dart';

class SearchResultList extends StatelessWidget {
  final String? selectedType;
  final String? selectedDistrict;
  final TextEditingController searchController;

  const SearchResultList({
    super.key,
    required this.selectedType,
    required this.selectedDistrict,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final venueController = Get.find<VenueController>();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Obx(() {
          final filteredVenues = venueController.listVenue
              .where((venue) {
                final matchesType = selectedType == null;
                final matchesDistrict = selectedDistrict == null;
                final matchesSearch = searchController.text.isEmpty ||
                    (venue.venueName ?? '')
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
                return matchesType && matchesDistrict && matchesSearch;
              })
              .toList();

          if (filteredVenues.isEmpty) {
            return Center(child: Text("Không có kết quả phù hợp"));
          }
          return ListVenue(venues: filteredVenues);
        }),
      ),
    );
  }
}