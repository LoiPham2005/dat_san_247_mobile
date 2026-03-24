import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/venue/data/models/venue_models.dart';

class CourtCard extends StatelessWidget {
  final OwnerCourtModel court;
  final Color brand;
  final VoidCallback onTap;
  final VoidCallback onToggleActive;
  final VoidCallback onPricing;
  final VoidCallback? onReorder;

  const CourtCard({
    super.key,
    required this.court,
    required this.brand,
    required this.onTap,
    required this.onToggleActive,
    required this.onPricing,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: court.isActive ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: court.isActive
                    ? AppColors.borderLight
                    : AppColors.borderLight.withOpacity(0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Order badge
              Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: brand.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text('#${court.displayOrder}',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold, color: brand)))),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                      child: Text(court.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900))),
                  if (court.isIndoor)
                    Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Text('🏠 Trong nhà',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.info))),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  if (court.surfaceType != null)
                    Text(court.surfaceType!.label,
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                  if (court.size != null) ...[
                    const Text(' · ', style: TextStyle(color: AppColors.textHint, fontSize: 10)),
                    Text(court.size!, style: const TextStyle(fontSize: 10, color: AppColors.textHint))
                  ],
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  ...court.sportTypes.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(_sportEmoji(s), style: const TextStyle(fontSize: 13)))),
                ]),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(_fmtPrice(court.pricePerHour),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: brand)),
                const Text('/giờ', style: TextStyle(fontSize: 9, color: AppColors.textHint)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onToggleActive,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: court.isActive
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.borderLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: court.isActive ? AppColors.success : AppColors.textHint,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(court.isActive ? 'Bật' : 'Tắt',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: court.isActive ? AppColors.success : AppColors.textHint)),
                    ]),
                  ),
                ),
              ]),
            ]),
            if (court.amenities.isNotEmpty) ...[
              const Divider(height: 10, color: AppColors.borderLight),
              Row(children: [
                const Icon(Icons.check_circle_outline_rounded, size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(court.amenities.map((a) => a.name).join(' · '),
                        style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
              ]),
            ],
            const Divider(height: 10, color: AppColors.borderLight),
            Row(children: [
              _ActionBtn(
                  icon: Icons.price_change_rounded,
                  label: 'Bảng giá',
                  onTap: onPricing,
                  color: AppColors.warning),
              if (onReorder != null) ...[
                const SizedBox(width: 8),
                _ActionBtn(
                    icon: Icons.swap_vert_rounded,
                    label: 'Đổi thứ tự',
                    onTap: onReorder!,
                    color: AppColors.textHint),
              ],
              const Spacer(),
              _ActionBtn(icon: Icons.edit_rounded, label: 'Sửa', onTap: onTap, color: brand),
            ]),
          ]),
        ),
      ),
    );
  }

  String _sportEmoji(String sport) => switch (sport) {
        'FOOTBALL' => '⚽',
        'BADMINTON' => '🏸',
        'TENNIS' => '🎾',
        'BASKETBALL' => '🏀',
        _ => '🏅'
      };
  String _fmtPrice(double v) {
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _ActionBtn(
      {required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration:
              BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ]),
        ),
      );
}
