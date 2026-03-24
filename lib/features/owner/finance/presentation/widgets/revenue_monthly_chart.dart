import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class RevenueMonthlyChart extends StatelessWidget {
  final List<RevenueSummaryModel> summaries;
  const RevenueMonthlyChart({super.key, required this.summaries});

  @override
  Widget build(BuildContext context) {
    if (summaries.isEmpty) return const SizedBox.shrink();
    final maxAmount = summaries.map((s) => s.totalOwnerReceives).reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Doanh Thu Thực Nhận (4 tháng gần nhất)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: summaries.reversed.toList().map((s) {
                final ratio = maxAmount > 0 ? s.totalOwnerReceives / maxAmount : 0.0;
                final label = s.month.substring(5); // 'MM'
                return Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Text(_fmtK(s.totalOwnerReceives),
                              style: const TextStyle(fontSize: 8, color: AppColors.textHint)),
                          const SizedBox(height: 2),
                          AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: 100 * ratio,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF0891B2).withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(6))),
                          const SizedBox(height: 4),
                          Text('Th$label',
                              style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
                        ])));
              }).toList(),
            )),
      ]),
    );
  }

  String _fmtK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(0)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}
