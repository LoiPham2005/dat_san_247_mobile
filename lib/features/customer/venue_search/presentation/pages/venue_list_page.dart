import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_filter_params.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/venue_filter_bottom_sheet.dart';
import '../widgets/venue_list_item.dart';

class VenueListPage extends StatefulWidget {
  final String? initialQuery;
  final String? initialDistrict;

  const VenueListPage({super.key, this.initialQuery, this.initialDistrict});

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  late VenueFilterParams _currentFilter;
  final TextEditingController _searchController = TextEditingController();

  final List<VenueSearchResultModel> _mockVenues = [
    const VenueSearchResultModel(
      id: '1',
      name: 'Sân bóng đá KTX Bách Khoa',
      slug: 'san-bong-da-ktx-bach-khoa',
      address: '497 Hòa Hảo',
      city: 'TP.HCM',
      district: 'Quận 10',
      thumbnailUrl: null,
      rating: 4.8,
      totalReviews: 120,
      minPricePerHour: 150000,
      sportTypes: ['FOOTBALL'],
      amenities: ['WIFI', 'Bãi xe Ô tô', 'Tủ đồ'],
      isFeatured: true,
      isFavorite: false,
      latitude: 10.762622,
      longitude: 106.660172,
    ),
    const VenueSearchResultModel(
      id: '2',
      name: 'Sân cầu lông Kỳ Hòa',
      slug: 'san-cau-long-ky-hoa',
      address: '16A Lê Hồng Phong',
      city: 'TP.HCM',
      district: 'Quận 10',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1549721067-15efba51ebce?q=80&w=400&auto=format&fit=crop',
      rating: 4.5,
      totalReviews: 85,
      minPricePerHour: 80000,
      sportTypes: ['BADMINTON'],
      amenities: ['WIFI', 'Căng tin'],
      isFeatured: false,
      isFavorite: true,
      latitude: 10.7769,
      longitude: 106.7009,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentFilter = VenueFilterParams(
      sportType: null,
      city: null,
      district: widget.initialDistrict,
    );
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
  }

  void _showFilterBottomModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return VenueFilterBottomSheet(
          initialParams: _currentFilter,
          onApply: (newFilter) {
            setState(() {
              _currentFilter = newFilter;
              // REFETCH DATA based on new filter + current query
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showBack =
        context.canPop() && context.findAncestorWidgetOfExactType<MainShellPage>() == null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: showBack,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              )
            : null,
        title: _buildSearchInput(showBack),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primaryLightBrand),
            onPressed: _showFilterBottomModal,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChipsBar(),
          Expanded(child: _buildVenueList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RouteNames.venueMap, extra: _mockVenues);
        },
        backgroundColor: AppColors.primaryLightBrand,
        icon: const Icon(Icons.map_rounded, color: AppColors.white),
        label: const Text(
          'Bản đồ',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSearchInput(bool showBack) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: showBack ? 0 : 16, right: 8),
      decoration: BoxDecoration(
        color: AppColors.mutedLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        onTap: () {
          context.push(
              '${RouteNames.venueSearch}?initialQuery=${Uri.encodeComponent(_searchController.text)}');
        },
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Tìm kiếm sân...',
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }

  Widget _buildFilterChipsBar() {
    final List<Widget> chips = [];

    // Convert filter object to chips
    if (_currentFilter.sportType != null) {
      chips.add(
        _buildRemovableChip(_currentFilter.sportType!, () {
          setState(() => _currentFilter = _currentFilter.copyWith(sportType: null));
        }),
      );
    }
    if (_currentFilter.district != null) {
      chips.add(
        _buildRemovableChip(_currentFilter.district!, () {
          setState(() => _currentFilter = _currentFilter.copyWith(district: null));
        }),
      );
    }
    if (_currentFilter.minPrice != null || _currentFilter.maxPrice != null) {
      chips.add(
        _buildRemovableChip('Theo giá', () {
          setState(() => _currentFilter = _currentFilter.copyWith(minPrice: null, maxPrice: null));
        }),
      );
    }
    for (var am in _currentFilter.amenities) {
      chips.add(
        _buildRemovableChip(am, () {
          final newAm = List<String>.from(_currentFilter.amenities)..remove(am);
          setState(() => _currentFilter = _currentFilter.copyWith(amenities: newAm));
        }),
      );
    }

    if (chips.isEmpty) {
      return const SizedBox(height: 12);
    }

    return Container(
      height: 50,
      color: AppColors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }

  Widget _buildRemovableChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBrand.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLightBrand.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryLightBrand,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 14, color: AppColors.primaryLightBrand),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueList() {
    if (_mockVenues.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy sân phù hợp', style: TextStyle(color: AppColors.textHint)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockVenues.length,
      itemBuilder: (context, index) {
        final venue = _mockVenues[index];
        return VenueListItem(
          venue: venue,
          onTap: () {
            GoRouter.of(context).push('/venue-detail/${venue.id}');
          },
          onFavoriteTap: () {
            // Toggle favorite API
            setState(() {
              // mock toggle
            });
          },
        );
      },
    );
  }
}
