import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';

import '../bloc/home_cubit.dart';

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

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..init(),
      child: BlocBuilder<HomeCubit, BaseState<HomeModel>>(
        builder: (context, state) {
          final data = state.data ?? const HomeModel();

          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: _buildAppBar(),
            body: RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().fetchHomeData();
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
                    if (state.isLoading && !state.hasData)
                      const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      HomeBannerSlider(banners: data.banners),
                      const SizedBox(height: 32),
                      HomeSportCategories(
                        categories: data.categories,
                        onCategorySelected: (category) {
                          GoRouter.of(context).push(
                              '/venues?query=${Uri.encodeComponent(category.label)}');
                        },
                      ),
                      const SizedBox(height: 32),
                    HomeFeaturedVenues(
                      venues: data.featuredVenues,
                      onVenueTap: (venue) {
                        GoRouter.of(context).push('/venue-detail/${venue.id}');
                      },
                      onFavoriteTap: (venue) {
                        context.read<HomeCubit>().toggleFavorite(venue.id);
                      },
                      onViewAllTap: () {
                        GoRouter.of(context).push('/venues?query=featured');
                      },
                    ),
                    const SizedBox(height: 32),
                    HomeFeaturedVenues(
                      title: 'Sân mới nhất',
                      venues: data.recentVenues,
                      onVenueTap: (venue) {
                        GoRouter.of(context).push('/venue-detail/${venue.id}');
                      },
                      onFavoriteTap: (venue) {
                        context.read<HomeCubit>().toggleFavorite(venue.id);
                      },
                      onViewAllTap: () {
                        GoRouter.of(context).push('/venues');
                      },
                    ),
                      const SizedBox(height: 32),
                      HomeActivePromotions(
                        promotions: data.activePromotions,
                        onPromotionTap: (promotion) {
                          // View promotion details
                        },
                      ),
                    ],
                    const SizedBox(height: 48), // Bottom safe space
                  ],
                ),
              ),
            ),
          );
        },
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
