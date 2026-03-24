import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardBookingStatusSummary extends StatelessWidget {
  final int pendingCount;
  final int confirmedCount;
  final int checkedInCount;
  final int completedCount;
  final int noShowCount;

  const DashboardBookingStatusSummary({
    super.key,
    required this.pendingCount,
    required this.confirmedCount,
    required this.checkedInCount,
    required this.completedCount,
    required this.noShowCount,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatusItem('Chờ XN', pendingCount, AppColors.warning, Icons.hourglass_empty_rounded),
      _StatusItem('Đã XN', confirmedCount, AppColors.info, Icons.event_available_rounded),
      _StatusItem('Check-in', checkedInCount, AppColors.success, Icons.how_to_reg_rounded),
      _StatusItem('Xong', completedCount, AppColors.textHint, Icons.done_all_rounded),
      _StatusItem('No-show', noShowCount, AppColors.error, Icons.person_off_rounded),
    ];

    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = items[i];
          return Container(
            width: 86,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: item.color.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(item.icon, size: 20, color: item.color),
              const SizedBox(height: 4),
              Text('${item.count}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: item.color)),
              Text(item.label,
                  style: TextStyle(
                      fontSize: 9,
                      color: item.color.withOpacity(0.8),
                      fontWeight: FontWeight.bold)),
            ]),
          );
        },
      ),
    );
  }
}

class _StatusItem {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  const _StatusItem(this.label, this.count, this.color, this.icon);
}
