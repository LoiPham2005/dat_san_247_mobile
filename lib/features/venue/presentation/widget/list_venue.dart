import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:dat_san_247_mobile/core/ext/widget_ext.dart';
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomImage(imageUrl: venue.images?.first.imageUrl ?? ''),
            CustomImage(
              imageUrl: venue.images?.isNotEmpty == true
                  ? venue.images!.last.imageUrl ?? ''
                  : '',
            ),

            // Ảnh sân
            // ClipRRect(
            //   borderRadius: const BorderRadius.vertical(
            //     top: Radius.circular(12),
            //   ),
            //   child: SizedBox(
            //     height: 120,
            //     width: double.infinity,
            //     child: CustomImage(
            //       imageUrl: venue.images?.isNotEmpty == true
            //           ? venue.images!.first.imageUrl ?? ''
            //           : '',
            //     ),
            //   ),
            // ),
            Text(venue.venueName ?? ''),
            Text(venue.address ?? ''),
          ],
        );
      },
    ).paddingSymmetric(horizontal: 10);
  }
}

// class ListVenue extends StatelessWidget {
//   final List<Venue> venues;
//   const ListVenue({super.key, required this.venues});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true, // Để tránh lỗi vô hạn chiều cao
//       physics:
//           const NeverScrollableScrollPhysics(), // Vì nằm trong CustomScrollView
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2, // Mỗi hàng có 2 item
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.7, // Cân chỉnh ảnh + text
//       ),
//       itemCount: venues.length,
//       itemBuilder: (context, index) {
//         final venue = venues[index];
//         return GestureDetector(
//           onTap: () {
//             // TODO: Điều hướng sang VenuePage nếu cần
//             // Get.to(() => VenuePage(venue: venue));
//           },
//           child: Card(
//             // elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Ảnh sân
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(12),
//                   ),
//                   child: SizedBox(
//                     height: 120,
//                     width: double.infinity,
//                     child: CustomImage(
//                       imageUrl: venue.images?.isNotEmpty == true
//                           ? venue.images!.first.imageUrl ?? ''
//                           : '',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Tên sân
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     venue.venueName ?? 'Tên sân',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),

//                 // Địa chỉ sân
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Text(
//                     venue.address ?? 'Địa chỉ',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ),
//                 const SizedBox(height: 4),

//                 // Đánh giá trung bình
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.star, size: 14, color: Colors.amber),
//                       const SizedBox(width: 4),
//                       Text(
//                         venue.averageRating ?? '0.0',
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
