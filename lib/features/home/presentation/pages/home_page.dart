import 'package:dat_san_247_mobile/core/ext/int_ext.dart';
import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/custom_carousel_slider.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/grid_sport_category.dart';
import 'package:dat_san_247_mobile/features/home/presentation/widgets/custom_sliver_appbar.dart';
import 'package:dat_san_247_mobile/features/venue/presentation/controller/venue_controller.dart';
import 'package:dat_san_247_mobile/features/venue/presentation/pages/venue_page.dart';
import 'package:dat_san_247_mobile/features/venue/presentation/widget/list_venue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Inject controllers using GetX
  final sportCategoryController = Get.find<SportCategoryController>();
  final venueController = Get.find<VenueController>();

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      // Kiểm tra ẩn/hiện search box
      if (_scrollController.offset > 80 && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= 80 && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }

      // Kiểm tra hiển thị nút scroll to top
      if (_scrollController.offset > 300 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 300 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // GỌI CUSTOM SLIVER APPBAR
          CustomSliverAppBar(
            isCollapsed: _isCollapsed,
            onSearchTap: () {
              debugPrint("Icon tìm kiếm được bấm!");
            },
          ),

          // ---------------- NỘI DUNG ----------------
          SliverToBoxAdapter(
            child: Column(
              children: [
                10.height,
                CustomCarouselSlider(),
                20.height,
                Obx(() {
                  if (sportCategoryController.listCategory.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return GridSportCategory(
                    categories: sportCategoryController.listCategory,
                  );
                }).paddingOnly(left: 10),
                10.height,
                Obx(() {
                  if (venueController.listVenue.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ListVenue(venues: venueController.listVenue);
                }),
                20.height,
              ],
            ),
          ),
        ],
      ),

      // NÚT SCROLL TO TOP
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              backgroundColor: Colors.amber,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            )
          : null,
    );
  }
}
