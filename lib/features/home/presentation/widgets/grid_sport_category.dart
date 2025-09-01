// import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
// import 'package:dat_san_247_mobile/core/widget/custom_image.dart';
// import 'package:dat_san_247_mobile/core/widget/toast/loading_overlay.dart';
// import 'package:dat_san_247_mobile/features/category/data/model/sport_category.dart';
// import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get/utils.dart';
// import 'package:shimmer/shimmer.dart';

// class GridSportCategory extends StatelessWidget {
//   final List<SportCategory> categories;
//   GridSportCategory({super.key, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150,
//       width: double.infinity,
//       child: GridView.builder(
//         shrinkWrap: true,
//         // physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8,
//           mainAxisSpacing: 8,
//         ),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final data = categories[index];
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomImage(
//                   imageUrl: data.iconUrl ?? '',
//                   height: 30,
//                   width: 30,
//                 ),
//                 10.height,
//                 Text(data.categoryName ?? '', style: TextStyle(fontSize: 10)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
import 'package:dat_san_247_mobile/core/widgets/toast/loading_overlay.dart';
import 'package:dat_san_247_mobile/features/category/data/model/sport_category.dart';
import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:shimmer/shimmer.dart';

class GridSportCategory extends StatelessWidget {
  final List<SportCategory> categories;
  GridSportCategory({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: MasonryGridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = categories[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(
                  imageUrl: data.iconUrl ?? '',
                  height: 30,
                  width: 30,
                ),
                8.height,
                Flexible(
                  child: Text(
                    data.categoryName ?? '',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
