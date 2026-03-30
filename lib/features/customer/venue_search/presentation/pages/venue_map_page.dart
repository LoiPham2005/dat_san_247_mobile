// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math' as math;

import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/services/permission/permission_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../cubit/venue_search_cubit.dart';
import '../widgets/map_ui_components.dart';
import '../widgets/venue_detail_panel.dart';
import '../widgets/venue_list_panel.dart';
import '../widgets/venue_marker.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const _kHanoi = LatLng(21.0285, 105.8542);
const _kInitialZoom = 13.5;
const _kSelectedZoom = 15.5;
const _kOsmTile = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

enum _SheetSize { collapsed, list, detail, full }

class VenueMapPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VenueSearchCubit>(),
      child: _VenueMapPageContent(
        venues: venues,
        initialLat: initialLat,
        initialLng: initialLng,
        initialZoom: initialZoom,
      ),
    );
  }
}

class _VenueMapPageContent extends StatefulWidget {
  final List<VenueSearchResultModel> venues;
  final double? initialLat;
  final double? initialLng;
  final double? initialZoom;

  const _VenueMapPageContent({
    this.venues = const [],
    this.initialLat,
    this.initialLng,
    this.initialZoom,
  });

  @override
  State<_VenueMapPageContent> createState() => _VenueMapPageContentState();
}

class _VenueMapPageContentState extends State<_VenueMapPageContent> {
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetCtrl =
      DraggableScrollableController();

  VenueSearchResultModel? _selected;
  String _sportFilter = 'Tất cả';
  LatLng? _userLocation;

  final NumberFormat _priceFmt = NumberFormat('#,###', 'vi_VN');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<VenueSearchResultModel> _effectiveVenues = [];

  List<VenueSearchResultModel> get _allVenues => _effectiveVenues;

  List<String> get _sports => [
        'Tất cả',
        ..._allVenues.expand((v) => v.sportTypes).toSet(),
      ];

  List<VenueSearchResultModel> get _filtered {
    return _allVenues.where((v) {
      final matchesSport =
          _sportFilter == 'Tất cả' || v.sportTypes.contains(_sportFilter);
      final q = _searchQuery.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          v.name.toLowerCase().contains(q) ||
          v.address.toLowerCase().contains(q) ||
          v.city.toLowerCase().contains(q) ||
          v.district.toLowerCase().contains(q);
      return matchesSport && matchesQuery;
    }).toList();
  }

  LatLng get _center {
    if (widget.initialLat != null && widget.initialLng != null) {
      return LatLng(widget.initialLat!, widget.initialLng!);
    }
    if (_allVenues.isNotEmpty) {
      final first = _allVenues.firstWhere(
        (v) => v.latitude != null,
        orElse: () => _allVenues.first,
      );
      return LatLng(first.latitude ?? _kHanoi.latitude,
          first.longitude ?? _kHanoi.longitude);
    }
    return _kHanoi;
  }

  @override
  void initState() {
    super.initState();
    _effectiveVenues = widget.venues; // Initialize with passed venues
    _searchQuery = _searchController.text.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.venues.isEmpty) {
        context.read<VenueSearchCubit>().searchVenues({});
      } else {
        _fitAllVenues();
      }
    });
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    _searchController.dispose();
    super.dispose();
  }

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

  void _animatedMove(LatLng dest, double zoom) {
    if (!mounted) return;
    _mapController.move(dest, zoom);
  }

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

    if (widget.venues.isEmpty) {
      context.read<VenueSearchCubit>().searchVenues({
        'keyword': _searchQuery,
        if (_sportFilter != 'Tất cả') 'sport_type': _sportFilter,
      });
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        _fitAllVenues();
      });
    }
  }

  void _snapSheet(_SheetSize size) {
    if (!mounted || !_sheetCtrl.isAttached) return;

    final target = switch (size) {
      _SheetSize.collapsed => 0.10,
      _SheetSize.list => 0.36,
      _SheetSize.detail => 0.52,
      _SheetSize.full => 0.80,
    };
    _sheetCtrl.animateTo(
      target,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  Future<void> _goToMyLocation() async {
    if (!mounted) return;

    final permissionService = getIt<PermissionService>();
    final isGranted = await permissionService.requestLocation(context);

    if (!isGranted) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (!mounted) return;

      final userLat = position.latitude;
      final userLng = position.longitude;

      setState(() {
        _userLocation = LatLng(userLat, userLng);
      });

      _animatedMove(_userLocation!, 15);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể lấy vị trí: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VenueSearchCubit,
        BaseState<List<VenueSearchResultModel>>>(
      listener: (context, state) {
        if (state.isSuccess) {
          setState(() {
            _effectiveVenues = state.data ?? [];
          });
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _fitAllVenues();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F1923),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              _buildMap(),
              _buildTopFade(),
              SafeArea(child: _buildTopBar()),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: _buildSportChips(),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: MediaQuery.of(context).size.height * 0.40,
                child: _buildZoomButtons(),
              ),
              if (state.isLoading && _allVenues.isEmpty)
                const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryLightBrand),
                ),
              _buildBottomSheet(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: widget.initialZoom ?? _kInitialZoom,
        minZoom: 5,
        maxZoom: 19,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onTap: (_, __) {
          if (_selected != null) _clearSelection();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: _kOsmTile,
          userAgentPackageName: 'com.dat_san_247.app',
          tileProvider: NetworkTileProvider(),
          maxZoom: 19,
          errorTileCallback: (tile, err, _) {},
        ),
        if (_userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _userLocation!,
                width: 44,
                height: 44,
                child: const UserLocationMarker(),
              ),
            ],
          ),
        MarkerLayer(
          markers: _buildVenueMarkers(),
        ),
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
    return _filtered
        .where((v) => v.latitude != null && v.longitude != null)
        .map((v) {
      final isSelected = _selected?.id == v.id;
      return Marker(
        point: LatLng(v.latitude!, v.longitude!),
        width: isSelected ? 80 : 60,
        height: isSelected ? 80 : 60,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => _selectVenue(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: VenueMarker(
              venue: v,
              isSelected: isSelected,
              priceFmt: _priceFmt,
            ),
          ),
        ),
      );
    }).toList();
  }

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
          MapFloatBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              if (mounted) context.pop();
            },
          ),
          const SizedBox(width: 10),
          Expanded(
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
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF1A1F26)),
                      decoration: InputDecoration(
                        hintText: 'Tìm sân thể thao...',
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 14),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _selected = null;
                                  });
                                  _fitAllVenues();
                                },
                                child: Icon(Icons.close_rounded,
                                    size: 18, color: Colors.grey[400]),
                              )
                            : null,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                          _selected = null;
                        });
                        if (widget.venues.isEmpty) {
                          context.read<VenueSearchCubit>().searchVenues({
                            'keyword': _searchQuery,
                            if (_sportFilter != 'Tất cả')
                              'sport_type': _sportFilter,
                          });
                        } else {
                          _fitAllVenues();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryLightBrand.withValues(alpha: 0.12),
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
          const SizedBox(width: 10),
          MapFloatBtn(
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
              child: Center(
                child: Text(
                  sport,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? Colors.white : const Color(0xFF2C3E50),
                  ),
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
        MapFloatBtn(
          icon: Icons.add,
          onTap: () => _mapController.move(_mapController.camera.center,
              math.min(_mapController.camera.zoom + 1, 19)),
        ),
        const SizedBox(height: 8),
        MapFloatBtn(
          icon: Icons.remove,
          onTap: () => _mapController.move(_mapController.camera.center,
              math.max(_mapController.camera.zoom - 1, 5)),
        ),
        const SizedBox(height: 8),
        MapFloatBtn(
          icon: Icons.fit_screen_rounded,
          onTap: _fitAllVenues,
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      controller: _sheetCtrl,
      initialChildSize: 0.36,
      minChildSize: 0.10,
      maxChildSize: 0.80,
      snap: true,
      snapSizes: const [0.10, 0.36, 0.52, 0.80],
      builder: (context, scrollCtrl) {
        final header = Column(
          children: [
            MapDragHandle(onTap: () {
              if (!_sheetCtrl.isAttached) return;
              final s = _sheetCtrl.size;
              if (s < 0.25) {
                _snapSheet(_SheetSize.list);
              } else if (s < 0.45) {
                _snapSheet(_SheetSize.detail);
              } else if (s < 0.70) {
                _snapSheet(_SheetSize.full);
              } else {
                _snapSheet(_SheetSize.collapsed);
              }
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _selected != null
                            ? 'Chi tiết sân'
                            : '${_filtered.length} sân gần bạn',
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
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: Color(0xFF5A6A7D)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 24, offset: Offset(0, -4))
            ],
          ),
          child: _selected != null
              ? VenueDetailPanel(
                  key: ValueKey(_selected!.id),
                  venue: _selected!,
                  priceFmt: _priceFmt,
                  scrollCtrl: scrollCtrl,
                  header: header,
                  onBook: () {
                    if (mounted)
                      context.push('/venue-detail/${_selected!.slug}');
                  },
                )
              : VenueListPanel(
                  key: const ValueKey('list'),
                  venues: _filtered,
                  priceFmt: _priceFmt,
                  scrollCtrl: scrollCtrl,
                  header: header,
                  onTap: _selectVenue,
                ),
        );
      },
    );
  }
}
