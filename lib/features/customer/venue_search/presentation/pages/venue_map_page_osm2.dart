// import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
// import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
// import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // VenueMapPage — flutter_osm_plugin ^1.4.3
// //
// // API quan trọng:
// //   • OSMFlutter         — widget bản đồ
// //   • MapController.withPosition — khởi tạo với toạ độ cố định
// //   • OSMMixinObserver   — lắng nghe sự kiện map (mapIsReady, v.v.)
// //   • addMarker / removeMarkers / moveToGeoPoint / setZoom
// //   • drawRoad           — vẽ đường đi từ A → B
// //   • currentLocation    — nhảy về vị trí GPS người dùng
// // ─────────────────────────────────────────────────────────────────────────────

// class VenueMapPage extends StatefulWidget {
//   final List<VenueSearchResultModel> venues;
//   final double? initialLat;
//   final double? initialLng;
//   final double? initialZoom;

//   const VenueMapPage({
//     super.key,
//     this.venues = const [],
//     this.initialLat,
//     this.initialLng,
//     this.initialZoom,
//   });

//   // ── Mock data (dùng khi venues rỗng) ────────────────────────────────────
//   static const List<VenueSearchResultModel> mockVenues = [
//     VenueSearchResultModel(
//       id: '1',
//       name: 'Sân Bóng Đá Cầu Giấy',
//       slug: 'san-bong-da-cau-giay',
//       address: '12 Trần Thái Tông, Cầu Giấy',
//       city: 'Hà Nội',
//       district: 'Cầu Giấy',
//       rating: 4.8,
//       totalReviews: 120,
//       minPricePerHour: 300000,
//       sportTypes: ['Bóng đá'],
//       latitude: 21.0285,
//       longitude: 105.8542,
//       thumbnailUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=400',
//     ),
//     VenueSearchResultModel(
//       id: '2',
//       name: 'Sân Cầu Lông StarSport',
//       slug: 'san-cau-long-starsport',
//       address: '45 Xuân Thủy, Cầu Giấy',
//       city: 'Hà Nội',
//       district: 'Cầu Giấy',
//       rating: 4.5,
//       totalReviews: 85,
//       minPricePerHour: 120000,
//       sportTypes: ['Cầu lông'],
//       latitude: 21.0310,
//       longitude: 105.8490,
//       thumbnailUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400',
//     ),
//     VenueSearchResultModel(
//       id: '3',
//       name: 'Sân Pickleball Mỹ Đình',
//       slug: 'san-pickleball-my-dinh',
//       address: '3 Lê Đức Thọ, Nam Từ Liêm',
//       city: 'Hà Nội',
//       district: 'Nam Từ Liêm',
//       rating: 4.9,
//       totalReviews: 200,
//       minPricePerHour: 200000,
//       sportTypes: ['Pickleball'],
//       latitude: 21.0220,
//       longitude: 105.7630,
//       thumbnailUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400',
//     ),
//     VenueSearchResultModel(
//       id: '4',
//       name: 'Sân Tennis Hồ Tây',
//       slug: 'san-tennis-ho-tay',
//       address: '18 Nguyễn Đình Thi, Tây Hồ',
//       city: 'Hà Nội',
//       district: 'Tây Hồ',
//       rating: 4.6,
//       totalReviews: 150,
//       minPricePerHour: 250000,
//       sportTypes: ['Tennis'],
//       latitude: 21.0620,
//       longitude: 105.8310,
//       thumbnailUrl: 'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=400',
//     ),
//     VenueSearchResultModel(
//       id: '5',
//       name: 'Arena Basketball Đống Đa',
//       slug: 'arena-basketball-dong-da',
//       address: '67 Nguyễn Lương Bằng, Đống Đa',
//       city: 'Hà Nội',
//       district: 'Đống Đa',
//       rating: 4.3,
//       totalReviews: 95,
//       minPricePerHour: 180000,
//       sportTypes: ['Bóng rổ'],
//       latitude: 21.0168,
//       longitude: 105.8420,
//       thumbnailUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
//     ),
//   ];

//   @override
//   State<VenueMapPage> createState() => _VenueMapPageState();
// }

// class _VenueMapPageState extends State<VenueMapPage> with OSMMixinObserver {
//   // ── Controllers ───────────────────────────────────────────────────────────
//   late final MapController _mapController;
//   final DraggableScrollableController _sheetController = DraggableScrollableController();
//   final NumberFormat _priceFmt = NumberFormat('#,###', 'vi_VN');

//   // ── State ─────────────────────────────────────────────────────────────────
//   VenueSearchResultModel? _selectedVenue;
//   String _selectedSport = 'Tất cả';
//   bool _mapReady = false;

//   // ── Derived data ──────────────────────────────────────────────────────────
//   List<VenueSearchResultModel> get _venues =>
//       widget.venues.isNotEmpty ? widget.venues : VenueMapPage.mockVenues;

//   List<String> get _availableSports => [
//         'Tất cả',
//         ..._venues.expand((v) => v.sportTypes).toSet(),
//       ];

//   List<VenueSearchResultModel> get _filteredVenues => _selectedSport == 'Tất cả'
//       ? _venues
//       : _venues.where((v) => v.sportTypes.contains(_selectedSport)).toList();

//   GeoPoint get _initialCenter {
//     final first =
//         _venues.firstWhere((v) => v.latitude != null, orElse: () => VenueMapPage.mockVenues.first);
//     return GeoPoint(
//       latitude: widget.initialLat ?? first.latitude ?? 21.0285,
//       longitude: widget.initialLng ?? first.longitude ?? 105.8542,
//     );
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // Lifecycle
//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   void initState() {
//     super.initState();
//     // withPosition: khởi tạo bản đồ tại toạ độ cố định
//     _mapController = MapController.withPosition(initPosition: _initialCenter);
//     _mapController.addObserver(this);
//   }

//   @override
//   void dispose() {
//     _mapController.dispose();
//     _sheetController.dispose();
//     super.dispose();
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // OSMMixinObserver — các callback từ bản đồ
//   // ─────────────────────────────────────────────────────────────────────────

//   /// Gọi 1 lần khi map render xong, đây là nơi duy nhất an toàn để addMarker
//   @override
//   Future<void> mapIsReady(bool isReady) async {
//     if (!isReady) return;
//     setState(() => _mapReady = true);
//     await _syncMarkers();
//   }

//   /// Gọi khi map khôi phục (ví dụ resume app) — cần vẽ lại marker
//   @override
//   Future<void> mapRestored() async {
//     await super.mapRestored();
//     await _syncMarkers();
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // Marker helpers
//   // ─────────────────────────────────────────────────────────────────────────

//   /// Xoá toàn bộ marker cũ rồi vẽ lại theo _filteredVenues + _selectedVenue
//   Future<void> _syncMarkers() async {
//     if (!_mapReady) return;

//     // Xoá marker cũ (bỏ qua lỗi nếu chưa có marker nào)
//     try {
//       final allPoints = _venues
//           .where((v) => v.latitude != null && v.longitude != null)
//           .map((v) => GeoPoint(latitude: v.latitude!, longitude: v.longitude!))
//           .toList();
//       if (allPoints.isNotEmpty) await _mapController.removeMarkers(allPoints);
//     } catch (_) {}

//     // Vẽ lại marker cho từng venue trong filter hiện tại
//     for (final venue in _filteredVenues) {
//       if (venue.latitude == null || venue.longitude == null) continue;
//       final isSelected = _selectedVenue?.id == venue.id;
//       await _mapController.addMarker(
//         GeoPoint(latitude: venue.latitude!, longitude: venue.longitude!),
//         markerIcon: MarkerIcon(
//           icon: Icon(
//             Icons.stadium_rounded,
//             color: isSelected ? Colors.white : AppColors.primaryLightBrand,
//             size: isSelected ? 44 : 34,
//           ),
//         ),
//       );
//     }
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // User actions
//   // ─────────────────────────────────────────────────────────────────────────

//   Future<void> _onVenueTap(VenueSearchResultModel venue) async {
//     setState(() => _selectedVenue = venue);
//     if (venue.latitude != null && venue.longitude != null) {
//       await _mapController
//           .goToLocation(GeoPoint(latitude: venue.latitude!, longitude: venue.longitude!));
//       await _mapController.setZoom(zoomLevel: 15.5);
//     }
//     await _syncMarkers();
//     await _sheetController.animateTo(0.44,
//         duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
//   }

//   Future<void> _clearSelection() async {
//     setState(() => _selectedVenue = null);
//     await _syncMarkers();
//     await _sheetController.animateTo(0.14,
//         duration: const Duration(milliseconds: 300), curve: Curves.easeInCubic);
//   }

//   Future<void> _onSportChanged(String sport) async {
//     setState(() {
//       _selectedSport = sport;
//       _selectedVenue = null;
//     });
//     await _syncMarkers();
//   }

//   Future<void> _goToMyLocation() async {
//     if (!_mapReady) return;
//     try {
//       // Bật tracking GPS + nhảy đến vị trí người dùng
//       await _mapController.currentLocation();
//     } catch (_) {
//       // Fallback về trung tâm ban đầu nếu GPS lỗi
//       await _mapController.goToLocation(_initialCenter);
//     }
//   }

//   Future<void> _drawDirectionTo(VenueSearchResultModel venue) async {
//     if (venue.latitude == null || venue.longitude == null) return;
//     try {
//       GeoPoint? userLocation;
//       try {
//         userLocation = await _mapController.myLocation();
//       } catch (_) {
//         // Fallback to center if myLocation fails
//       }

//       await _mapController.drawRoad(
//         userLocation ?? _initialCenter,
//         GeoPoint(latitude: venue.latitude!, longitude: venue.longitude!),
//         roadType: RoadType.car,
//         roadOption: const RoadOption(
//           roadColor: AppColors.primaryLightBrand,
//           roadWidth: 6,
//           zoomInto: true,
//         ),
//       );
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Không thể tải đường đi. Vui lòng thử lại.')),
//         );
//       }
//     }
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   // Build
//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F1923),
//       body: Stack(
//         children: [
//           _buildOSMMap(),
//           SafeArea(child: _buildTopBar()),
//           SafeArea(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 72),
//                 child: _buildSportFilter(),
//               ),
//             ),
//           ),
//           if (!_mapReady) _buildLoadingOverlay(),
//           _buildBottomSheet(),
//         ],
//       ),
//     );
//   }

//   // ─── OSM Map ──────────────────────────────────────────────────────────────

//   Widget _buildOSMMap() {
//     return OSMFlutter(
//       controller: _mapController,
//       osmOption: OSMOption(
//         zoomOption: ZoomOption(
//           initZoom: widget.initialZoom ?? 13.5,
//           minZoomLevel: 5,
//           maxZoomLevel: 19,
//           stepZoom: 1.0,
//         ),
//         // Marker GPS user
//         userLocationMarker: UserLocationMaker(
//           personMarker: const MarkerIcon(
//             icon: Icon(Icons.my_location_rounded, color: AppColors.primaryLightBrand, size: 48),
//           ),
//           directionArrowMarker: const MarkerIcon(
//             icon: Icon(Icons.navigation_rounded, color: AppColors.primaryLightBrand, size: 48),
//           ),
//         ),
//         roadConfiguration: const RoadOption(roadColor: AppColors.primaryLightBrand),
//         showDefaultInfoWindow: false, // Tắt info window mặc định, dùng bottom sheet riêng
//         enableRotationByGesture: false, // Tắt xoay bản đồ bằng gesture (tránh lộn xộn)
//       ),
//       mapIsLoading: const Center(
//         child: CircularProgressIndicator(color: AppColors.primaryLightBrand),
//       ),
//       // Khi user click lên 1 marker → tìm venue tương ứng
//       onGeoPointClicked: (geoPoint) {
//         final match = _filteredVenues.cast<VenueSearchResultModel?>().firstWhere(
//               (v) =>
//                   v != null &&
//                   v.latitude != null &&
//                   v.longitude != null &&
//                   (v.latitude! - geoPoint.latitude).abs() < 0.0005 &&
//                   (v.longitude! - geoPoint.longitude).abs() < 0.0005,
//               orElse: () => null,
//             );
//         if (match != null) _onVenueTap(match);
//       },
//     );
//   }

//   // ─── Loading overlay ──────────────────────────────────────────────────────

//   Widget _buildLoadingOverlay() => Container(
//         color: const Color(0xFF0F1923),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(color: AppColors.primaryLightBrand),
//               const SizedBox(height: 16),
//               Text(
//                 'Đang tải bản đồ...',
//                 style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//       );

//   // ─── Top bar ──────────────────────────────────────────────────────────────

//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           _MapBtn(icon: Icons.arrow_back_rounded, onTap: () => context.pop()),
//           const SizedBox(width: 10),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => context.push(RouteNames.venueSearch),
//               child: Container(
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: [
//                     BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12),
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Tìm sân thể thao...',
//                       style: TextStyle(color: Colors.grey[400], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           _MapBtn(icon: Icons.my_location_rounded, onTap: _goToMyLocation),
//         ],
//       ),
//     );
//   }

//   // ─── Sport filter chips ───────────────────────────────────────────────────

//   Widget _buildSportFilter() {
//     final sports = _availableSports;
//     if (sports.length <= 1) return const SizedBox.shrink();
//     return SizedBox(
//       height: 36,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: sports.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (_, i) {
//           final sport = sports[i];
//           final selected = _selectedSport == sport;
//           return GestureDetector(
//             onTap: () => _onSportChanged(sport),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//               decoration: BoxDecoration(
//                 color: selected ? AppColors.primaryLightBrand : Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 6),
//                 ],
//               ),
//               child: Text(
//                 sport,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
//                   color: selected ? Colors.white : const Color(0xFF2C3E50),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ─── Bottom sheet ─────────────────────────────────────────────────────────

//   Widget _buildBottomSheet() {
//     return DraggableScrollableSheet(
//       controller: _sheetController,
//       initialChildSize: 0.14,
//       minChildSize: 0.08,
//       maxChildSize: 0.78,
//       snap: true,
//       snapSizes: const [0.14, 0.44, 0.78],
//       builder: (context, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4))],
//           ),
//           child: Column(
//             children: [
//               // Handle (gõ để toggle state)
//               GestureDetector(
//                 onTap: () {
//                   final s = _sheetController.size;
//                   _sheetController.animateTo(
//                     s < 0.3 ? 0.44 : (s < 0.6 ? 0.78 : 0.14),
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOutCubic,
//                   );
//                 },
//                 child: Container(
//                   color: Colors.transparent,
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   alignment: Alignment.center,
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFDDE3EA),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//               ),

//               // Header
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _selectedVenue != null
//                             ? 'Chi tiết sân'
//                             : '${_filteredVenues.length} sân gần bạn',
//                         style: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF1A2332),
//                         ),
//                       ),
//                     ),
//                     if (_selectedVenue != null)
//                       GestureDetector(
//                         onTap: _clearSelection,
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF0F3F7),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child:
//                               const Icon(Icons.close_rounded, size: 18, color: Color(0xFF5A6A7D)),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               // Content
//               Expanded(
//                 child: _selectedVenue != null
//                     ? _buildVenueDetail(_selectedVenue!, scrollController)
//                     : _buildVenueList(scrollController),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ─── Venue list ───────────────────────────────────────────────────────────

//   Widget _buildVenueList(ScrollController scrollController) {
//     final list = _filteredVenues;
//     if (list.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.search_off_rounded, size: 52, color: Colors.grey[300]),
//             const SizedBox(height: 12),
//             const Text('Không tìm thấy sân', style: TextStyle(color: Color(0xFF7A8FA6))),
//           ],
//         ),
//       );
//     }
//     return ListView.separated(
//       controller: scrollController,
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//       itemCount: list.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (_, i) => _VenueListCard(
//         venue: list[i],
//         priceFmt: _priceFmt,
//         onTap: () => _onVenueTap(list[i]),
//       ),
//     );
//   }

//   // ─── Venue detail ─────────────────────────────────────────────────────────

//   Widget _buildVenueDetail(VenueSearchResultModel venue, ScrollController scrollController) {
//     return SingleChildScrollView(
//       controller: scrollController,
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Ảnh thumbnail
//           if (venue.thumbnailUrl != null)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 venue.thumbnailUrl!,
//                 height: 160,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => const _ImagePlaceholder(height: 160),
//               ),
//             ),
//           const SizedBox(height: 16),

//           // Tên sân + badge mở/đóng
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   venue.name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF1A2332),
//                     height: 1.25,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const _Badge(
//                 label: 'Đang mở',
//                 color: Color(0xFF00A885),
//                 bg: Color(0xFFE8FBF7),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // Sport tags
//           Wrap(
//             spacing: 6,
//             runSpacing: 4,
//             children: venue.sportTypes.map((s) => _SportTag(label: s)).toList(),
//           ),
//           const SizedBox(height: 12),

//           // Địa chỉ
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primaryLightBrand),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   venue.address,
//                   style: const TextStyle(fontSize: 13, color: Color(0xFF5A6A7D)),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // Rating
//           Row(
//             children: [
//               const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB800)),
//               const SizedBox(width: 4),
//               Text(
//                 '${venue.rating}',
//                 style: const TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2332)),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '(${venue.totalReviews} đánh giá)',
//                 style: const TextStyle(fontSize: 12, color: Color(0xFF7A8FA6)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),

//           // Price card
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5FDFB),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: const Color(0xFFD0F2EC)),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.payments_rounded, size: 20, color: AppColors.primaryLightBrand),
//                 const SizedBox(width: 10),
//                 const Text('Giá từ', style: TextStyle(fontSize: 14, color: Color(0xFF5A6A7D))),
//                 const Spacer(),
//                 Text(
//                   venue.minPricePerHour != null
//                       ? '${_priceFmt.format(venue.minPricePerHour)}đ/giờ'
//                       : '---',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                     color: AppColors.primaryLightBrand,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Action buttons
//           Row(
//             children: [
//               // Nút chỉ đường (drawRoad)
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () => _drawDirectionTo(venue),
//                   icon: const Icon(Icons.directions_rounded, size: 18),
//                   label: const Text('Chỉ đường'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.primaryLightBrand,
//                     side: const BorderSide(color: AppColors.primaryLightBrand),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               // Nút đặt sân
//               Expanded(
//                 flex: 2,
//                 child: ElevatedButton.icon(
//                   onPressed: () => context.push('/venue-detail/${venue.slug}'),
//                   icon: const Icon(Icons.calendar_month_rounded, size: 18),
//                   label: const Text('Đặt sân ngay'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryLightBrand,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Reusable Widgets
// // ─────────────────────────────────────────────────────────────────────────────

// class _MapBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _MapBtn({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12),
//             ],
//           ),
//           child: Icon(icon, color: const Color(0xFF2C3E50), size: 22),
//         ),
//       );
// }

// class _VenueListCard extends StatelessWidget {
//   final VenueSearchResultModel venue;
//   final NumberFormat priceFmt;
//   final VoidCallback onTap;
//   const _VenueListCard({required this.venue, required this.priceFmt, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color(0xFFEBF0F5)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Ảnh sân
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: venue.thumbnailUrl != null
//                   ? Image.network(
//                       venue.thumbnailUrl!,
//                       width: 68,
//                       height: 68,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => const _ImagePlaceholder(height: 68, width: 68),
//                     )
//                   : const _ImagePlaceholder(height: 68, width: 68),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Tên + trạng thái
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           venue.name,
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A2332)),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       const _Badge(
//                           label: 'Mở',
//                           color: Color(0xFF00A885),
//                           bg: Color(0xFFE8FBF7),
//                           small: true),
//                     ],
//                   ),
//                   const SizedBox(height: 3),
//                   // Địa chỉ
//                   Text(
//                     venue.address,
//                     style: const TextStyle(fontSize: 12, color: Color(0xFF7A8FA6)),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 5),
//                   // Sport tags
//                   Wrap(
//                     spacing: 4,
//                     children: venue.sportTypes
//                         .take(2)
//                         .map((s) => _SportTag(label: s, small: true))
//                         .toList(),
//                   ),
//                   const SizedBox(height: 5),
//                   // Rating + giá
//                   Row(
//                     children: [
//                       const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFB800)),
//                       const SizedBox(width: 3),
//                       Text('${venue.rating}',
//                           style: const TextStyle(
//                               fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2332))),
//                       const Spacer(),
//                       Text(
//                         venue.minPricePerHour != null
//                             ? '${priceFmt.format(venue.minPricePerHour)}đ/giờ'
//                             : '---',
//                         style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.primaryLightBrand),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Badge extends StatelessWidget {
//   final String label;
//   final Color color;
//   final Color bg;
//   final bool small;
//   const _Badge({required this.label, required this.color, required this.bg, this.small = false});

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: EdgeInsets.symmetric(horizontal: small ? 6 : 10, vertical: small ? 2 : 5),
//         decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
//         child: Text(
//           label,
//           style: TextStyle(fontSize: small ? 11 : 12, fontWeight: FontWeight.w600, color: color),
//         ),
//       );
// }

// class _SportTag extends StatelessWidget {
//   final String label;
//   final bool small;
//   const _SportTag({required this.label, this.small = false});

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: EdgeInsets.symmetric(horizontal: small ? 6 : 8, vertical: 2),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF0FBF9),
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: const Color(0xFFB8EDE5)),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: small ? 11 : 12,
//             color: AppColors.primaryLightBrand,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
// }

// class _ImagePlaceholder extends StatelessWidget {
//   final double height;
//   final double? width;
//   const _ImagePlaceholder({required this.height, this.width});

//   @override
//   Widget build(BuildContext context) => Container(
//         width: width,
//         height: height,
//         color: const Color(0xFFEDF2F7),
//         child: const Center(
//           child: Icon(Icons.image_not_supported_rounded, color: Color(0xFFBCC6D1)),
//         ),
//       );
// }
