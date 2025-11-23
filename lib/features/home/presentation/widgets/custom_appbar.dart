// import 'package:dat_san_247_mobile/core/styles/image_path.dart';
// import 'package:dat_san_247_mobile/features/search_venue/presentation/pages/search_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final String? avatarUrl;
//
//   const CustomAppBar({super.key, required this.title, this.avatarUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       // 👇 mở rộng không gian cho leading
//       leadingWidth: 180,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundImage: avatarUrl != null
//                   ? NetworkImage(avatarUrl!)
//                   : AssetImage(ImagePath.logoApp) as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search),
//           onPressed: () {
//             debugPrint("Icon tìm kiếm được bấm!");
//             Get.to(
//               () => SearchPage(),
//               curve: Curves.easeInOut,
//               transition: Transition.zoom,
//             );
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.favorite),
//           onPressed: () {
//             debugPrint("Icon yêu thích được bấm!");
//             // Get.to(
//             //   () => const HomePage2(),
//             //   curve: Curves.easeInOut,
//             //   transition: Transition.zoom,
//             // );
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.notifications),
//           onPressed: () {
//             debugPrint("Icon thông báo được bấm!");
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
