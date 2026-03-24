import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/data/models/pricing_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/system_notification_channel_badge.dart';

class SystemNotificationCard extends StatelessWidget {
  final StaffSystemNotificationModel notif;
  final VoidCallback onTap;
  const SystemNotificationCard({super.key, required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _style;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : color.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: notif.isRead ? AppColors.borderLight : color.withOpacity(0.25)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (!notif.isRead)
                Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              Expanded(
                  child: Text(notif.title,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 6),
              SystemNotificationChannelBadge(channel: notif.channel),
            ]),
            const SizedBox(height: 3),
            Text(notif.message,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Text(notif.type.label,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
              const Text(' · ', style: TextStyle(color: AppColors.textHint, fontSize: 9)),
              Text(_relTime, style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
            ]),
          ])),
        ]),
      ),
    );
  }

  (Color, IconData) get _style => switch (notif.type) {
        StaffSystemNotifType.BOOKING_CONFIRMED => (AppColors.success, Icons.event_available_rounded),
        StaffSystemNotifType.BOOKING_CANCELLED => (AppColors.error, Icons.event_busy_rounded),
        StaffSystemNotifType.BOOKING_REMINDER => (const Color(0xFF7C3AED), Icons.schedule_rounded),
        StaffSystemNotifType.PAYMENT_SUCCESS => (AppColors.success, Icons.payment_rounded),
        StaffSystemNotifType.NEW_REVIEW => (AppColors.warning, Icons.star_rounded),
        StaffSystemNotifType.MAINTENANCE_ALERT => (AppColors.error, Icons.build_rounded),
        StaffSystemNotifType.SYSTEM_ANNOUNCEMENT => (AppColors.info, Icons.campaign_rounded),
        StaffSystemNotifType.SHIFT_REMINDER => (const Color(0xFF7C3AED), Icons.work_history_rounded),
      };

  String get _relTime {
    final diff = DateTime.now().difference(notif.createdAt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes}p trước';
    if (diff.inHours < 24) return '${diff.inHours}h trước';
    return '${diff.inDays}d trước';
  }
}
