import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'venue_card.dart';
import 'time_slot_grid.dart';

class VenueDetailPanel extends StatelessWidget {
  final VenueSearchResultModel venue;
  final NumberFormat priceFmt;
  final ScrollController scrollCtrl;
  final VoidCallback onBook;

  final Widget? header;

  const VenueDetailPanel({
    super.key,
    required this.venue,
    required this.priceFmt,
    required this.scrollCtrl,
    required this.onBook,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = venue.isOpen ?? true;
    return SingleChildScrollView(
      controller: scrollCtrl,
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header!,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          // ── Ảnh ────────────────────────────────────────────────────────
          if (venue.thumbnailUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                venue.thumbnailUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ImgPlaceholder(height: 180),
              ),
            )
          else
            const ImgPlaceholder(height: 180),
          const SizedBox(height: 16),

          // ── Tên + badge ─────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  venue.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A2332),
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(isOpen: isOpen),
            ],
          ),
          const SizedBox(height: 8),

          // ── Sport tags ──────────────────────────────────────────────────
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: venue.sportTypes.map((s) => SportTag(label: s)).toList(),
          ),
          const SizedBox(height: 12),

          // ── Address ─────────────────────────────────────────────────────
          _InfoRow(
            icon: Icons.location_on_rounded,
            text: venue.address,
            color: AppColors.primaryLightBrand,
          ),
          const SizedBox(height: 6),

          // ── Rating ──────────────────────────────────────────────────────
          _InfoRow(
            icon: Icons.star_rounded,
            text: '${venue.rating}  ·  ${venue.totalReviews} đánh giá',
            color: const Color(0xFFFFB800),
          ),
          const SizedBox(height: 18),

          // ── Price card ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5FDFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCCEFE8)),
            ),
            child: Row(
              children: [
                const Icon(Icons.payments_rounded, size: 20, color: AppColors.primaryLightBrand),
                const SizedBox(width: 10),
                const Text('Giá từ', style: TextStyle(fontSize: 14, color: Color(0xFF5A6A7D))),
                const Spacer(),
                Text(
                  venue.minPricePerHour != null
                      ? '${priceFmt.format(venue.minPricePerHour)}đ / giờ'
                      : '---',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryLightBrand,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Khung giờ trống hôm nay (mock) ─────────────────────────────
          const Text(
            'Khung giờ còn trống hôm nay',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2332),
            ),
          ),
          const SizedBox(height: 10),
          TimeSlotGrid(isOpen: isOpen),
          const SizedBox(height: 24),

          // ── Buttons ─────────────────────────────────────────────────────
          Row(
            children: [
              // Xem đánh giá
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.rate_review_rounded, size: 17),
                  label: const Text('Đánh giá'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLightBrand,
                    side: const BorderSide(color: AppColors.primaryLightBrand),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Đặt sân
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: isOpen ? onBook : null,
                  icon: const Icon(Icons.calendar_month_rounded, size: 17),
                  label: const Text('Đặt sân ngay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    disabledBackgroundColor: Colors.grey[300],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A6A7D))),
          ),
        ],
      );
}
