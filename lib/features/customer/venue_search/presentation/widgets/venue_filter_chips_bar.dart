import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:flutter/material.dart';
import '../../data/models/venue_filter_params.dart';

class VenueFilterChipsBar extends StatelessWidget {
  final VenueFilterParams filter;
  final Function(VenueFilterParams) onFilterChanged;

  const VenueFilterChipsBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = [];

    // Convert filter object to chips
    if (filter.sportType != null) {
      chips.add(
        _buildRemovableChip(filter.sportType!, () {
          onFilterChanged(filter.copyWith(sportType: null));
        }),
      );
    }
    if (filter.district != null) {
      chips.add(
        _buildRemovableChip(filter.district!, () {
          onFilterChanged(filter.copyWith(district: null));
        }),
      );
    }
    if (filter.minPrice != null || filter.maxPrice != null) {
      chips.add(
        _buildRemovableChip('Theo giá', () {
          onFilterChanged(filter.copyWith(minPrice: null, maxPrice: null));
        }),
      );
    }
    for (var am in filter.amenities) {
      chips.add(
        _buildRemovableChip(am, () {
          final newAm = List<String>.from(filter.amenities)..remove(am);
          onFilterChanged(filter.copyWith(amenities: newAm));
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
}
