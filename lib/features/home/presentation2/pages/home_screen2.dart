import 'package:dat_san_247_mobile/features/category/presentation/controller/sport_category_controller.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/banner_carousel.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/featured_venues_section.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/nearby_venues_section.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/quick_action.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/quick_stats_section.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/search_section.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/sport_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/features/home/presentation2/widgets/home_app_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;
  final   _sportCategoryController = Get.find<SportCategoryController>();

  String _selectedLocation = "Hà Nội";
  double _scrollOffset = 0.0;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollController();
    _setSystemUIOverlay();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 300 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  void _setupScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff62b766).withOpacity(0.08),
                Colors.white,
                Color(0xff4fa553).withOpacity(0.04),
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  HomeAppBar(
                    theme: theme,
                    selectedLocation: _selectedLocation,
                    onLocationTap: _showLocationPicker,
                    onNotificationTap: _showNotifications,
                  ),

                  // Main content
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Search Bar
                        // _buildSearchSection(theme),
                        SearchSection(
                          onTap: () {
                            // Handle filter button tap
                          },
                        ),

                        // Quick Stats
                        const QuickStatsSection(),

                        // Banner Carousel
                        const BannerCarousel(),

                        // Sport Categories
                         Obx(() {
                          if(_sportCategoryController.listCategory.isEmpty){
                            
                          }
                           return SportCategories(sportCategory: _sportCategoryController.listCategory,);
                         }, ),

                        // Nearby Venues
                        const NearbyVenuesSection(),

                        // Featured Venues
                        const FeaturedVenuesSection(),

                        QuickAction(),

                        // Bottom spacing
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              backgroundColor: const Color(0xff62b766),
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 28,
              ), // Giảm size icon
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubicEmphasized,
                );
              },
              shape: const CircleBorder(),
              mini: true, // Thêm dòng này để thu nhỏ FAB
            )
          : null,
    );
  }

  void _showNotifications() {
    // TODO: Implement notifications
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bạn có 3 thông báo mới'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLocationPicker() {
    final locations = [
      'Hà Nội',
      'Hồ Chí Minh',
      'Đà Nẵng',
      'Hải Phòng',
      'Cần Thơ',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn thành phố',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...locations.map(
                    (location) => ListTile(
                      leading: Icon(
                        Icons.location_city,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(location),
                      trailing: _selectedLocation == location
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedLocation = location;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
