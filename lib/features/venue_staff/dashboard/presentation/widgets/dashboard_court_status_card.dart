import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

class DashboardCourtStatusCard extends StatelessWidget {
  final CourtStatusModel court;
  final Color brand;
  const DashboardCourtStatusCard({super.key, required this.court, required this.brand});

  @override
  Widget build(BuildContext context) {
    final status = court.statusNow;
    final (bgColor, dotColor, icon) = switch (status) {
      CourtStatusNow.available => (
          AppColors.success.withOpacity(0.08),
          AppColors.success,
          Icons.sports_soccer_rounded
        ),
      CourtStatusNow.occupied => (brand.withOpacity(0.08), brand, Icons.people_rounded),
      CourtStatusNow.reserved => (
          AppColors.warning.withOpacity(0.08),
          AppColors.warning,
          Icons.event_rounded
        ),
      CourtStatusNow.maintenance => (
          AppColors.error.withOpacity(0.08),
          AppColors.error,
          Icons.build_rounded
        ),
      CourtStatusNow.inactive => (
          AppColors.textHint.withOpacity(0.08),
          AppColors.textHint,
          Icons.block_rounded
        ),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dotColor.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(
              child: Text(court.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis)),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 14, color: dotColor),
          ),
        ]),
        const SizedBox(height: 4),
        Text(status.label,
            style: TextStyle(fontSize: 10, color: dotColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        // Context info
        if (status == CourtStatusNow.occupied && court.currentCustomerName != null)
          Text('👤 ${court.currentCustomerName}',
              style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis)
        else if (status == CourtStatusNow.reserved && court.nextStartTime != null)
          Text('⏰ ${court.nextStartTime} – ${court.nextCustomerName ?? ''}',
              style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis)
        else if (status == CourtStatusNow.maintenance)
          Text('🔧 ${court.activeMaintenance?.reason ?? ''}',
              style: const TextStyle(fontSize: 9, color: AppColors.error),
              overflow: TextOverflow.ellipsis,
              maxLines: 1)
        else
          Text('${court.todayBookingCount} booking hôm nay',
              style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        const SizedBox(height: 2),
        Row(children: [
          Icon(court.isIndoor ? Icons.roofing_rounded : Icons.wb_sunny_rounded,
              size: 9, color: AppColors.textHint),
          const SizedBox(width: 3),
          Text(court.size ?? (court.isIndoor ? 'Trong nhà' : 'Ngoài trời'),
              style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        ]),
      ]),
    );
  }
}
