import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardMiniChart extends StatelessWidget {
  final List<double> data;
  final List<String> days;
  const DashboardMiniChart({
    super.key,
    this.data = const [1.2, 1.8, 0.9, 2.3, 1.5, 2.8, 2.7],
    this.days = const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.show_chart_rounded, size: 18, color: Color(0xFF1565C0)),
            SizedBox(width: 8),
            Text('Doanh thu 7 ngày qua (triệu đ)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (i) {
                final h = (data[i] / maxVal) * 70;
                final isMax = data[i] == maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isMax)
                          Text('${data[i]}M',
                              style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0))),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300 + i * 80),
                          height: h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withOpacity(isMax ? 1 : 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(days[i],
                            style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
