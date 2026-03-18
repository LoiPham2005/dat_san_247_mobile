import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/court_model.dart'; // Contains AmenityModel

class AmenitiesGrid extends StatelessWidget {
  final List<AmenityModel> amenities;

  const AmenitiesGrid({super.key, required this.amenities});

  IconData _getIconData(String? iconName) {
    if (iconName == null) return Icons.check_circle_outline_rounded;
    switch (iconName.toLowerCase()) {
      case 'wifi': return Icons.wifi_rounded;
      case 'parking': return Icons.local_parking_rounded;
      case 'water': return Icons.water_drop_rounded;
      case 'store': return Icons.storefront_rounded;
      case 'ball': return Icons.sports_soccer_rounded;
      case 'jersey': return Icons.checkroom_rounded;
      case 'shower': return Icons.shower_rounded;
      case 'toilet': return Icons.wc_rounded;
      default: return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiện ích',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: amenities.map((amenity) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.borderLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconData(amenity.icon),
                    size: 18,
                    color: AppColors.primaryLightBrand,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    amenity.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (!amenity.isFree) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
