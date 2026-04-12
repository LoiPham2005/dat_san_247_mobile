import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/waitlist/data/models/waitlist_model.dart';

class WaitlistCard extends StatelessWidget {
  final WaitlistModel item;
  final VoidCallback? onCancel;

  const WaitlistCard({
    super.key,
    required this.item,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEE, dd/MM', 'vi_VN');
    final (statusColor, statusBg, statusLabel) = _statusStyle(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.status == WaitlistStatus.WAITING || item.status == WaitlistStatus.NOTIFIED
                        ? AppColors.primaryLightBrand
                        : AppColors.mutedLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('#${item.priority}',
                        style: TextStyle(
                          color: item.status == WaitlistStatus.WAITING || item.status == WaitlistStatus.NOTIFIED
                              ? AppColors.white
                              : AppColors.textHint,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.venueName,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(item.courtName,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _WaitlistChip(
                              icon: Icons.event_rounded,
                              label: dateFmt.format(item.bookingDate)),
                          const SizedBox(width: 6),
                          _WaitlistChip(
                              icon: Icons.access_time_rounded,
                              label: '${item.startTime}–${item.endTime}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: statusBg, borderRadius: BorderRadius.circular(20)),
                      child: Text(statusLabel,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor)),
                    ),
                    if (item.status == WaitlistStatus.NOTIFIED) ...[
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_active_rounded,
                              size: 12, color: AppColors.primaryLightBrand),
                          SizedBox(width: 2),
                          Text('Đã có sân!',
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (onCancel != null && item.status == WaitlistStatus.WAITING) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            TextButton(
              onPressed: onCancel,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_circle_outline_rounded,
                      size: 15, color: AppColors.error),
                  SizedBox(width: 4),
                  Text('Hủy khỏi danh sách chờ',
                      style: TextStyle(color: AppColors.error, fontSize: 13)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  (Color, Color, String) _statusStyle(WaitlistStatus s) {
    switch (s) {
      case WaitlistStatus.WAITING:
        return (
          AppColors.warning,
          AppColors.warning.withOpacity(0.12),
          '⏳ Đang chờ'
        );
      case WaitlistStatus.NOTIFIED:
        return (
          AppColors.primaryLightBrand,
          AppColors.primaryLightBrand.withOpacity(0.12),
          '📢 Có sân'
        );
      case WaitlistStatus.BOOKED:
        return (AppColors.success, AppColors.success.withOpacity(0.1), '✅ Đã đặt');
      case WaitlistStatus.EXPIRED:
        return (AppColors.textHint, AppColors.mutedLight, '⌛ Hết hạn');
      case WaitlistStatus.CANCELLED:
        return (AppColors.error, AppColors.error.withOpacity(0.08), '❌ Đã hủy');
    }
  }
}

class _WaitlistChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WaitlistChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textHint),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      );
}
