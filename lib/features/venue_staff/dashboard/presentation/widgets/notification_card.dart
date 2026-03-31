import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

class NotificationCard extends StatelessWidget {
  final StaffNotificationModel notif;
  final VoidCallback onTap;
  const NotificationCard({super.key, required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _typeStyle;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: notif.isRead ? AppColors.borderLight : color.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (!notif.isRead)
                Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              Expanded(
                  child: Text(notif.title,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 3),
            Text(notif.body,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(_relativeTime,
                style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
          ])),
        ]),
      ),
    );
  }

  (Color, IconData) get _typeStyle => switch (notif.type) {
        StaffNotifType.newBooking => (AppColors.success, Icons.event_available_rounded),
        StaffNotifType.bookingCancelled => (AppColors.error, Icons.event_busy_rounded),
        StaffNotifType.checkInAlert => (const Color(0xFF7C3AED), Icons.qr_code_scanner_rounded),
        StaffNotifType.maintenanceAlert => (AppColors.warning, Icons.build_rounded),
        StaffNotifType.systemAlert => (AppColors.info, Icons.info_outline_rounded),
        StaffNotifType.reviewReply => (AppColors.warning, Icons.star_rounded),
      };

  String get _relativeTime {
    final diff = DateTime.now().difference(notif.createdAt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
