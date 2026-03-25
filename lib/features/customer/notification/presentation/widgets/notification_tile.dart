import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/notification/data/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ct = _notifColor(notif.type);
    final timeLabel = _timeAgo(notif.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.white : ct.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border:
              notif.isRead ? null : Border.all(color: ct.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(color: AppColors.black.withOpacity(0.03), blurRadius: 6)
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: ct.withOpacity(0.12), shape: BoxShape.circle),
              child:
                  Center(child: Text(notif.type.icon, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  notif.isRead ? FontWeight.w500 : FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(timeLabel,
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textHint)),
                          if (!notif.isRead) ...[
                            const SizedBox(height: 4),
                            Container(
                                width: 8,
                                height: 8,
                                decoration:
                                    BoxDecoration(color: ct, shape: BoxShape.circle)),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notif.message,
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            notif.isRead ? AppColors.textHint : AppColors.textSecondary,
                        height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _notifColor(NotificationType t) {
    switch (t) {
      case NotificationType.BOOKING_CONFIRMED:
        return AppColors.primaryLightBrand;
      case NotificationType.BOOKING_CANCELLED:
        return AppColors.error;
      case NotificationType.BOOKING_REMINDER:
        return AppColors.warning;
      case NotificationType.PAYMENT_SUCCESS:
        return AppColors.success;
      case NotificationType.PAYMENT_FAILED:
        return AppColors.error;
      case NotificationType.REVIEW_RESPONSE:
        return AppColors.warning;
      case NotificationType.WAITLIST_AVAILABLE:
        return AppColors.info;
      case NotificationType.PROMOTION:
        return const Color(0xFFAD1457);
      case NotificationType.SYSTEM:
        return AppColors.textHint;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    if (diff.inDays < 7) return '${diff.inDays} ngày';
    return DateFormat('dd/MM').format(dt);
  }
}
