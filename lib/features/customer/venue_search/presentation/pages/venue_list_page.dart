import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_filter_params.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/cubit/venue_search_cubit.dart';
import 'package:dat_san_247_mobile/routes/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/venue_filter_bottom_sheet.dart';
import '../widgets/venue_list_item.dart';

class VenueListPage extends StatelessWidget {
  final String? initialQuery;
  final String? initialDistrict;

  const VenueListPage({super.key, this.initialQuery, this.initialDistrict});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VenueSearchCubit>()
        ..searchVenues({
          if (initialQuery != null && initialQuery != 'featured') 'keyword': initialQuery,
          if (initialQuery == 'featured') 'is_featured': true,
          if (initialDistrict != null) 'district': initialDistrict,
        }),
      child: _VenueListPageContent(initialQuery: initialQuery == 'featured' ? null : initialQuery, initialDistrict: initialDistrict, isFeatured: initialQuery == 'featured'),
    );
  }
}

class _VenueListPageContent extends StatefulWidget {
  final String? initialQuery;
  final String? initialDistrict;
  final bool isFeatured;

  const _VenueListPageContent({this.initialQuery, this.initialDistrict, this.isFeatured = false});

  @override
  State<_VenueListPageContent> createState() => _VenueListPageContentState();
}

class _VenueListPageContentState extends State<_VenueListPageContent> {
  late VenueFilterParams _currentFilter;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _currentFilter = VenueFilterParams(
      sportType: null,
      city: null,
      district: widget.initialDistrict,
    );
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  void _triggerSearch() {
    final Map<String, dynamic> params = {
      if (_searchController.text.isNotEmpty) 'keyword': _searchController.text,
      if (_currentFilter.sportType != null) 'sport_type': _currentFilter.sportType,
      if (_currentFilter.district != null) 'district': _currentFilter.district,
      if (_currentFilter.city != null) 'city': _currentFilter.city,
      if (_currentFilter.minPrice != null) 'price_min': _currentFilter.minPrice,
      if (_currentFilter.maxPrice != null) 'price_max': _currentFilter.maxPrice,
      if (_currentFilter.amenities.isNotEmpty) 'amenities': _currentFilter.amenities.join(','),
      if (widget.isFeatured && _searchController.text.isEmpty) 'is_featured': true,
    };

    context.read<VenueSearchCubit>().searchVenues(params);
  }

  void _showFilterBottomModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return VenueFilterBottomSheet(
          initialParams: _currentFilter,
          onApply: (newFilter) {
            setState(() {
              _currentFilter = newFilter;
            });
            _triggerSearch();
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
      floatingActionButton: BlocBuilder<VenueSearchCubit, BaseState<List<VenueSearchResultModel>>>(
        builder: (context, state) {
          final venues = state.data ?? [];
          if (venues.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              context.push(RouteNames.venueMap, extra: venues);
            },
            backgroundColor: AppColors.primaryLightBrand,
            icon: const Icon(Icons.map_rounded, color: AppColors.white),
            label: const Text(
              'Bản đồ',
              style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          );
        },
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
        onTap: () async {
          final result = await context.push<String?>(
            '${RouteNames.venueSearch}?initialQuery=${Uri.encodeComponent(_searchController.text)}',
          );
          if (result != null) {
            _searchController.text = result;
            _triggerSearch();
          }
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

    if (_currentFilter.sportType != null) {
      chips.add(
        _buildRemovableChip(_currentFilter.sportType!, () {
          setState(() => _currentFilter = _currentFilter.copyWith(sportType: null));
          _triggerSearch();
        }),
      );
    }
    if (_currentFilter.district != null) {
      chips.add(
        _buildRemovableChip(_currentFilter.district!, () {
          setState(() => _currentFilter = _currentFilter.copyWith(district: null));
          _triggerSearch();
        }),
      );
    }
    if (_currentFilter.minPrice != null || _currentFilter.maxPrice != null) {
      chips.add(
        _buildRemovableChip('Theo giá', () {
          setState(() => _currentFilter = _currentFilter.copyWith(minPrice: null, maxPrice: null));
          _triggerSearch();
        }),
      );
    }
    for (var am in _currentFilter.amenities) {
      chips.add(
        _buildRemovableChip(am, () {
          final newAm = List<String>.from(_currentFilter.amenities)..remove(am);
          setState(() => _currentFilter = _currentFilter.copyWith(amenities: newAm));
          _triggerSearch();
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
          Text(label,
              style: const TextStyle(
                  color: AppColors.primaryLightBrand, fontSize: 13, fontWeight: FontWeight.bold)),
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
    return BlocBuilder<VenueSearchCubit, BaseState<List<VenueSearchResultModel>>>(
      builder: (context, state) {
        return state.whenReady(
          loading: (data) => const Center(child: CircularProgressIndicator()),
          success: (venues, message) {
            if (venues.isEmpty) {
              return const Center(child: Text('Không tìm thấy sân phù hợp'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return VenueListItem(
                  venue: venue,
                  onTap: () {
                    context.push('/venue-detail/${venue.slug}');
                  },
                  onFavoriteTap: () {
                    context.read<VenueSearchCubit>().toggleFavorite(venue.id);
                  },
                );
              },
            );
          },
          failure: (error, data) => Center(child: Text(error)),
          empty: (message) => const Center(child: Text('Chưa có kết quả')),
        );
      },
    );
  }
}
