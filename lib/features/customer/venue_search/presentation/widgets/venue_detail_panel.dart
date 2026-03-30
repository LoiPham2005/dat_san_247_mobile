import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/data/models/venue_search_result_model.dart';
import 'venue_card.dart';

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
                      errorBuilder: (_, __, ___) =>
                          const ImgPlaceholder(height: 180),
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
                  children:
                      venue.sportTypes.map((s) => SportTag(label: s)).toList(),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5FDFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCCEFE8)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payments_rounded,
                          size: 20, color: AppColors.primaryLightBrand),
                      const SizedBox(width: 10),
                      const Text('Giá từ',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF5A6A7D))),
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

                // ── Danh sách bề mặt sân (Clickable to view schedule) ─────────────
                InkWell(
                  onTap: isOpen ? onBook : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Expanded(
                          child: _InfoRow(
                            icon: Icons.stadium_rounded,
                            text: 'Số lượng sân: 4 sân',
                            color: Color(0xFF1B2533),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Tiện ích đi kèm ──────────────────────────────────────────────
                const Text(
                  'Tiện ích đi kèm',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: (venue.amenities.isNotEmpty
                          ? venue.amenities
                          : ['ggggg', 'hhhhhhhh', 'mhj'])
                      .map((a) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_rounded,
                                  size: 16, color: Color(0xFF0D9488)),
                              const SizedBox(width: 8),
                              Text(
                                a,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 30),

                // ── Buttons ─────────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isOpen ? onBook : null,
                    icon: const Icon(Icons.calendar_month_rounded, size: 17),
                    label: const Text('Đặt sân ngay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLightBrand,
                      disabledBackgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
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
            child: Text(text,
                style: const TextStyle(fontSize: 13, color: Color(0xFF5A6A7D))),
          ),
        ],
      );
}
