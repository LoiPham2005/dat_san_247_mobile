import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

class DashboardCheckInProgressCard extends StatelessWidget {
  final StaffDashboardModel data;
  final Color brand;
  const DashboardCheckInProgressCard({super.key, required this.data, required this.brand});

  @override
  Widget build(BuildContext context) {
    final rate = data.checkInRate;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.how_to_reg_rounded, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          const Text('Tỉ lệ Check-in hôm nay',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('${data.checkedInCount}/${data.totalBookingsToday}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.success)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: rate.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
          ),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _ProgStat('${data.checkedInCount}\nCheck-in', AppColors.success),
          _ProgStat('${data.confirmedCount}\nChờ vào', AppColors.info),
          _ProgStat('${data.noShowCount}\nVắng mặt', AppColors.error),
          _ProgStat('${data.completedCount}\nHoàn thành', AppColors.textHint),
        ]),
      ]),
    );
  }
}

class _ProgStat extends StatelessWidget {
  final String text;
  final Color color;
  const _ProgStat(this.text, this.color);

  @override
  Widget build(BuildContext context) => Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold, height: 1.5));
}
