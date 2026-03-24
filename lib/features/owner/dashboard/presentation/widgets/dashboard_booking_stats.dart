import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardBookingStats extends StatelessWidget {
  final Map<String, dynamic> stats;
  const DashboardBookingStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.today_rounded, size: 18, color: Color(0xFF1565C0)),
            const SizedBox(width: 8),
            Text('Booking hôm nay · Tổng ${stats['total']}',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _StatChip(label: 'Chờ', count: stats['pending'], color: AppColors.warning),
            const SizedBox(width: 8),
            _StatChip(label: 'Xác nhận', count: stats['confirmed'], color: AppColors.info),
            const SizedBox(width: 8),
            _StatChip(label: 'Check-in', count: stats['checkedIn'], color: const Color(0xFF1565C0)),
            const SizedBox(width: 8),
            _StatChip(label: 'Hoàn thành', count: stats['completed'], color: AppColors.success),
            const SizedBox(width: 8),
            _StatChip(label: 'Huỷ', count: stats['cancelled'], color: AppColors.error),
          ]),
          const SizedBox(height: 10),
          // ── Progress bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                _ProgressBar(flex: stats['pending'], color: AppColors.warning),
                _ProgressBar(flex: stats['confirmed'], color: AppColors.info),
                _ProgressBar(flex: stats['checkedIn'], color: const Color(0xFF1565C0)),
                _ProgressBar(flex: stats['completed'], color: AppColors.success),
                _ProgressBar(flex: stats['cancelled'], color: AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration:
              BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Column(children: [
            Text('$count',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
            Text(label,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
                textAlign: TextAlign.center),
          ]),
        ),
      );
}

class _ProgressBar extends StatelessWidget {
  final int flex;
  final Color color;
  const _ProgressBar({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) => Flexible(
        flex: flex == 0 ? 0 : flex,
        child: flex == 0 ? const SizedBox.shrink() : Container(height: 6, color: color),
      );
}
