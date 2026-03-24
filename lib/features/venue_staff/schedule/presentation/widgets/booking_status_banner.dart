import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

class BookingStatusBanner extends StatelessWidget {
  final BookingStatusVS status;
  const BookingStatusBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (status) {
      BookingStatusVS.CONFIRMED => (
          AppColors.info,
          Icons.event_available_rounded,
          'Đã xác nhận — Chưa check-in'
        ),
      BookingStatusVS.CHECKED_IN => (
          AppColors.success,
          Icons.how_to_reg_rounded,
          '✅ Đã check-in thành công'
        ),
      BookingStatusVS.COMPLETED => (AppColors.textHint, Icons.done_all_rounded, 'Đã hoàn thành'),
      BookingStatusVS.PENDING => (AppColors.warning, Icons.hourglass_empty_rounded, 'Chờ xác nhận'),
      BookingStatusVS.CANCELLED => (AppColors.error, Icons.cancel_outlined, 'Đã huỷ'),
      BookingStatusVS.NO_SHOW => (
          AppColors.error,
          Icons.person_off_rounded,
          '⚠️ Vắng mặt (No-show)'
        ),
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
      ]),
    );
  }
}
