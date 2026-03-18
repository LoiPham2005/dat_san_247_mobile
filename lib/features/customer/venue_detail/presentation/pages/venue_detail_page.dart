import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';

import '../../data/models/venue_detail_model.dart';
import '../../data/models/court_model.dart';
import '../widgets/venue_gallery.dart';
import '../widgets/venue_info_card.dart';
import '../widgets/amenities_grid.dart';
import '../widgets/operating_hours_widget.dart';
import '../widgets/review_summary_widget.dart';
import '../widgets/court_list_tile.dart';

class VenueDetailPage extends StatefulWidget {
  final String slugOrId;

  const VenueDetailPage({super.key, required this.slugOrId});

  @override
  State<VenueDetailPage> createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  // This should ideally come from Cubit/State, mocking for UI preview
  VenueDetailModel? venue;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate fetching data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
          venue = _getDummyVenue();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryLightBrand)),
      );
    }

    if (venue == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: const Center(child: Text('Không tìm thấy sân')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondaryLightBrand, // Light grayish background for contrast
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Gallery Background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.backgroundLight,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.white70,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded, color: AppColors.destructiveLight, size: 22),
                ),
                onPressed: () {
                  // Toggle favorite
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: VenueGallery(
                mediaAttachments: venue!.mediaAttachments ?? [],
                fallbackThumbnail: venue!.thumbnailUrl,
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
                  color: AppColors.secondaryLightBrand,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Card
                      VenueInfoCard(venue: venue!),
                      const SizedBox(height: 24),

                      // Amenities Grid
                      if ((venue!.amenities ?? []).isNotEmpty) ...[
                        AmenitiesGrid(amenities: venue!.amenities!),
                        const SizedBox(height: 24),
                      ],

                      // Operating Hours
                      if ((venue!.operatingHours ?? []).isNotEmpty) ...[
                        OperatingHoursWidget(operatingHours: venue!.operatingHours!),
                        const SizedBox(height: 24),
                      ],

                      // Reviews Summary
                      if (venue!.totalReviews > 0) ...[
                        ReviewSummaryWidget(
                          venue: venue!, 
                          onViewAll: () {
                            // Navigate to full reviews
                          }
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Courts List
                      const Divider(color: AppColors.borderLight, height: 32),
                      const Row(
                        children: [
                          Icon(Icons.sports_tennis_rounded, color: AppColors.primaryLightBrand, size: 24),
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
                      if (venue!.courts != null && venue!.courts!.isNotEmpty)
                        ...venue!.courts!.map((court) => CourtListTile(
                          court: court,
                          onTapBooking: () {
                            TimeSlotPickerRoute(
                              courtId: court.id,
                              venueName: venue!.name,
                            ).push(context);
                          },
                        ))
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('Chưa có sân nào được thêm', style: TextStyle(color: AppColors.textSecondary)),
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

  // --- MOCK DATA FOR UI PREVIEW ---
  VenueDetailModel _getDummyVenue() {
    return VenueDetailModel(
      id: 'mock-123',
      ownerId: 'owner-1',
      name: 'Sân Bóng Đá Cỏ Nhân Tạo K34',
      slug: 'san-bong-da-k34',
      description: 'Sân bóng K34 cung cấp cụm 4 sân cỏ nhân tạo đạt chuẩn FIFA, hệ thống chiếu sáng LED hiện đại, mặt cỏ êm ái chống trơn trượt. Có canteen giải khát tiện lợi.',
      address: 'Số 10 Phạm Văn Đồng',
      city: 'Hà Nội',
      district: 'Cầu Giấy',
      ward: 'Mai Dịch',
      phone: '0987654321',
      fbUrl: 'https://facebook.com/k34',
      status: 'APPROVED',
      isActive: true,
      isFeatured: true,
      rating: 4.8,
      ratingCleanliness: 4.9,
      ratingFacilities: 4.7,
      ratingStaff: 4.8,
      totalReviews: 125,
      thumbnailUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbc09e99c?auto=format&fit=crop&q=80',
      amenities: [
        AmenityModel(id: 'a1', venueId: 'mock-123', name: 'WiFi miễn phí', isFree: true),
        AmenityModel(id: 'a2', venueId: 'mock-123', name: 'Bãi xe ô tô', isFree: true),
        AmenityModel(id: 'a3', venueId: 'mock-123', name: 'Phòng thay đồ', isFree: true),
        AmenityModel(id: 'a4', venueId: 'mock-123', name: 'Canteen', isFree: false),
        AmenityModel(id: 'a5', venueId: 'mock-123', name: 'Đèn chiếu sáng LED', isFree: true),
        AmenityModel(id: 'a6', venueId: 'mock-123', name: 'Camera an ninh', isFree: true),
      ],
      courts: [
        CourtModel(
          id: 'court-1',
          venueId: 'mock-123',
          name: 'Sân A - 5 người',
          description: 'Sân cỏ nhân tạo chuẩn FIFA, đèn LED 1200W',
          pricePerHour: 150000,
          surfaceType: CourtSurfaceType.artificialGrass,
          size: '25x45m',
          isIndoor: false,
          isActive: true,
          displayOrder: 1,
          thumbnailUrl: 'https://images.unsplash.com/photo-1553778263-73a83bab9b0c?q=80&w=400&auto=format&fit=crop',
        ),
        CourtModel(
          id: 'court-2',
          venueId: 'mock-123',
          name: 'Sân B - 7 người',
          description: 'Sân cỏ rộng hơn, phù hợp nhóm 7-8 người',
          pricePerHour: 200000,
          surfaceType: CourtSurfaceType.artificialGrass,
          size: '35x55m',
          isIndoor: false,
          isActive: true,
          displayOrder: 2,
          thumbnailUrl: null,
        ),
        CourtModel(
          id: 'court-3',
          venueId: 'mock-123',
          name: 'Sân C - Trong nhà',
          description: 'Sân trong nhà có điều hòa, phù hợp ngày mưa',
          pricePerHour: 250000,
          surfaceType: CourtSurfaceType.wood,
          size: '20x40m',
          isIndoor: true,
          isActive: true,
          displayOrder: 3,
          thumbnailUrl: null,
        ),
      ],
    );
  }
}
