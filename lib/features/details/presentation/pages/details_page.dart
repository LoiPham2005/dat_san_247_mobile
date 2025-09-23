import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:dat_san_247_mobile/features/booking/presentation/pages/booking_page.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_action_buttons.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_amenities_card.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_error_screen.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_floating_button.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_header_card.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_loading_screen.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_owner_card.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_rules_card.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_sliver_app_bar.dart';
import 'package:dat_san_247_mobile/features/details/presentation/widgets/venue_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:dat_san_247_mobile/features/my_booking/data/models/venue.dart';
import 'package:dat_san_247_mobile/features/my_booking/presentation/controller/venue_controller.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:latlong2/latlong.dart';

class DetailsPage extends StatefulWidget {
  final int venueId;
  const DetailsPage({super.key, required this.venueId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with TickerProviderStateMixin {
  final VenueController venueController = Get.find<VenueController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Venue? venue;
  bool isLoading = true;
  int currentImage = 0;
  bool isFavorite = false;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchVenue();
  }

  @override
  void dispose() {
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

  Future<void> _fetchVenue() async {
    setState(() => isLoading = true);
    await venueController.getIdVenue(widget.venueId);
    if (venueController.listVenue.isNotEmpty) {
      setState(() {
        venue = venueController.listVenue.first;
        isLoading = false;
      });
      _animationController.forward();
    } else {
      setState(() => isLoading = false);
    }
  }

  List<String> get venueImages {
    if (venue?.images != null && venue!.images!.isNotEmpty) {
      return venue!.images!
          .map((e) => e.imageUrl ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }
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

    Get.to(
      () => BookingPage(
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
                    Color(0xff62b766).withOpacity(0.08),
                    Colors.white,
                    Color(0xff4fa553).withOpacity(0.04),
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
                              onCallPressed: _onCallPressed,
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
    return Column(
      children: [
        if (venue!.owner != null) VenueOwnerCard(owner: venue!.owner!),
        if (venue!.amenities != null && venue!.amenities!.isNotEmpty)
          VenueAmenitiesCard(amenities: venue!.amenities!),
        if (venue!.venueRules != null && venue!.venueRules!.isNotEmpty)
          VenueRulesCard(rules: venue!.venueRules!),
        // Thay thế GoogleMap bằng flutter_map (OpenStreetMap)
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
              controller: MapController(
                initPosition: GeoPoint(
                  latitude: 21.038132,
                  longitude: 105.770574,
                ),
              ),
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  minZoomLevel: 3,
                  maxZoomLevel: 18,
                  initZoom: 16,
                ),
              ),
              // markerOption: MarkerOption(
              //   defaultMarker: MarkerIcon(
              //     icon: Icon(Icons.location_on, color: Colors.red, size: 40),
              //   ),
              // ),
              mapIsLoading: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }
}
