// import 'package:dat_san_247_mobile/core/styles/color_app.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nb_utils/nb_utils.dart';


// class BgScreen extends StatelessWidget {
//   const BgScreen({
//     super.key,
//     required this.title, this.onBack, required this.body, this.bottomNavigationBar, this.backgroundColor, this.appBar,
//   });

//   final String title;
//   final void Function()? onBack;
//   final Widget body;
//   final Widget? bottomNavigationBar;
//   final Color? backgroundColor;
//   final Widget? appBar;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       onVerticalDragStart:  (_) {
//         FocusScope.of(context).unfocus();
//       },
//       onVerticalDragDown:  (_) {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         extendBody: true,
//         backgroundColor: backgroundColor,
//         body: Column(
//           children: [
//             HomeHeaderBackground2(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Navigator.canPop(context)  ?  IconButton(
//                       icon: const Icon(Icons.arrow_back,
//                           color: ColorApp.primaryColor, size: 35),
//                       onPressed: () {
//                         if(onBack != null) {
//                           onBack!();
//                         } else {
//                           Navigator.pop(context);
//                           FocusScope.of(context).unfocus();
//                         }
//                       },
//                     ).paddingOnly(left: 5) : const SizedBox(width: 55, height: 55,),
//                     Center(
//                       child: appBar ?? Text(
//                         title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: ColorApp.primaryColor,
//                         ),
//                       ),
//                     ).expand(),
//                     if (appBar == null) Container(width: 55),
//                   ],
//                 ),
//               ),
//             ),
//             body.expand(),
//           ],
//         ),
//         bottomNavigationBar: bottomNavigationBar,
//       ),
//     );
//   }
// }
