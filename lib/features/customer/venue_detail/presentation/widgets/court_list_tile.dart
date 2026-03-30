import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import '../../data/models/court_model.dart';
import 'package:intl/intl.dart';

class CourtListTile extends StatelessWidget {
  final CourtModel court;
  final VoidCallback onTapBooking;

  const CourtListTile({
    super.key,
    required this.court,
    required this.onTapBooking,
  });

  @override
  Widget build(BuildContext context) {
    if (!court.isActive) return const SizedBox.shrink();

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTapBooking,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Court image
              Container(
                width: 100,
                height: 122,
                color: AppColors.mutedLight,
                child:
                    court.thumbnailUrl != null && court.thumbnailUrl!.isNotEmpty
                        ? Image.network(
                            court.thumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image_rounded,
                                color: AppColors.mutedForegroundLight),
                          )
                        : const Icon(Icons.sports_soccer_rounded,
                            size: 40, color: AppColors.mutedForegroundLight),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              court.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryLightBrand.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Đang rảnh',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryLightBrand,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Format and Type
                      Row(
                        children: [
                          Icon(
                            court.isIndoor
                                ? Icons.roofing_rounded
                                : Icons.wb_sunny_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            court.isIndoor ? 'Sân trong nhà' : 'Sân ngoài trời',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 12),
                          if (court.surfaceType != null) ...[
                            const Icon(Icons.terrain_rounded,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              court.surfaceType ==
                                      CourtSurfaceType.artificialGrass
                                  ? 'Cỏ nhân tạo'
                                  : court.surfaceType == CourtSurfaceType.grass
                                      ? 'Cỏ tự nhiên'
                                      : 'Khác',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Price and Booking
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Từ ${currencyFormat.format(court.pricePerHour)}/h',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDarkBrand,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: onTapBooking,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLightBrand,
                              foregroundColor: AppColors.white,
                              minimumSize: const Size(60, 32),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: const Text('Đặt ngay',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
