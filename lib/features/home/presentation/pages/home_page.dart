// // import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
// // import 'package:dat_san_247_mobile/core/widgets/custom_carousel.dart';
// // import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
// // import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
// // import 'package:dat_san_247_mobile/features/home/presentation/controller/banner_controller.dart';
// // import 'package:dat_san_247_mobile/features/home/presentation/pages/search_page.dart';
// // import 'package:dat_san_247_mobile/features/home/presentation/widgets/custom_appbar.dart';
// // import 'package:dat_san_247_mobile/features/home/presentation/widgets/grid_sport_category.dart';
// // import 'package:dat_san_247_mobile/features/home/presentation/widgets/custom_sliver_appbar.dart';
// // import 'package:dat_san_247_mobile/features/home/presentation/widgets/shimmer_carousel.dart';
// // import 'package:dat_san_247_mobile/features/venue/presentation/controller/venue_controller.dart';
// // import 'package:dat_san_247_mobile/features/venue/presentation/widget/list_venue.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
//
// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});
//
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
//
// // class _HomePageState extends State<HomePage> {
// //   // Inject controllers using GetX
// //   final BannerController _bannerController = Get.find<BannerController>();
// //   final sportCategoryController = Get.find<SportCategoryController>();
// //   final venueController = Get.find<VenueController>();
//
// //   final ScrollController _scrollController = ScrollController();
// //   bool _isCollapsed = false;
// //   bool _showScrollToTop = false;
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController.addListener(_scrollListener);
// //   }
//
// //   void _scrollListener() {
// //     if (_scrollController.hasClients) {
// //       // Kiểm tra ẩn/hiện search box
// //       if (_scrollController.offset > 80 && !_isCollapsed) {
// //         setState(() => _isCollapsed = true);
// //       } else if (_scrollController.offset <= 80 && _isCollapsed) {
// //         setState(() => _isCollapsed = false);
// //       }
//
// //       // Kiểm tra hiển thị nút scroll to top
// //       if (_scrollController.offset > 300 && !_showScrollToTop) {
// //         setState(() => _showScrollToTop = true);
// //       } else if (_scrollController.offset <= 300 && _showScrollToTop) {
// //         setState(() => _showScrollToTop = false);
// //       }
// //     }
// //   }
//
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBar(title: "Trang chủ"),
// //       body: CustomScrollView(
// //         controller: _scrollController,
// //         slivers: [
// //           // GỌI CUSTOM SLIVER APPBAR
// //           // CustomSliverAppBar(
// //           //   isCollapsed: _isCollapsed,
// //           //   onSearchTap: () {
// //           //     debugPrint("Icon tìm kiếm được bấm!");
// //           //     Get.to(
// //           //       () => SearchPage(),
// //           //       curve: Curves.easeInOut,
// //           //       transition: Transition.rightToLeft,
// //           //     );
// //           //   },
// //           // ),
//
// //           // ---------------- NỘI DUNG ----------------
// //           SliverToBoxAdapter(
// //             child: Column(
// //               children: [
// //                 10.height,
// //                 // CustomCarouselSlider(),
// //                 // Obx(() {
// //                 //   if (_bannerController.bannerList.isEmpty) {
// //                 //     return const ShimmerCarousel();
// //                 //   }
// //                 //   // Nếu có banner, hiển thị carousel
// //                 //   return CustomCarousel(
// //                 //     items: _bannerController.bannerList.map((banner) {
// //                 //       return ClipRRect(
// //                 //         borderRadius: BorderRadius.circular(10),
// //                 //         child: CustomImage(
// //                 //           imageUrl: banner.mediaUrl ?? '',
// //                 //           fit: BoxFit.cover,
// //                 //         ),
// //                 //       );
// //                 //     }).toList(),
// //                 //     aspectRatio: 340 / 207,
// //                 //     autoPlay: true,
// //                 //   );
// //                 // }),
// //                 // 20.height,
// //                 Obx(() {
// //                   if (sportCategoryController.listCategory.isEmpty) {
// //                     return const Padding(
// //                       padding: EdgeInsets.all(20),
// //                       child: Center(child: CircularProgressIndicator()),
// //                     );
// //                   }
// //                   return GridSportCategory(
// //                     categories: sportCategoryController.listCategory,
// //                   );
// //                 }).paddingOnly(left: 10),
// //                 10.height,
// //                 Obx(() {
// //                   if (venueController.listVenue.isEmpty) {
// //                     return const Padding(
// //                       padding: EdgeInsets.all(20),
// //                       child: Center(child: CircularProgressIndicator()),
// //                     );
// //                   }
// //                   return ListVenue(venues: venueController.listVenue);
// //                 }),
// //                 20.height,
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
//
// //       // NÚT SCROLL TO TOP
// //       floatingActionButton: _showScrollToTop
// //           ? FloatingActionButton(
// //               backgroundColor: Colors.amber,
// //               child: const Icon(Icons.arrow_upward, color: Colors.white),
// //               onPressed: () {
// //                 _scrollController.animateTo(
// //                   0,
// //                   duration: const Duration(milliseconds: 500),
// //                   curve: Curves.easeInOut,
// //                 );
// //               },
// //             )
// //           : null,
// //     );
// //   }
// // }
//
// import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
// import 'package:dat_san_247_mobile/core/widgets/carousel/custom_carousel.dart';
// import 'package:dat_san_247_mobile/core/widgets/image/custom_image.dart';
// import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/controller/banner_controller.dart';
// import 'package:dat_san_247_mobile/features/search_venue/presentation/pages/search_page.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/custom_appbar.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/custom_carousel_slider.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/grid_sport_category.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_venue_popular.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/title_list.dart';
// import 'package:dat_san_247_mobile/features/my_booking/presentation/controller/venue_controller.dart';
// import 'package:dat_san_247_mobile/features/home/presentation/widgets/list_venue.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final BannerController _bannerController = Get.find<BannerController>();
//   final sportCategoryController = Get.find<SportCategoryController>();
//   final venueController = Get.find<VenueController>();
//
//   final ScrollController _scrollController = ScrollController();
//   bool _showScrollToTop = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.offset > 300 && !_showScrollToTop) {
//         setState(() => _showScrollToTop = true);
//       } else if (_scrollController.offset <= 300 && _showScrollToTop) {
//         setState(() => _showScrollToTop = false);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       appBar: CustomAppBar(
//         title: "phamducloi",
//         avatarUrl:
//             "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => Future.wait([
//           _bannerController.getBanner(),
//           sportCategoryController.fetchCategories(),
//           venueController.getVenue(),
//         ]),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xff62b766).withOpacity(0.08),
//                 Colors.white,
//                 Color(0xff4fa553).withOpacity(0.04),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               physics: BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 10,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Banner/Carousel
//                     // Obx(() {
//                     //   if (_bannerController.bannerList.isEmpty) {
//                     //     return Container(
//                     //       height: 207,
//                     //       margin: EdgeInsets.symmetric(vertical: 12),
//                     //       decoration: BoxDecoration(
//                     //         color: Colors.white,
//                     //         borderRadius: BorderRadius.circular(16),
//                     //         boxShadow: [
//                     //           BoxShadow(
//                     //             color: Colors.black.withOpacity(0.07),
//                     //             blurRadius: 12,
//                     //             offset: Offset(0, 4),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //       child: Center(child: CircularProgressIndicator()),
//                     //     );
//                     //   }
//                     //   return CustomCarousel(
//                     //     items: _bannerController.bannerList.map((banner) {
//                     //       return ClipRRect(
//                     //         borderRadius: BorderRadius.circular(16),
//                     //         child: CustomImage(
//                     //           imageUrl: banner.mediaUrl ?? '',
//                     //           fit: BoxFit.cover,
//                     //         ),
//                     //       );
//                     //     }).toList(),
//                     //     // aspectRatio: 340 / 207,
//                     //     autoPlay: true,
//                     //   );
//                     // }),
//                     Row(
//                       children: [
//                         Container(
//                           width: 54,
//                           height: 54,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Color(0xff62b766), Color(0xff4fa553)],
//                             ),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(0xff62b766).withOpacity(0.18),
//                                 blurRadius: 12,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Icon(
//                             Icons.sports_soccer,
//                             color: Colors.white,
//                             size: 32,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Xin chào, phamducloi 👋",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff2d5533),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Khám phá sân thể thao gần bạn",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 24),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xff62b766).withOpacity(0.10),
//                             blurRadius: 12,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Tìm kiếm sân, địa điểm...",
//                           hintStyle: TextStyle(color: Colors.grey[500]),
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: Color(0xff62b766),
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 18,
//                             horizontal: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 28),
//                     CustomCarouselSlider(),
//                     SizedBox(height: 24),
//
//                     // Section: Popular Venues
//                     TitleList(title: "Sân nổi bật"),
//                     SizedBox(height: 10),
//                     Card(
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: ListVenuePopular().paddingSymmetric(vertical: 10),
//                     ),
//                     SizedBox(height: 24),
//
//                     // Section: Sport Categories
//                     TitleList(title: "Danh mục thể thao"),
//                     SizedBox(height: 10),
//                     Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         child: Obx(() {
//                           if (sportCategoryController.listCategory.isEmpty) {
//                             return Center(child: CircularProgressIndicator());
//                           }
//                           return GridSportCategory(
//                             categories: sportCategoryController.listCategory,
//                           );
//                         }),
//                       ),
//                     ),
//                     SizedBox(height: 24),
//
//                     // Section: Venue List
//                     TitleList(title: "Danh sách sân"),
//                     SizedBox(height: 10),
//                     Obx(() {
//                       if (venueController.listVenue.isEmpty) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       }
//                       return ListVenue(venues: venueController.listVenue);
//                     }),
//                     SizedBox(height: 24),
//
//                     // Quick action buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _buildQuickAction(
//                           icon: Icons.calendar_month,
//                           label: "Đặt sân nhanh",
//                           color: Color(0xff62b766),
//                           onTap: () {},
//                         ),
//                         _buildQuickAction(
//                           icon: Icons.favorite,
//                           label: "Yêu thích",
//                           color: Color(0xff4fa553),
//                           onTap: () {},
//                         ),
//                         _buildQuickAction(
//                           icon: Icons.map,
//                           label: "Bản đồ",
//                           color: Color(0xff2d5533),
//                           onTap: () {},
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: _showScrollToTop
//           ? FloatingActionButton(
//               backgroundColor: Color(0xff62b766),
//               child: const Icon(Icons.arrow_upward, color: Colors.white),
//               onPressed: () {
//                 _scrollController.animateTo(
//                   0,
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.easeInOutCubicEmphasized,
//                 );
//               },
//               shape: CircleBorder(),
//             )
//           : null,
//     );
//   }
//
//   Widget _buildQuickAction({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 54,
//             height: 54,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.18),
//                   blurRadius: 10,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: Colors.white, size: 28),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
