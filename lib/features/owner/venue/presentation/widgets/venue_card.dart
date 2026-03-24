import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

class VenueCard extends StatelessWidget {
  final OwnerVenueModel venue;
  final Color brand;
  final VoidCallback onTap;
  final VoidCallback onToggleActive;
  const VenueCard({
    super.key,
    required this.venue,
    required this.brand,
    required this.onTap,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isApproved = venue.status == VenueStatus.APPROVED;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: venue.status == VenueStatus.REJECTED
                  ? AppColors.error.withOpacity(0.3)
                  : AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Thumbnail placeholder
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.stadium_rounded, color: brand, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                      child: Text(venue.name,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                  if (venue.isFeatured)
                    const Padding(padding: EdgeInsets.only(left: 4), child: Text('⭐', style: TextStyle(fontSize: 12))),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.location_on_rounded, size: 11, color: AppColors.textHint),
                  const SizedBox(width: 2),
                  Expanded(
                      child: Text('${venue.district}, ${venue.city}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 4),
                _StatusBadge(status: venue.status),
              ])),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: AppColors.borderLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textHint),
              ),
            ]),
          ),

          // ── Rejection reason ──
          if (venue.status == VenueStatus.REJECTED && venue.rejectionReason != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error.withOpacity(0.2))),
                child: Row(children: [
                  const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(venue.rejectionReason!,
                          style: const TextStyle(fontSize: 10, color: AppColors.error))),
                ]),
              ),
            ),

          const Divider(height: 1, color: AppColors.borderLight),

          // ── Stats row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: Row(children: [
              _InfoChip(
                  icon: Icons.sports_score_rounded, label: '${venue.courtCount} sân', color: brand),
              const SizedBox(width: 10),
              if (isApproved) ...[
                _InfoChip(
                    icon: Icons.star_rounded,
                    label: '${venue.rating.toStringAsFixed(1)} (${venue.totalReviews})',
                    color: AppColors.warning),
                const SizedBox(width: 10),
              ],
              ...venue.sportTypes.take(2).map(
                  (s) => Padding(padding: const EdgeInsets.only(right: 6), child: _SportTag(sport: s))),
              const Spacer(),
              // Active toggle
              GestureDetector(
                onTap: onToggleActive,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: venue.isActive && isApproved
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.borderLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: venue.isActive && isApproved ? AppColors.success : AppColors.textHint,
                            shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(venue.isActive && isApproved ? 'Đang mở' : 'Tạm đóng',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: venue.isActive && isApproved ? AppColors.success : AppColors.textHint)),
                  ]),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final VenueStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (status) {
      VenueStatus.APPROVED => (AppColors.success, Icons.verified_rounded, 'Đã duyệt'),
      VenueStatus.PENDING => (AppColors.warning, Icons.schedule_rounded, 'Chờ duyệt'),
      VenueStatus.REJECTED => (AppColors.error, Icons.cancel_rounded, 'Từ chối'),
      VenueStatus.SUSPENDED => (AppColors.error, Icons.block_rounded, 'Tạm khóa'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

class _SportTag extends StatelessWidget {
  final String sport;
  const _SportTag({required this.sport});

  String get emoji => switch (sport) {
        'FOOTBALL' => '⚽',
        'BADMINTON' => '🏸',
        'TENNIS' => '🎾',
        'BASKETBALL' => '🏀',
        'VOLLEYBALL' => '🏐',
        _ => '🏅'
      };

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            color: AppColors.borderLight.withOpacity(0.7), borderRadius: BorderRadius.circular(6)),
        child: Text(emoji, style: const TextStyle(fontSize: 11)),
      );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ]);
}
