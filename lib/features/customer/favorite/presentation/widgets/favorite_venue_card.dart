import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/favorite/data/models/favorite_venue_model.dart';

class FavoriteVenueCard extends StatelessWidget {
  final FavoriteVenueModel fav;
  final VoidCallback onRemove;
  final VoidCallback onBook;

  const FavoriteVenueCard({
    super.key,
    required this.fav,
    required this.onRemove,
    required this.onBook,
  });

  FavoriteVenueDetail get detail => fav.venue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // ── Thumbnail ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: detail.thumbnailUrl != null
                      ? Image.network(detail.thumbnailUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder())
                      : _placeholder(),
                ),
                // ── Gradient overlay ──
                Positioned.fill(
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withOpacity(0.4)
                      ],
                    ),
                  )),
                ),
                // ── Top right: remove ──
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                          color: AppColors.error, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_rounded,
                          color: AppColors.white, size: 18),
                    ),
                  ),
                ),
                // ── Bottom left: rating ──
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Row(children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.warning, size: 15),
                    const SizedBox(width: 3),
                    Text('${detail.averageRating}',
                        style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    const SizedBox(width: 4),
                    Text('(${detail.reviewCount})',
                        style: const TextStyle(
                            color: AppColors.white70, fontSize: 11)),
                  ]),
                ),
                // ── Bottom right: sport types ──
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: detail.sports
                          .take(2)
                          .map((s) => Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(_sportLabel(s),
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ))
                          .toList()),
                ),
              ],
            ),
          ),
          // ── Info ──
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.location_on_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(detail.address,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Đặt sân',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.mutedLight,
        child: const Center(
            child: Icon(Icons.sports_soccer_rounded,
                size: 40, color: AppColors.primaryLightBrand)),
      );

  String _sportLabel(String sport) {
    switch (sport.toUpperCase()) {
      case 'FOOTBALL':
        return '⚽';
      case 'FUTSAL':
        return '🥅';
      case 'BADMINTON':
        return '🏸';
      case 'PICKLEBALL':
        return '🏓';
      case 'TENNIS':
        return '🎾';
      default:
        return sport.substring(0, sport.length.clamp(0, 3));
    }
  }
}
