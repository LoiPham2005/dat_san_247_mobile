import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/shared/venue/data/models/venue_model.dart';


class HomeFeaturedVenues extends StatelessWidget {
  final String title;
  final List<VenueModel> venues;
  final Function(VenueModel) onVenueTap;
  final Function(VenueModel) onFavoriteTap;
  final VoidCallback onViewAllTap;

  const HomeFeaturedVenues({
    super.key,
    this.title = 'Sân nổi bật',
    required this.venues,
    required this.onVenueTap,
    required this.onFavoriteTap,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onViewAllTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: venues.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final venue = venues[index];
              return _buildVenueCard(context, venue);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVenueCard(BuildContext context, VenueModel venue) {
    return GestureDetector(
      onTap: () => onVenueTap(venue),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: AppColors.mutedLight,
                image: venue.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(venue.thumbnailUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (venue.thumbnailUrl == null)
                    const Center(child: Icon(Icons.stadium_rounded, size: 48, color: AppColors.textHint)),
                  // Featured Badge
                  if (venue.isFeatured)
                     Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.whatshot_rounded, color: AppColors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Nổi bật', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => onFavoriteTap(venue),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          venue.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: venue.isFavorite ? AppColors.destructiveLight : AppColors.textHint,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            venue.rating.toStringAsFixed(1),
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.textHint, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${venue.district}, ${venue.city}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                         // Dummy Price here, we might need a min_price field but it's not in VenueSchema directly
                        'Từ 150.000đ/h',
                        style: TextStyle(
                          color: AppColors.primaryLightBrand,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
