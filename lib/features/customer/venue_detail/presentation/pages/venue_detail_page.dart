import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/data/models/venue_detail_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_detail/presentation/providers/venue_detail_notifier.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:dat_san_247_mobile/routes/config/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/amenities_grid.dart';
import '../widgets/court_list_tile.dart';
import '../widgets/operating_hours_widget.dart';
import '../widgets/review_summary_widget.dart';
import '../widgets/venue_gallery.dart';
import '../widgets/venue_info_card.dart';

class VenueDetailPage extends ConsumerWidget {
  final String slugOrId;

  const VenueDetailPage({super.key, required this.slugOrId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = venueDetailProvider(slugOrId);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    RiverpodListeners.async$(
      ref: ref,
      context: context,
      provider: provider,
      notifier: notifier,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: switch (state) {
        AsyncData(:final value) => _buildContent(context, notifier, value),
        AsyncError(:final error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.destructiveLight),
                const SizedBox(height: 16),
                Text('$error',
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: notifier.refresh,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        _ => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryLightBrand),
          ),
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    VenueDetailNotifier notifier,
    VenueDetailModel venue,
  ) {
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primaryLightBrand,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.backgroundLight,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: AppColors.white70, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.black, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.white70, shape: BoxShape.circle),
                  child: Icon(
                    venue.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: venue.isFavorite
                        ? AppColors.destructiveLight
                        : AppColors.textHint,
                    size: 22,
                  ),
                ),
                onPressed: () => notifier.toggleFavorite(venue.id),
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
          SliverToBoxAdapter(
            child: Transform.translate(
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
                      VenueInfoCard(venue: venue),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              VenueOverviewRoute(slugOrId: venue.slug).push(context),
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
                      if ((venue.amenities ?? []).isNotEmpty) ...[
                        AmenitiesGrid(amenities: venue.amenities!),
                        const SizedBox(height: 24),
                      ],
                      if ((venue.operatingHours ?? []).isNotEmpty) ...[
                        OperatingHoursWidget(operatingHours: venue.operatingHours!),
                        const SizedBox(height: 24),
                      ],
                      if (venue.totalReviews > 0) ...[
                        ReviewSummaryWidget(venue: venue, onViewAll: () {}),
                        const SizedBox(height: 24),
                      ],
                      const Divider(color: AppColors.borderLight, height: 32),
                      const Row(
                        children: [
                          Icon(Icons.sports_tennis_rounded,
                              color: AppColors.primaryLightBrand, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Danh sách sân',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (venue.courts != null && venue.courts!.isNotEmpty)
                        ...venue.courts!.map(
                          (court) => CourtListTile(
                            court: court,
                            onTapBooking: () =>
                                VenueOverviewRoute(slugOrId: venue.slug).push(context),
                          ),
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('Chưa có sân nào được thêm',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                      const SizedBox(height: 40),
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
