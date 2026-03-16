import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/sport_category_model.dart';

class HomeSportCategories extends StatelessWidget {
  final List<SportCategoryModel> categories;
  final Function(SportCategoryModel) onCategorySelected;

  const HomeSportCategories({super.key, required this.categories, required this.onCategorySelected});

  IconData _getIconData(String? iconString) {
    switch (iconString) {
      case 'football': return Icons.sports_soccer_rounded;
      case 'badminton': return Icons.sports_tennis_rounded;
      case 'tennis': return Icons.sports_tennis_rounded;
      case 'basketball': return Icons.sports_basketball_rounded;
      case 'volleyball': return Icons.sports_volleyball_rounded;
      case 'swimming': return Icons.pool_rounded;
      case 'gym': return Icons.fitness_center_rounded;
      case 'billiard': return Icons.sports_handball_rounded;
      default: return Icons.sports_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Môn thể thao',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => onCategorySelected(category),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLightBrand.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryLightBrand.withOpacity(0.2)),
                      ),
                      child: Icon(
                        _getIconData(category.icon),
                        color: AppColors.primaryLightBrand,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
