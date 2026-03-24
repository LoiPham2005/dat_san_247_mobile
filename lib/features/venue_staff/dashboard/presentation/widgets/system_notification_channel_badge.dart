import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/pricing/data/models/pricing_models.dart';

class SystemNotificationChannelBadge extends StatelessWidget {
  final StaffNotifChannel channel;
  const SystemNotificationChannelBadge({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (channel) {
      StaffNotifChannel.PUSH => (AppColors.info, Icons.notifications_rounded),
      StaffNotifChannel.EMAIL => (AppColors.warning, Icons.email_rounded),
      StaffNotifChannel.SMS => (AppColors.success, Icons.sms_rounded),
      StaffNotifChannel.IN_APP => (AppColors.textHint, Icons.app_shortcut_rounded),
    };
    return Icon(icon, size: 12, color: color);
  }
}
