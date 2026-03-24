import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

class DashboardMaintenanceCard extends StatelessWidget {
  final CourtMaintenanceModel m;
  const DashboardMaintenanceCard({super.key, required this.m});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: m.isEmergency
              ? AppColors.error.withOpacity(0.06)
              : AppColors.warning.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: (m.isEmergency ? AppColors.error : AppColors.warning).withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(m.isEmergency ? Icons.warning_rounded : Icons.build_rounded,
              size: 18, color: m.isEmergency ? AppColors.error : AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.reason, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(
              '${DateFormat('HH:mm').format(m.startAt)} – ${DateFormat('HH:mm').format(m.endAt)}'
              '${m.isActiveNow ? '  ⏳ Đang diễn ra' : ''}',
              style: TextStyle(
                  fontSize: 10, color: m.isEmergency ? AppColors.error : AppColors.warning),
            ),
          ])),
          if (m.isEmergency)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Khẩn cấp',
                  style:
                      TextStyle(fontSize: 9, color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
        ]),
      );
}
