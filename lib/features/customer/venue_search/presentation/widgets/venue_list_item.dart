import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'package:intl/intl.dart';

class VenueListItem extends StatelessWidget {
  final VenueSearchResultModel venue;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const VenueListItem({
    super.key,
    required this.venue,
    required this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final String priceStr = venue.minPricePerHour != null
        ? 'Từ ${currencyFormat.format(venue.minPricePerHour)}/h'
        : 'Đang cập nhật giá';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.mutedLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                    const Center(child: Icon(Icons.image_not_supported_rounded, color: AppColors.textHint, size: 48)),
                  
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
                  
                  // Favorite Button
                   Positioned(
                      top: 12,
                      right: 12,
                      child: InkWell(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            venue.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: venue.isFavorite ? Colors.red : AppColors.textHint,
                            size: 20,
                          ),
                        ),
                      ),
                   ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Rating badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              venue.rating.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.textHint, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${venue.address}, ${venue.district}, ${venue.city}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Sport Types
                  if (venue.sportTypes.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: venue.sportTypes.map((sport) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightBrand.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primaryLightBrand.withOpacity(0.2)),
                          ),
                          child: Text(
                            sport,
                            style: const TextStyle(color: AppColors.primaryLightBrand, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderLight),
                  const SizedBox(height: 12),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          priceStr,
                          style: const TextStyle(
                            color: AppColors.primaryLightBrand,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Text(
                        'Xem sân',
                        style: TextStyle(color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.primaryLightBrand, size: 20),
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
