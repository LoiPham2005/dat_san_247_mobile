import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/banner_model.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/sport_category_model.dart';
import 'package:dat_san_247_mobile/features/shared/promotion/data/models/promotion_model.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';

import '../widgets/home_active_promotions.dart';
import '../widgets/home_banner_slider.dart';
import '../widgets/home_featured_venues.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_sport_categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- MOCK DATA FOR UI ---
  final List<BannerModel> _mockBanners = [
    const BannerModel(
      id: '1',
      title: 'Khai trương sân mới',
      mobileImageUrl:
          'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=600&auto=format&fit=crop',
    ),
    const BannerModel(
        id: '2',
        title: 'Giảm giá 50% cuối tuần',
        mobileImageUrl:
            'https://free.vector6.com/wp-content/uploads/2020/06/T6-U20-oe03ck-Vector-The-Thao-011.jpg'),
    const BannerModel(
        id: '3',
        title: 'Giảm giá 50% cuối tuần',
        mobileImageUrl:
            'https://free.vector6.com/wp-content/uploads/2020/06/T6-U20-oe03ck-Vector-The-Thao-011.jpg'),
  ];

  final List<SportCategoryModel> _mockCategories = const [
    SportCategoryModel(id: '1', name: 'FOOTBALL', label: 'Bóng đá', icon: 'football'),
    SportCategoryModel(id: '2', name: 'BADMINTON', label: 'Cầu lông', icon: 'badminton'),
    SportCategoryModel(id: '3', name: 'TENNIS', label: 'Tennis', icon: 'tennis'),
    SportCategoryModel(id: '4', name: 'BASKETBALL', label: 'Bóng rổ', icon: 'basketball'),
    SportCategoryModel(id: '5', name: 'SWIMMING', label: 'Bơi lội', icon: 'swimming'),
  ];

  final List<VenueModel> _mockVenues = [
    const VenueModel(
      id: '1',
      ownerId: 'owner1',
      name: 'Sân bóng đá KTX Bách Khoa',
      slug: 'san-bong-da-ktx-bach-khoa',
      address: '497 Hòa Hảo',
      district: 'Quận 10',
      city: 'TP.HCM',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1516422453390-1c395fb8260f?q=80&w=400&auto=format&fit=crop',
      isFeatured: true,
      rating: 4.8,
      totalReviews: 120,
    ),
    const VenueModel(
      id: '2',
      ownerId: 'owner2',
      name: 'Sân cầu lông Kỳ Hòa',
      slug: 'san-cau-long-ky-hoa',
      address: '16A Lê Hồng Phong',
      district: 'Quận 10',
      city: 'TP.HCM',
      thumbnailUrl: null,
      isFeatured: true,
      rating: 4.5,
      totalReviews: 85,
    ),
  ];

  final List<PromotionModel> _mockPromotions = [
    PromotionModel(
      id: '1',
      code: 'NEWUSER50',
      name: 'Giảm 50K cho bạn mới',
      discountType: PromotionDiscountType.FIXED_AMOUNT,
      discountValue: 50000,
      validFrom: DateTime.now().subtract(const Duration(days: 1)),
      validTo: DateTime.now().add(const Duration(days: 30)),
    ),
    PromotionModel(
      id: '2',
      code: 'WEEKEND20',
      name: 'Giảm giá 20% cuối tuần',
      discountType: PromotionDiscountType.PERCENTAGE,
      discountValue: 20,
      validFrom: DateTime.now(),
      validTo: DateTime.now().add(const Duration(days: 7)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh Data via CUBIT calls
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.primaryLightBrand,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSearchBar(
                onTap: () {
                  GoRouter.of(context).push('/venue-search');
                },
              ),
              const SizedBox(height: 16),
              HomeBannerSlider(banners: _mockBanners),
              const SizedBox(height: 32),
              HomeSportCategories(
                categories: _mockCategories,
                onCategorySelected: (category) {
                  GoRouter.of(context).push('/venues?query=${Uri.encodeComponent(category.name)}');
                },
              ),
              const SizedBox(height: 32),
              HomeFeaturedVenues(
                venues: _mockVenues,
                onVenueTap: (venue) {
                  GoRouter.of(context).push('/venue-detail/${venue.id}');
                },
                onViewAllTap: () {
                  GoRouter.of(context).push('/venues?query=featured');
                },
              ),
              const SizedBox(height: 32),
              HomeActivePromotions(
                promotions: _mockPromotions,
                onPromotionTap: (promotion) {
                  // View promotion details
                },
              ),
              const SizedBox(height: 48), // Bottom safe space
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading:
          context.canPop() && context.findAncestorWidgetOfExactType<MainShellPage>() == null,
      backgroundColor: AppColors.primaryLightBrand,
      elevation: 0,
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xin chào, Khách!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 16, color: AppColors.white),
              const SizedBox(width: 4),
              const Text(
                'TP. Hồ Chí Minh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: AppColors.white.withOpacity(0.7)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.white),
          onPressed: () {
            // View notifications
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
