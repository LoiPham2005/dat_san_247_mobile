import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

class ScheduleStatusBadge extends StatelessWidget {
  final BookingStatusVS status;
  const ScheduleStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      BookingStatusVS.COMPLETED => (AppColors.textHint, 'Xong'),
      BookingStatusVS.CHECKED_IN => (AppColors.success, '✓ Check-in'),
      BookingStatusVS.CONFIRMED => (AppColors.warning, '⏳ Chờ'),
      BookingStatusVS.PENDING => (AppColors.info, 'Pending'),
      BookingStatusVS.CANCELLED => (AppColors.error, 'Huỷ'),
      BookingStatusVS.NO_SHOW => (AppColors.error, '⚠ No-show'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
