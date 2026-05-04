import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/main/presentation/pages/main_shell_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_filter_params.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/providers/venue_search_notifier.dart';
import 'package:dat_san_247_mobile/routes/config/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/venue_filter_bottom_sheet.dart';
import '../widgets/venue_list_item.dart';

class VenueListPage extends HookConsumerWidget {
  final String? initialQuery;
  final String? initialDistrict;

  const VenueListPage({super.key, this.initialQuery, this.initialDistrict});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFeatured = initialQuery == 'featured';
    final query = isFeatured ? null : initialQuery;

    final searchController = useTextEditingController(text: query);
    final currentFilter = useState<VenueFilterParams>(
      VenueFilterParams(
        sportType: null,
        city: null,
        district: initialDistrict,
      ),
    );

    final state = ref.watch(venueSearchProvider);
    final notifier = ref.read(venueSearchProvider.notifier);

    useAsyncValueListener(provider: venueSearchProvider, ref: ref);

    void triggerSearch() {
      final filter = currentFilter.value;
      final params = <String, dynamic>{
        if (searchController.text.isNotEmpty) 'keyword': searchController.text,
        if (filter.sportType != null) 'sport_type': filter.sportType,
        if (filter.district != null) 'district': filter.district,
        if (filter.city != null) 'city': filter.city,
        if (filter.minPrice != null) 'price_min': filter.minPrice,
        if (filter.maxPrice != null) 'price_max': filter.maxPrice,
        if (filter.amenities.isNotEmpty) 'amenities': filter.amenities.join(','),
        if (isFeatured && searchController.text.isEmpty) 'is_featured': true,
      };
      notifier.searchVenues(params);
    }

    // Initial search trigger
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (initialQuery != null && !isFeatured) {
          triggerSearch();
        } else if (isFeatured) {
          notifier.searchVenues({'is_featured': true});
        } else if (initialDistrict != null) {
          triggerSearch();
        }
      });
      return null;
    }, const []);

    void showFilterBottomModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => VenueFilterBottomSheet(
          initialParams: currentFilter.value,
          onApply: (newFilter) {
            currentFilter.value = newFilter;
            triggerSearch();
          },
        ),
      );
    }

    final showBack = context.canPop() &&
        context.findAncestorWidgetOfExactType<MainShellPage>() == null;
    final venues = state.value ?? [];

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
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              )
            : null,
        title: _buildSearchInput(context, searchController, showBack, triggerSearch),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primaryLightBrand),
            onPressed: showFilterBottomModal,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChipsBar(currentFilter, triggerSearch),
          Expanded(child: _buildVenueList(context, state, notifier)),
        ],
      ),
      floatingActionButton: venues.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(RouteNames.venueMap, extra: venues),
              backgroundColor: AppColors.primaryLightBrand,
              icon: const Icon(Icons.map_rounded, color: AppColors.white),
              label: const Text(
                'Bản đồ',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget _buildSearchInput(
    BuildContext context,
    TextEditingController controller,
    bool showBack,
    VoidCallback onSearch,
  ) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: showBack ? 0 : 16, right: 8),
      decoration: BoxDecoration(
        color: AppColors.mutedLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        onTap: () async {
          final result = await context.push<String?>(
            '${RouteNames.venueSearch}?initialQuery=${Uri.encodeComponent(controller.text)}',
          );
          if (result != null) {
            controller.text = result;
            onSearch();
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

  Widget _buildFilterChipsBar(
    ValueNotifier<VenueFilterParams> currentFilter,
    VoidCallback onSearch,
  ) {
    final filter = currentFilter.value;
    final chips = <Widget>[];

    if (filter.sportType != null) {
      chips.add(_buildRemovableChip(filter.sportType!, () {
        currentFilter.value = filter.copyWith(sportType: null);
        onSearch();
      }));
    }
    if (filter.district != null) {
      chips.add(_buildRemovableChip(filter.district!, () {
        currentFilter.value = filter.copyWith(district: null);
        onSearch();
      }));
    }
    if (filter.minPrice != null || filter.maxPrice != null) {
      chips.add(_buildRemovableChip('Theo giá', () {
        currentFilter.value = filter.copyWith(minPrice: null, maxPrice: null);
        onSearch();
      }));
    }
    for (var am in filter.amenities) {
      chips.add(_buildRemovableChip(am, () {
        final newAm = List<String>.from(filter.amenities)..remove(am);
        currentFilter.value = filter.copyWith(amenities: newAm);
        onSearch();
      }));
    }

    if (chips.isEmpty) return const SizedBox(height: 12);

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
                  color: AppColors.primaryLightBrand,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded,
                size: 14, color: AppColors.primaryLightBrand),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueList(
    BuildContext context,
    AsyncValue state,
    VenueSearchNotifier notifier,
  ) {
    return switch (state) {
      AsyncData(:final value) when (value as List).isEmpty =>
        const Center(child: Text('Không tìm thấy sân phù hợp')),
      AsyncData(:final value) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: (value as List).length,
          itemBuilder: (context, index) {
            final venue = value[index];
            return VenueListItem(
              venue: venue,
              onTap: () => context.push('/venue-detail/${venue.slug}'),
              onFavoriteTap: () => notifier.toggleFavorite(venue.id),
            );
          },
        ),
      AsyncError(:final error) => Center(child: Text('$error')),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
