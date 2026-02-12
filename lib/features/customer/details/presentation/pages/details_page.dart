import 'package:dat_san_247_mobile/core/extensions/context_extensions.dart';
import 'package:dat_san_247_mobile/core/extensions/number_extensions.dart';
import 'package:dat_san_247_mobile/features/auth/data/models/auth_model.dart';
import 'package:dat_san_247_mobile/features/customer/details/presentation/widgets/venue_rules_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;

import '../../../booking/presentation/pages/booking_page.dart';
import '../../../my_booking/data/models/amenities.dart';
import '../../../my_booking/data/models/venue.dart';
import '../../../my_booking/data/models/venue_images.dart';
import '../../../my_booking/data/models/venue_rules.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/venue_action_buttons.dart';
import '../widgets/venue_amenities_card.dart';
import '../widgets/venue_error_screen.dart';
import '../widgets/venue_floating_button.dart';
import '../widgets/venue_header_card.dart';
import '../widgets/venue_loading_screen.dart';
import '../widgets/venue_owner_card.dart';
import '../widgets/venue_sliver_app_bar.dart';
import '../widgets/venue_stats_row.dart';

class DetailsPage extends StatefulWidget {
  final int venueId;
  const DetailsPage({super.key, required this.venueId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  // final VenueController venueController = Get.find<VenueController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Venue? venue;
  bool isLoading = true;
  int currentImage = 0;
  bool isFavorite = false;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // Thêm biến MapController
  late MapController mapController;
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _initializeAnimations();
    _fetchVenue();
  }

  void _initializeMap() {
    mapController = MapController(
      initPosition: GeoPoint(latitude: 21.038132, longitude: 105.770574),
    );
  }

  @override
  void dispose() {
    // Đảm bảo map đã ready trước khi dispose
    if (isMapReady) {
      mapController.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  // Future<void> _fetchVenue() async {
  //   setState(() => isLoading = true);
  //   await venueController.getIdVenue(widget.venueId);
  //   if (venueController.listVenue.isNotEmpty) {
  //     setState(() {
  //       venue = venueController.listVenue.first;
  //       isLoading = false;
  //     });
  //     _animationController.forward();
  //   } else {
  //     setState(() => isLoading = false);
  //   }
  // }

  Future<void> _fetchVenue() async {
    setState(() => isLoading = true);

    // Giả lập delay network
    await Future.delayed(const Duration(milliseconds: 800));

    final mockVenue = Venue(
      venueId: widget.venueId,
      venueName: "Sân Bóng Đá Mini Thành Phát",
      description:
          "Sân bóng đá mini 5-7 người với cỏ nhân tạo chất lượng cao, hệ thống chiếu sáng hiện đại và các tiện ích đầy đủ.",
      address: "123 Lê Văn Lương, Thanh Xuân, Hà Nội",
      latitude: "21.038132",
      longitude: "105.770574",
      phone: "0123456789",
      email: "thanhphat@gmail.com",
      categoryId: 1,
      capacity: 14,
      status: "active",
      averageRating: "4.5",
      totalReviews: 128,
      totalBookings: 450,
      images: [
        VenueImages(
          imageUrl:
              "https://www.sporta.vn/wp-content/uploads/2019/09/san-bong-da-mini-co-nhan-tao-5.jpg",
        ),
        VenueImages(
          imageUrl:
              "https://www.sporta.vn/wp-content/uploads/2019/09/san-bong-da-mini-co-nhan-tao-1.jpg",
        ),
        VenueImages(
          imageUrl:
              "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
        ),
      ],
      amenities: [
        Amenities(name: "Wifi miễn phí", available: true),
        Amenities(name: "Bãi đỗ xe", available: true),
        Amenities(name: "Phòng thay đồ", available: true),
        Amenities(name: "Cho thuê giày", available: true),
        Amenities(name: "Nước uống", available: true),
      ],
      venueRules: [
        VenueRules(rule: "Không hút thuốc trong khuôn viên sân"),
        VenueRules(rule: "Đặt cọc 30% giá trị khi đặt sân"),
        VenueRules(rule: "Được phép huỷ trước 24h"),
      ],
      // owner: UserModel(
      //   id: 1,
      //   fullname: "Nguyễn Văn A",
      //   username: "nguyenvana",
      //   email: "nguyenvana@gmail.com",
      //   phone: "0987654321",
      //   gender: "male",
      //   birthDate: DateTime(1990, 5, 20),
      //   avatar: "https://i.pravatar.cc/150?img=11",
      //   roleId: 2,
      //   isVerified: true,
      //   address: "123 Lê Văn Lương, Hà Nội",
      //   latitude: 21.038132,
      //   longitude: 105.770574,
      //   isActive: true,
      //   specialStatus: "VIP",
      //   emailVerified: true,
      //   phoneVerified: true,
      //   provider: "local",
      //   providerId: "provider_001",
      //   createdAt: DateTime(2023, 3, 15),
      //   updatedAt: DateTime(2024, 6, 12),
      //   deletedAt: null,
      // ),
    );

    setState(() {
      venue = mockVenue;
      isLoading = false;
    });
    _animationController.forward();
  }

  List<String> get venueImages {
    // if (venue?.images != null && venue!.images!.isNotEmpty) {
    //   return venue!.images!
    //       .map((e) => e.imageUrl ?? '')
    //       .where((url) => url.isNotEmpty)
    //       .toList();
    // }
    return ["https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg"];
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
  }

  void _updateCurrentImage(int index) {
    setState(() => currentImage = index);
  }

  void _onBookingPressed() {
    // TODO: Navigate to booking page
    print('Navigate to booking page for venue: ${venue?.venueName}');

    // Get.to(
    //   () => BookingPage(
    //     venueId: venue!.venueId!,
    //     venueName: venue!.venueName ?? "Sân thể thao",
    //     venueAddress: venue!.address ?? "Địa chỉ không xác định",
    //     venueImage: venue!.images?.isNotEmpty == true
    //         ? venue!.images!.first.imageUrl
    //         : null,
    //     pricePerHour: 150000, // Replace with actual price
    //   ),
    // );

    context.navPush(
      BookingPage(
        venueId: venue!.venueId!,
        venueName: venue!.venueName ?? "Sân thể thao",
        venueAddress: venue!.address ?? "Địa chỉ không xác định",
        venueImage: venue!.images?.isNotEmpty == true
            ? venue!.images!.first.imageUrl
            : null,
        pricePerHour: 150000, // Replace with actual price
      ),
    );
  }

  void _onCallPressed() {
    // TODO: Implement call functionality
    print('Call venue: ${venue?.phone}');
  }

  void _onDirectionsPressed() {
    // TODO: Implement directions
    print('Get directions to: ${venue?.address}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? const VenueLoadingScreen()
          : venue == null
          ? const VenueErrorScreen()
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xff62b766).withOpacity(0.08),
                    Colors.white,
                    const Color(0xff4fa553).withOpacity(0.04),
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  VenueSliverAppBar(
                    venue: venue!,
                    venueImages: venueImages,
                    currentImage: currentImage,
                    isFavorite: isFavorite,
                    carouselController: _carouselController,
                    onImageChanged: _updateCurrentImage,
                    onFavoriteToggle: _toggleFavorite,
                    colorScheme: colorScheme,
                    size: size,
                  ),
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            50.height,
                            VenueHeaderCard(venue: venue!),
                            VenueStatsRow(venue: venue!),
                            _buildInfoCards(),
                            VenueActionButtons(
                              // onCallPressed: _onCallPressed,
                              phone: "0123456789",
                              email: "sdgsgdfgs",
                              message: "dsgfgx",
                              onDirectionsPressed: _onDirectionsPressed,
                              colorScheme: colorScheme,
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: venue != null
          ? VenueFloatingButton(
              onPressed: _onBookingPressed,
              colorScheme: colorScheme,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoCards() {
    if (venue == null) return const SizedBox.shrink();

    return Column(
      children: [
        if (venue?.owner != null) VenueOwnerCard(owner: venue!.owner!),
        if (venue?.amenities != null && venue!.amenities!.isNotEmpty)
          VenueAmenitiesCard(amenities: venue!.amenities!),
        if (venue?.venueRules != null && venue!.venueRules!.isNotEmpty)
          VenueRulesCard(rules: venue!.venueRules!),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: OSMFlutter(
              controller: mapController,
              osmOption: const OSMOption(
                zoomOption: ZoomOption(
                  minZoomLevel: 3,
                  maxZoomLevel: 18,
                  initZoom: 16,
                ),
              ),
              mapIsLoading: const Center(child: CircularProgressIndicator()),
              onMapIsReady: (ready) {
                if (ready) {
                  setState(() => isMapReady = true);
                  // if (venue?.latitude != null && venue?.longitude != null) {
                  //   mapController.changeLocation(
                  //     GeoPoint(
                  //       latitude: venue!.latitude!,
                  //       longitude: venue!.longitude!,
                  //     ),
                  //   );
                  // }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
