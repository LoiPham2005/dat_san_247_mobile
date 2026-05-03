import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_detail_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/cubit/venue_detail_cubit.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:dat_san_247_mobile/routes/config/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/amenities_grid.dart';
import '../widgets/court_list_tile.dart';
import '../widgets/operating_hours_widget.dart';
import '../widgets/review_summary_widget.dart';
import '../widgets/venue_gallery.dart';
import '../widgets/venue_info_card.dart';

class VenueDetailPage extends StatelessWidget {
  final String slugOrId;

  const VenueDetailPage({super.key, required this.slugOrId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VenueDetailCubit>()..fetchVenueDetail(slugOrId),
      child: const _VenueDetailView(),
    );
  }
}

class _VenueDetailView extends StatelessWidget {
  const _VenueDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenueDetailCubit, BaseState<VenueDetailModel>>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: state.whenReady(
            loading: (data) => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryLightBrand),
            ),
            success: (venue, message) => _buildContent(context, venue),
            failure: (error, data) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.destructiveLight),
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final slugOrId = (context.findAncestorWidgetOfExactType<VenueDetailPage>())?.slugOrId;
                      if (slugOrId != null) {
                        context.read<VenueDetailCubit>().fetchVenueDetail(slugOrId);
                      }
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            empty: (message) => const Center(child: Text('Không có dữ liệu')),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, VenueDetailModel venue) {
    return RefreshIndicator(
      onRefresh: () => context.read<VenueDetailCubit>().fetchVenueDetail(venue.slug),
      color: AppColors.primaryLightBrand,
      child: CustomScrollView(
        slivers: [
          // 1. App Bar with Gallery Background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.backgroundLight,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.white70, shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.black,
                  size: 20,
                ),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.white70, shape: BoxShape.circle),
                  child: Icon(
                    venue.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: venue.isFavorite ? AppColors.destructiveLight : AppColors.textHint,
                    size: 22,
                  ),
                ),
                onPressed: () {
                  context.read<VenueDetailCubit>().toggleFavorite(venue.id);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: VenueGallery(
                mediaAttachments: venue.mediaAttachments ?? [],
                fallbackThumbnail: venue.thumbnailUrl,
              ),
            ),
          ),

          // 2. Content Body
          SliverToBoxAdapter(
            child: Transform.translate(
              // Move content slightly up to overlap the image
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Card
                      VenueInfoCard(venue: venue),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                             VenueOverviewRoute(slugOrId: venue.slug).push(context);
                          },
                          icon: const Icon(Icons.grid_on_outlined),
                          label: const Text('Xem lịch trống bao quát'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryLightBrand,
                            side: const BorderSide(color: AppColors.primaryLightBrand),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (venue.latitude != null && venue.longitude != null) {
                              final resultModel = VenueSearchResultModel(
                                id: venue.id,
                                name: venue.name,
                                slug: venue.slug,
                                address: venue.address,
                                city: venue.city,
                                district: venue.district,
                                thumbnailUrl: venue.thumbnailUrl,
                                rating: venue.rating,
                                totalReviews: venue.totalReviews,
                                latitude: venue.latitude,
                                longitude: venue.longitude,
                                sportTypes: const [],
                                amenities: const [],
                                isFeatured: venue.isFeatured,
                                isFavorite: false,
                              );
                              context.push(RouteNames.venueMap, extra: [resultModel]);
                            }
                          },
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('Xem trên bản đồ'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryLightBrand,
                            side: const BorderSide(color: AppColors.primaryLightBrand),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Amenities Grid
                      if ((venue.amenities ?? []).isNotEmpty) ...[
                        AmenitiesGrid(amenities: venue.amenities!),
                        const SizedBox(height: 24),
                      ],

                      // Operating Hours
                      if ((venue.operatingHours ?? []).isNotEmpty) ...[
                        OperatingHoursWidget(operatingHours: venue.operatingHours!),
                        const SizedBox(height: 24),
                      ],

                      // Reviews Summary
                      if (venue.totalReviews > 0) ...[
                        ReviewSummaryWidget(
                          venue: venue,
                          onViewAll: () {
                            // Navigate to full reviews
                          },
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Courts List
                      const Divider(color: AppColors.borderLight, height: 32),
                      const Row(
                        children: [
                          Icon(
                            Icons.sports_tennis_rounded,
                            color: AppColors.primaryLightBrand,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Danh sách sân',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (venue.courts != null && venue.courts!.isNotEmpty)
                        ...venue.courts!.map(
                          (court) => CourtListTile(
                            court: court,
                            onTapBooking: () {
                              VenueOverviewRoute(slugOrId: venue.slug)
                                  .push(context);
                            },
                          ),
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              'Chưa có sân nào được thêm',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),

                      const SizedBox(height: 40), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
