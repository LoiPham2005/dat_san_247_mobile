import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
import 'package:dat_san_247_mobile/features/venue/data/models/venue.dart';
import 'package:dat_san_247_mobile/features/venue/presentation/controller/venue_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VenuePage extends GetView<VenueController> {
  VenuePage({super.key});

  // 👉 Khởi tạo controller ở đây
  final VenueController venueController = Get.put(VenueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sân'),
        // backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.listVenue.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.listVenue.length,
          itemBuilder: (context, index) {
            final venue = controller.listVenue[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImage(
                    imageUrl: venue.images!.isNotEmpty
                        ? venue.images!.first.imageUrl ?? ''
                        : '',
                  ),

                  // Venue Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.venueName ?? 'Chưa có tên',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                venue.address ?? 'Chưa có địa chỉ',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Rating & Reviews
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              venue.averageRating ?? '0.0',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' (${venue.totalReviews ?? 0} đánh giá)',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Amenities
                        if (venue.amenities != null &&
                            venue.amenities!.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: venue.amenities!
                                .where((amenity) => amenity.available == true)
                                .map(
                                  (amenity) => Chip(
                                    label: Text(
                                      amenity.name ?? '',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: Colors.blue.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
