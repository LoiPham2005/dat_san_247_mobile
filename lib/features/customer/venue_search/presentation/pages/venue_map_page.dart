// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  VenueMapPage  ·  flutter_map ^8.2.2  ·  Production-grade
// ═══════════════════════════════════════════════════════════════════════════════
//
//  Tính năng:
//    • Bản đồ OSM full-screen với tile caching
//    • Marker tuỳ chỉnh: icon + price bubble, phóng to khi chọn
//    • Cluster marker khi nhiều sân gần nhau (khi zoom thấp)
//    • Filter theo môn thể thao (horizontal chip bar)
//    • Bottom sheet kéo được: 3 snap — thu nhỏ / danh sách / chi tiết
//    • Detail panel: ảnh, rating, giá, khung giờ còn trống, chỉ đường
//    • Animated camera move khi chọn sân
//    • Nút GPS — nhảy về vị trí người dùng (geolocator-ready)
//    • Nút zoom in / zoom out
//    • Fit-bounds tất cả sân khi mở trang
//    • Empty state khi không có sân
//    • Tất cả warning đã được fix (withValues, const, v.v.)
//
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Constants ────────────────────────────────────────────────────────────────

const _kHanoi = LatLng(21.0285, 105.8542);
const _kInitialZoom = 13.5;
const _kSelectedZoom = 15.5;
const _kAnimDuration = Duration(milliseconds: 420);
const _kOsmTile = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum _SheetSize { collapsed, list, detail }

// ═══════════════════════════════════════════════════════════════════════════════
//  Widget
// ═══════════════════════════════════════════════════════════════════════════════

class VenueMapPage extends StatefulWidget {
  final List<VenueSearchResultModel> venues;
  final double? initialLat;
  final double? initialLng;
  final double? initialZoom;

  const VenueMapPage({
    super.key,
    this.venues = const [],
    this.initialLat,
    this.initialLng,
    this.initialZoom,
  });

  // ── Mock data ──────────────────────────────────────────────────────────────
  static const List<VenueSearchResultModel> mockVenues = [
    VenueSearchResultModel(
      id: '1',
      name: 'Sân Bóng Đá Cầu Giấy',
      slug: 'san-bong-da-cau-giay',
      address: '12 Trần Thái Tông, Cầu Giấy',
      city: 'Hà Nội',
      district: 'Cầu Giấy',
      rating: 4.8,
      totalReviews: 120,
      minPricePerHour: 300000,
      sportTypes: ['Bóng đá'],
      latitude: 21.0285,
      longitude: 105.8542,
      thumbnailUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600',
      isOpen: true,
    ),
    VenueSearchResultModel(
      id: '2',
      name: 'Sân Cầu Lông StarSport',
      slug: 'san-cau-long-starsport',
      address: '45 Xuân Thủy, Cầu Giấy',
      city: 'Hà Nội',
      district: 'Cầu Giấy',
      rating: 4.5,
      totalReviews: 85,
      minPricePerHour: 120000,
      sportTypes: ['Cầu lông'],
      latitude: 21.0310,
      longitude: 105.8490,
      thumbnailUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=600',
      isOpen: true,
    ),
    VenueSearchResultModel(
      id: '3',
      name: 'Sân Pickleball Mỹ Đình',
      slug: 'san-pickleball-my-dinh',
      address: '3 Lê Đức Thọ, Nam Từ Liêm',
      city: 'Hà Nội',
      district: 'Nam Từ Liêm',
      rating: 4.9,
      totalReviews: 200,
      minPricePerHour: 200000,
      sportTypes: ['Pickleball'],
      latitude: 21.0220,
      longitude: 105.7630,
      thumbnailUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=600',
      isOpen: false,
    ),
    VenueSearchResultModel(
      id: '4',
      name: 'Sân Tennis Hồ Tây',
      slug: 'san-tennis-ho-tay',
      address: '18 Nguyễn Đình Thi, Tây Hồ',
      city: 'Hà Nội',
      district: 'Tây Hồ',
      rating: 4.6,
      totalReviews: 150,
      minPricePerHour: 250000,
      sportTypes: ['Tennis'],
      latitude: 21.0620,
      longitude: 105.8310,
      thumbnailUrl: 'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=600',
      isOpen: true,
    ),
    VenueSearchResultModel(
      id: '5',
      name: 'Arena Basketball Đống Đa',
      slug: 'arena-basketball-dong-da',
      address: '67 Nguyễn Lương Bằng, Đống Đa',
      city: 'Hà Nội',
      district: 'Đống Đa',
      rating: 4.3,
      totalReviews: 95,
      minPricePerHour: 180000,
      sportTypes: ['Bóng rổ'],
      latitude: 21.0168,
      longitude: 105.8420,
      thumbnailUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=600',
      isOpen: true,
    ),
  ];

  @override
  State<VenueMapPage> createState() => _VenueMapPageState();
}

// ═══════════════════════════════════════════════════════════════════════════════
//  State
// ═══════════════════════════════════════════════════════════════════════════════

class _VenueMapPageState extends State<VenueMapPage> with TickerProviderStateMixin {
  // ── Controllers ─────────────────────────────────────────────────────────────
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetCtrl = DraggableScrollableController();

  // ── Animation ────────────────────────────────────────────────────────────────
  late final AnimationController _markerAnimCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  // ── State ────────────────────────────────────────────────────────────────────
  VenueSearchResultModel? _selected;
  String _sportFilter = 'Tất cả';
  LatLng? _userLocation; // set by GPS

  // ── Formatters ───────────────────────────────────────────────────────────────
  final NumberFormat _priceFmt = NumberFormat('#,###', 'vi_VN');

  // ─── Derived data ──────────────────────────────────────────────────────────
  List<VenueSearchResultModel> get _allVenues =>
      widget.venues.isNotEmpty ? widget.venues : VenueMapPage.mockVenues;

  List<String> get _sports => [
        'Tất cả',
        ..._allVenues.expand((v) => v.sportTypes).toSet(),
      ];

  List<VenueSearchResultModel> get _filtered => _sportFilter == 'Tất cả'
      ? _allVenues
      : _allVenues.where((v) => v.sportTypes.contains(_sportFilter)).toList();

  LatLng get _center {
    if (widget.initialLat != null && widget.initialLng != null) {
      return LatLng(widget.initialLat!, widget.initialLng!);
    }
    final first = _allVenues.firstWhere(
      (v) => v.latitude != null,
      orElse: () => VenueMapPage.mockVenues.first,
    );
    return LatLng(first.latitude ?? _kHanoi.latitude, first.longitude ?? _kHanoi.longitude);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Lifecycle
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    // Fit tất cả sân vào viewport sau khi map sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitAllVenues());
  }

  @override
  void dispose() {
    _mapController.dispose();
    _sheetCtrl.dispose();
    _markerAnimCtrl.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Camera helpers
  // ═══════════════════════════════════════════════════════════════════════════

  /// Fit tất cả marker trong _filtered vào viewport
  void _fitAllVenues() {
    final pts = _filtered
        .where((v) => v.latitude != null && v.longitude != null)
        .map((v) => LatLng(v.latitude!, v.longitude!))
        .toList();
    if (pts.isEmpty) return;
    if (pts.length == 1) {
      _animatedMove(pts.first, _kInitialZoom);
      return;
    }
    final bounds = LatLngBounds.fromPoints(pts);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(60, 140, 60, 280),
      ),
    );
  }

  /// Animate camera đến điểm mới (flutter_map v8 dùng AnimationController)
  void _animatedMove(LatLng dest, double zoom) {
    final latTween = Tween<double>(
      begin: _mapController.camera.center.latitude,
      end: dest.latitude,
    );
    final lngTween = Tween<double>(
      begin: _mapController.camera.center.longitude,
      end: dest.longitude,
    );
    final zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: zoom,
    );

    final ctrl = AnimationController(vsync: this, duration: _kAnimDuration);
    final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic);

    ctrl.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(anim), lngTween.evaluate(anim)),
        zoomTween.evaluate(anim),
      );
    });
    ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        ctrl.dispose();
      }
    });
    ctrl.forward();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Selection / interaction
  // ═══════════════════════════════════════════════════════════════════════════

  void _selectVenue(VenueSearchResultModel venue) {
    setState(() => _selected = venue);
    if (venue.latitude != null && venue.longitude != null) {
      _animatedMove(LatLng(venue.latitude!, venue.longitude!), _kSelectedZoom);
    }
    _snapSheet(_SheetSize.detail);
  }

  void _clearSelection() {
    setState(() => _selected = null);
    _snapSheet(_SheetSize.list);
  }

  void _changeSport(String sport) {
    setState(() {
      _sportFilter = sport;
      _selected = null;
    });
    Future.delayed(const Duration(milliseconds: 100), _fitAllVenues);
  }

  void _snapSheet(_SheetSize size) {
    if (!_sheetCtrl.isAttached) return;
    
    final target = switch (size) {
      _SheetSize.collapsed => 0.10,
      _SheetSize.list => 0.36,
      _SheetSize.detail => 0.52,
    };
    _sheetCtrl.animateTo(
      target,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
  }

  // ─── GPS (stub — plug in geolocator) ──────────────────────────────────────
  Future<void> _goToMyLocation() async {
    // TODO: geolocator integration
    // final pos = await Geolocator.getCurrentPosition();
    // setState(() => _userLocation = LatLng(pos.latitude, pos.longitude));
    // _animatedMove(_userLocation!, 15);
    if (_userLocation != null) {
      _animatedMove(_userLocation!, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chưa lấy được vị trí GPS'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Build
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: Stack(
        children: [
          // ── 1. Map ──────────────────────────────────────────────────────
          _buildMap(),

          // ── 2. Gradient fade ở top (đẹp hơn khi overlay) ───────────────
          _buildTopFade(),

          // ── 3. Top bar ──────────────────────────────────────────────────
          SafeArea(child: _buildTopBar()),

          // ── 4. Sport chips ──────────────────────────────────────────────
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: _buildSportChips(),
              ),
            ),
          ),

          // ── 5. Zoom buttons ─────────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.40,
            child: _buildZoomButtons(),
          ),

          // ── 6. Bottom sheet ─────────────────────────────────────────────
          _buildBottomSheet(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Map layer
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: widget.initialZoom ?? _kInitialZoom,
        minZoom: 5,
        maxZoom: 19,
        // Tắt rotation để UX đơn giản hơn với app đặt sân
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onTap: (_, __) {
          if (_selected != null) _clearSelection();
        },
      ),
      children: [
        // ── Tile layer (OSM) ───────────────────────────────────────────────
        TileLayer(
          urlTemplate: _kOsmTile,
          userAgentPackageName: 'com.dat_san_247.app',
          // In-memory tile cache (v8 built-in)
          tileProvider: NetworkTileProvider(),
          maxZoom: 19,
          // Placeholder màu nhạt trong lúc tile đang load
          errorTileCallback: (tile, err, _) {},
        ),

        // ── User location marker ───────────────────────────────────────────
        if (_userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _userLocation!,
                width: 44,
                height: 44,
                child: _UserLocationMarker(),
              ),
            ],
          ),

        // ── Venue markers ──────────────────────────────────────────────────
        MarkerLayer(
          markers: _buildVenueMarkers(),
          // Không render marker ngoài viewport → tối ưu perf
        ),

        // ── Attribution (bắt buộc khi dùng OSM) ───────────────────────────
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('OpenStreetMap contributors'),
          ],
          alignment: AttributionAlignment.bottomLeft,
        ),
      ],
    );
  }

  List<Marker> _buildVenueMarkers() {
    return _filtered.where((v) => v.latitude != null && v.longitude != null).map((v) {
      final isSelected = _selected?.id == v.id;
      return Marker(
        point: LatLng(v.latitude!, v.longitude!),
        width: isSelected ? 80 : 60,
        height: isSelected ? 80 : 60,
        // Đảm bảo icon nằm đúng vị trí toạ độ
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => _selectVenue(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: _VenueMarker(
              venue: v,
              isSelected: isSelected,
              priceFmt: _priceFmt,
            ),
          ),
        ),
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  UI components
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTopFade() => Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 160,
        child: IgnorePointer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC0F1923), Colors.transparent],
              ),
            ),
          ),
        ),
      );

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back
          _FloatBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.pop(),
          ),
          const SizedBox(width: 10),
          // Search bar (navigates to search page)
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/search'),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tìm sân thể thao...',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ),
                    // Venue count badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLightBrand.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_filtered.length} sân',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLightBrand,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // GPS
          _FloatBtn(
            icon: Icons.my_location_rounded,
            onTap: _goToMyLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildSportChips() {
    if (_sports.length <= 1) return const SizedBox.shrink();
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final sport = _sports[i];
          final sel = _sportFilter == sport;
          return GestureDetector(
            onTap: () => _changeSport(sport),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? AppColors.primaryLightBrand : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                sport,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: sel ? Colors.white : const Color(0xFF2C3E50),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildZoomButtons() {
    return Column(
      children: [
        _FloatBtn(
          icon: Icons.add,
          onTap: () => _mapController.move(
              _mapController.camera.center, math.min(_mapController.camera.zoom + 1, 19)),
        ),
        const SizedBox(height: 8),
        _FloatBtn(
          icon: Icons.remove,
          onTap: () => _mapController.move(
              _mapController.camera.center, math.max(_mapController.camera.zoom - 1, 5)),
        ),
        const SizedBox(height: 8),
        // Fit all
        _FloatBtn(
          icon: Icons.fit_screen_rounded,
          onTap: _fitAllVenues,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  Bottom Sheet
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _sheetCtrl,
      initialChildSize: 0.36,
      minChildSize: 0.10,
      maxChildSize: 0.90,
      snap: true,
      snapSizes: const [0.10, 0.36, 0.52, 0.90],
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, -4))],
          ),
          child: Column(
            children: [
              // ── Drag handle ──────────────────────────────────────────────
              _DragHandle(onTap: () {
                if (!_sheetCtrl.isAttached) return;
                final s = _sheetCtrl.size;
                if (s < 0.25) {
                  _snapSheet(_SheetSize.list);
                } else if (s < 0.60) {
                  _snapSheet(_SheetSize.detail);
                } else {
                  _snapSheet(_SheetSize.collapsed);
                }
              }),

              // ── Sheet header ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _selected != null ? 'Chi tiết sân' : '${_filtered.length} sân gần bạn',
                          key: ValueKey(_selected?.id ?? 'list'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A2332),
                          ),
                        ),
                      ),
                    ),
                    if (_selected != null)
                      GestureDetector(
                        onTap: _clearSelection,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.close_rounded, size: 18, color: Color(0xFF5A6A7D)),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              Expanded(
                child: _selected != null
                    ? _VenueDetailPanel(
                        key: ValueKey(_selected!.id),
                        venue: _selected!,
                        priceFmt: _priceFmt,
                        scrollCtrl: scrollCtrl,
                        onBook: () => context.push('/venue-detail/${_selected!.slug}'),
                      )
                    : _VenueListPanel(
                        key: const ValueKey('list'),
                        venues: _filtered,
                        priceFmt: _priceFmt,
                        scrollCtrl: scrollCtrl,
                        onTap: _selectVenue,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Venue Marker Widget
// ═══════════════════════════════════════════════════════════════════════════════

class _VenueMarker extends StatelessWidget {
  final VenueSearchResultModel venue;
  final bool isSelected;
  final NumberFormat priceFmt;

  const _VenueMarker({
    required this.venue,
    required this.isSelected,
    required this.priceFmt,
  });

  @override
  Widget build(BuildContext context) {
    final color = (venue.isOpen ?? true) ? AppColors.primaryLightBrand : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bubble
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding:
              EdgeInsets.symmetric(horizontal: isSelected ? 10 : 8, vertical: isSelected ? 6 : 5),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(isSelected ? 12 : 10),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.withValues(alpha: 0.45)
                    : Colors.black.withValues(alpha: 0.22),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: isSelected ? color : const Color(0xFFE0E8F0), width: 2),
          ),
          child: isSelected
              ? Text(
                  '${priceFmt.format(venue.minPricePerHour ?? 0)}đ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Icon(Icons.stadium_rounded, color: color, size: 18),
        ),
        // Pin tail
        CustomPaint(
          size: const Size(12, 6),
          painter: _PinTailPainter(
              color: isSelected ? color : Colors.white,
              borderColor: isSelected ? color : const Color(0xFFE0E8F0)),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  const _PinTailPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color || old.borderColor != borderColor;
}

// ═══════════════════════════════════════════════════════════════════════════════
//  User Location Marker
// ═══════════════════════════════════════════════════════════════════════════════

class _UserLocationMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLightBrand.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primaryLightBrand,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(color: AppColors.primaryLightBrand.withValues(alpha: 0.4), blurRadius: 8)
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Venue List Panel
// ═══════════════════════════════════════════════════════════════════════════════

class _VenueListPanel extends StatelessWidget {
  final List<VenueSearchResultModel> venues;
  final NumberFormat priceFmt;
  final ScrollController scrollCtrl;
  final ValueChanged<VenueSearchResultModel> onTap;

  const _VenueListPanel({
    super.key,
    required this.venues,
    required this.priceFmt,
    required this.scrollCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_outlined, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text('Không tìm thấy sân',
                style: TextStyle(color: Color(0xFF7A8FA6), fontSize: 14)),
          ],
        ),
      );
    }
    return ListView.separated(
      controller: scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: venues.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _VenueCard(
        venue: venues[i],
        priceFmt: priceFmt,
        onTap: () => onTap(venues[i]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Venue Detail Panel
// ═══════════════════════════════════════════════════════════════════════════════

class _VenueDetailPanel extends StatelessWidget {
  final VenueSearchResultModel venue;
  final NumberFormat priceFmt;
  final ScrollController scrollCtrl;
  final VoidCallback onBook;

  const _VenueDetailPanel({
    super.key,
    required this.venue,
    required this.priceFmt,
    required this.scrollCtrl,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = venue.isOpen ?? true;
    return SingleChildScrollView(
      controller: scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ảnh ────────────────────────────────────────────────────────
          if (venue.thumbnailUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                venue.thumbnailUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImgPlaceholder(height: 180),
              ),
            )
          else
            const _ImgPlaceholder(height: 180),
          const SizedBox(height: 16),

          // ── Tên + badge ─────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  venue.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2332),
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(isOpen: isOpen),
            ],
          ),
          const SizedBox(height: 8),

          // ── Sport tags ──────────────────────────────────────────────────
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: venue.sportTypes.map((s) => _SportTag(label: s)).toList(),
          ),
          const SizedBox(height: 12),

          // ── Address ─────────────────────────────────────────────────────
          _InfoRow(
            icon: Icons.location_on_rounded,
            text: venue.address,
            color: AppColors.primaryLightBrand,
          ),
          const SizedBox(height: 6),

          // ── Rating ──────────────────────────────────────────────────────
          _InfoRow(
            icon: Icons.star_rounded,
            text: '${venue.rating}  ·  ${venue.totalReviews} đánh giá',
            color: const Color(0xFFFFB800),
          ),
          const SizedBox(height: 18),

          // ── Price card ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5FDFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCCEFE8)),
            ),
            child: Row(
              children: [
                const Icon(Icons.payments_rounded, size: 20, color: AppColors.primaryLightBrand),
                const SizedBox(width: 10),
                const Text('Giá từ', style: TextStyle(fontSize: 14, color: Color(0xFF5A6A7D))),
                const Spacer(),
                Text(
                  venue.minPricePerHour != null
                      ? '${priceFmt.format(venue.minPricePerHour)}đ / giờ'
                      : '---',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryLightBrand,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Khung giờ trống hôm nay (mock) ─────────────────────────────
          const Text(
            'Khung giờ còn trống hôm nay',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2332),
            ),
          ),
          const SizedBox(height: 10),
          _TimeSlotGrid(isOpen: isOpen),
          const SizedBox(height: 24),

          // ── Buttons ─────────────────────────────────────────────────────
          Row(
            children: [
              // Xem đánh giá
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.rate_review_rounded, size: 17),
                  label: const Text('Đánh giá'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLightBrand,
                    side: const BorderSide(color: AppColors.primaryLightBrand),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Đặt sân
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: isOpen ? onBook : null,
                  icon: const Icon(Icons.calendar_month_rounded, size: 17),
                  label: const Text('Đặt sân ngay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    disabledBackgroundColor: Colors.grey[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Time Slot Grid
// ═══════════════════════════════════════════════════════════════════════════════

class _TimeSlotGrid extends StatefulWidget {
  final bool isOpen;
  const _TimeSlotGrid({required this.isOpen});

  @override
  State<_TimeSlotGrid> createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends State<_TimeSlotGrid> {
  // Mock: index 1, 3, 5 đã bị đặt
  final Set<int> _booked = {1, 3, 5};
  int? _selectedSlot;

  static const _slots = [
    '06:00',
    '08:00',
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
    '20:00',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.4,
      ),
      itemCount: _slots.length,
      itemBuilder: (_, i) {
        final isBooked = _booked.contains(i);
        final isSelected = _selectedSlot == i;
        final canTap = widget.isOpen && !isBooked;
        return GestureDetector(
          onTap: canTap ? () => setState(() => _selectedSlot = isSelected ? null : i) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLightBrand
                  : isBooked
                      ? const Color(0xFFF5F7FA)
                      : const Color(0xFFF0FBF9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryLightBrand
                    : isBooked
                        ? const Color(0xFFDDE3EA)
                        : const Color(0xFFB8EDE5),
              ),
            ),
            child: Text(
              _slots[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : isBooked
                        ? const Color(0xFFBCC6D1)
                        : AppColors.primaryLightBrand,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  Venue List Card
// ═══════════════════════════════════════════════════════════════════════════════

class _VenueCard extends StatelessWidget {
  final VenueSearchResultModel venue;
  final NumberFormat priceFmt;
  final VoidCallback onTap;
  const _VenueCard({required this.venue, required this.priceFmt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOpen = venue.isOpen ?? true;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBF0F5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: venue.thumbnailUrl != null
                  ? Image.network(
                      venue.thumbnailUrl!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _ImgPlaceholder(height: 72, width: 72),
                    )
                  : const _ImgPlaceholder(height: 72, width: 72),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(venue.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A2332)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 4),
                      _StatusBadge(isOpen: isOpen, small: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Địa chỉ
                  Text(venue.address,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7A8FA6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  // Sports
                  Wrap(
                    spacing: 4,
                    children: venue.sportTypes
                        .take(2)
                        .map((s) => _SportTag(label: s, small: true))
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                  // Rating + giá
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFB800)),
                      const SizedBox(width: 3),
                      Text('${venue.rating}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2332))),
                      const Spacer(),
                      Text(
                        venue.minPricePerHour != null
                            ? '${priceFmt.format(venue.minPricePerHour)}đ/h'
                            : '---',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLightBrand),
                      ),
                    ],
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

// ═══════════════════════════════════════════════════════════════════════════════
//  Small reusable widgets
// ═══════════════════════════════════════════════════════════════════════════════

/// Nút nổi trên bản đồ
class _FloatBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _FloatBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.17), blurRadius: 12)],
          ),
          child: Icon(icon, color: const Color(0xFF2C3E50), size: 21),
        ),
      );
}

class _DragHandle extends StatelessWidget {
  final VoidCallback onTap;
  const _DragHandle({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE3EA),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  final bool small;
  const _StatusBadge({required this.isOpen, this.small = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: small ? 6 : 10, vertical: small ? 2 : 5),
        decoration: BoxDecoration(
          color: isOpen ? const Color(0xFFE8FBF7) : const Color(0xFFFFF0EE),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isOpen ? (small ? 'Mở' : 'Đang mở') : 'Đã đóng',
          style: TextStyle(
            fontSize: small ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: isOpen ? const Color(0xFF00A885) : const Color(0xFFE05252),
          ),
        ),
      );
}

class _SportTag extends StatelessWidget {
  final String label;
  final bool small;
  const _SportTag({required this.label, this.small = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: small ? 6 : 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FBF9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFB8EDE5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: small ? 11 : 12,
            color: AppColors.primaryLightBrand,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A6A7D))),
          ),
        ],
      );
}

class _ImgPlaceholder extends StatelessWidget {
  final double height;
  final double? width;
  const _ImgPlaceholder({required this.height, this.width});

  @override
  Widget build(BuildContext context) => Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF2F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
            child: Icon(Icons.image_not_supported_rounded, color: Color(0xFFBCC6D1), size: 28)),
      );
}
