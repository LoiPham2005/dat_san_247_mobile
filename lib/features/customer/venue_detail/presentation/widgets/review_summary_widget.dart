import 'package:flutter/material.dart';
import '../../data/models/venue_detail_model.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final VenueDetailModel venue;
  final VoidCallback onViewAll;

  const ReviewSummaryWidget({super.key, required this.venue, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    if (venue.totalReviews == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Đánh giá',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text(
                'Xem tất cả',
                style: TextStyle(color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Overall rating number
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      venue.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.warning,
                        height: 1.1,
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        Icon(Icons.star_half_rounded, color: AppColors.warning, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${venue.totalReviews} lượt',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Category Progress bars
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _RatingBar(label: 'Sạch sẽ', rating: venue.ratingCleanliness),
                    const SizedBox(height: 8),
                    _RatingBar(label: 'Cơ sở vật chất', rating: venue.ratingFacilities),
                    const SizedBox(height: 8),
                    _RatingBar(label: 'Nhân viên', rating: venue.ratingStaff),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double rating;

  const _RatingBar({required this.label, required this.rating});

  @override
  Widget build(BuildContext context) {
    final double percentage = (rating / 5.0).clamp(0.0, 1.0);
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightBrand,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
