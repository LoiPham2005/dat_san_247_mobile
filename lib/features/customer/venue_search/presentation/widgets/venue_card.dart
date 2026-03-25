import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';

class VenueCard extends StatelessWidget {
  final VenueSearchResultModel venue;
  final NumberFormat priceFmt;
  final VoidCallback onTap;

  const VenueCard({
    super.key,
    required this.venue,
    required this.priceFmt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = venue.isOpen ?? true;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBF0F5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: venue.thumbnailUrl != null
                  ? Image.network(
                      venue.thumbnailUrl!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ImgPlaceholder(height: 72, width: 72),
                    )
                  : const ImgPlaceholder(height: 72, width: 72),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên + badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(venue.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A2332)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 4),
                      StatusBadge(isOpen: isOpen, small: true),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Địa chỉ
                  Text(venue.address,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7A8FA6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  // Sports
                  Wrap(
                    spacing: 4,
                    children: venue.sportTypes
                        .take(2)
                        .map((s) => SportTag(label: s, small: true))
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                  // Rating + giá
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFB800)),
                      const SizedBox(width: 3),
                      Text('${venue.rating}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2332))),
                      const Spacer(),
                      Text(
                        venue.minPricePerHour != null
                            ? '${priceFmt.format(venue.minPricePerHour)}đ/h'
                            : '---',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLightBrand),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImgPlaceholder extends StatelessWidget {
  final double height;
  final double? width;
  const ImgPlaceholder({super.key, required this.height, this.width});

  @override
  Widget build(BuildContext context) => Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF2F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
            child: Icon(Icons.image_not_supported_rounded, color: Color(0xFFBCC6D1), size: 28)),
      );
}

class StatusBadge extends StatelessWidget {
  final bool isOpen;
  final bool small;
  const StatusBadge({super.key, required this.isOpen, this.small = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: small ? 6 : 10, vertical: small ? 2 : 5),
        decoration: BoxDecoration(
          color: isOpen ? const Color(0xFFE8FBF7) : const Color(0xFFFFF0EE),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          isOpen ? (small ? 'Mở' : 'Đang mở') : 'Đã đóng',
          style: TextStyle(
            fontSize: small ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: isOpen ? const Color(0xFF00A885) : const Color(0xFFE05252),
          ),
        ),
      );
}

class SportTag extends StatelessWidget {
  final String label;
  final bool small;
  const SportTag({super.key, required this.label, this.small = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: small ? 6 : 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FBF9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFB8EDE5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: small ? 11 : 12,
            color: AppColors.primaryLightBrand,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
