import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';

class DashboardRevenueSummaryCard extends StatelessWidget {
  final StaffDashboardModel data;
  final Color brand;
  const DashboardRevenueSummaryCard({super.key, required this.data, required this.brand});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [brand.withOpacity(0.06), brand.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: brand.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.payments_rounded, size: 16, color: brand),
            const SizedBox(width: 6),
            const Text('Doanh thu hôm nay',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child:
                    _RevRow(label: 'Đã thu', value: data.revenueToday, color: AppColors.success)),
            Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2)),
            Expanded(
                child: _RevRow(
                    label: 'Chờ thu', value: data.revenuePending, color: AppColors.warning)),
            Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2)),
            Expanded(
                child: _RevRow(
                    label: 'Tổng', value: data.revenueToday + data.revenuePending, color: brand)),
          ]),
        ]),
      );
}

class _RevRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _RevRow({required this.label, required this.value, required this.color});

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(_fmt(value),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
      ]);
}
