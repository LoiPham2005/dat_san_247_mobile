import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/recurring_booking/data/models/recurring_booking_model.dart';

class RecurringBookingCard extends StatelessWidget {
  final RecurringBookingModel item;
  final void Function(RecurringBookingModel) onToggle;

  const RecurringBookingCard({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy');
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
        border: item.isActive
            ? Border.all(
                color: AppColors.primaryLightBrand.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isActive
                            ? AppColors.primaryLightBrand.withOpacity(0.1)
                            : AppColors.mutedLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.repeat_rounded,
                          color: item.isActive
                              ? AppColors.primaryLightBrand
                              : AppColors.textHint,
                          size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.venueName,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(item.courtName,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    _StatusBadge(isActive: item.isActive),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Repeat info ──
                Row(
                  children: [
                    _InfoPill(
                        icon: Icons.loop_rounded, label: item.repeatType.label),
                    const SizedBox(width: 8),
                    _InfoPill(
                        icon: Icons.access_time_rounded,
                        label: '${item.startTime}–${item.endTime}'),
                  ],
                ),

                if (item.repeatDays.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: item.repeatDays
                        .map((d) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLightBrand.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(d.label,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryLightBrand)),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.date_range_rounded,
                        size: 13, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      '${dateFmt.format(item.startDate)} → ${item.endDate != null ? dateFmt.format(item.endDate!) : 'Không giới hạn'}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    Text('${item.totalBookingsGenerated} lịch đã tạo',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
              ],
            ),
          ),

          // ── Actions ──
          const Divider(height: 1, color: AppColors.borderLight),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('📋 Xem chi tiết các lịch đã đặt'))),
                  icon: const Icon(Icons.list_alt_rounded,
                      size: 16, color: AppColors.primaryLightBrand),
                  label: const Text('Xem lịch',
                      style: TextStyle(
                          color: AppColors.primaryLightBrand, fontSize: 13)),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.borderLight),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => onToggle(item),
                  icon: Icon(
                    item.isActive
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    size: 16,
                    color: item.isActive
                        ? AppColors.error
                        : AppColors.primaryLightBrand,
                  ),
                  label: Text(
                    item.isActive ? 'Tạm dừng' : 'Kích hoạt',
                    style: TextStyle(
                        color: item.isActive
                            ? AppColors.error
                            : AppColors.primaryLightBrand,
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryLightBrand.withOpacity(0.1)
            : AppColors.mutedLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryLightBrand : AppColors.textHint,
                shape: BoxShape.circle,
              )),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Hoạt động' : 'Đã dừng',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color:
                    isActive ? AppColors.primaryLightBrand : AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.mutedLight, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
