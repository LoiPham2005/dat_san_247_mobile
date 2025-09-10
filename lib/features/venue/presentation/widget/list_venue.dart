// import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
// import 'package:dat_san_247_mobile/core/utils/extensions/widget_ext.dart';
// import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
// import 'package:dat_san_247_mobile/features/venue/data/models/venue.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class ListVenue extends StatelessWidget {
//   final List<Venue> venues;
//   const ListVenue({super.key, required this.venues});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.7,
//       ),
//       itemCount: venues.length,
//       itemBuilder: (context, index) {
//         final venue = venues[index];
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // CustomImage(imageUrl: venue.images?.first.imageUrl ?? ''),
//             CustomImage(
//               imageUrl: venue.images?.isNotEmpty == true
//                   ? venue.images!.last.imageUrl ?? ''
//                   : '',
//             ),

//             // Ảnh sân
//             // ClipRRect(
//             //   borderRadius: const BorderRadius.vertical(
//             //     top: Radius.circular(12),
//             //   ),
//             //   child: SizedBox(
//             //     height: 120,
//             //     width: double.infinity,
//             //     child: CustomImage(
//             //       imageUrl: venue.images?.isNotEmpty == true
//             //           ? venue.images!.first.imageUrl ?? ''
//             //           : '',
//             //     ),
//             //   ),
//             // ),
//             Text(venue.venueName ?? ''),
//             Text(venue.address ?? ''),
//           ],
//         );
//       },
//     ).paddingSymmetric(horizontal: 10);
//   }
// }

import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/core/utils/extensions/widget_ext.dart';
import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
import 'package:dat_san_247_mobile/features/venue/data/models/venue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListVenue extends StatelessWidget {
  final List<Venue> venues;
  const ListVenue({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // ✅ Tự động co theo nội dung
      physics: const NeverScrollableScrollPhysics(), // ✅ Không cuộn riêng
      itemCount: venues.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox.shrink();
      },
      itemBuilder: (context, index) {
        final venue = venues[index];
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
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          venue.averageRating ?? '0.0',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${venue.totalReviews ?? 0} đánh giá)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Amenities
                    if (venue.amenities != null && venue.amenities!.isNotEmpty)
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
                                backgroundColor: Colors.blue.withOpacity(0.1),
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
    ).paddingSymmetric(horizontal: 10);
  }
}
