// import 'package:flutter/material.dart';
//
// class TitleList extends StatelessWidget {
//   final String title;
//   final VoidCallback? onSeeAll;
//   const TitleList({super.key, required this.title, this.onSeeAll});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Color(0xff2d5533),
//             letterSpacing: 0.2,
//           ),
//         ),
//         InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: onSeeAll,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff62b766), Color(0xff4fa553)],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0xff62b766).withOpacity(0.12),
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: const Text(
//               "Xem tất cả",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//                 letterSpacing: 0.2,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
