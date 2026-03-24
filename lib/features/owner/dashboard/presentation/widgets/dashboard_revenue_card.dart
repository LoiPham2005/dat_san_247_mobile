import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardRevenueCard extends StatelessWidget {
  final Map<String, dynamic> revenue;
  const DashboardRevenueCard({super.key, required this.revenue});

  @override
  Widget build(BuildContext context) {
    final growth = revenue['lastMonth'] == 0
        ? 100.0
        : (revenue['thisMonth'] - revenue['lastMonth']) / revenue['lastMonth'] * 100;
    final isPositive = growth >= 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1565C0).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Doanh thu tháng này',
                  style: TextStyle(
                      color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.success.withOpacity(0.25)
                        : AppColors.error.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      size: 14, color: isPositive ? AppColors.success : AppColors.error),
                  const SizedBox(width: 4),
                  Text('${growth.toStringAsFixed(1)}%',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? AppColors.success : AppColors.error)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(children: [
            Text(_fmt(revenue['thisMonth']),
                style: const TextStyle(
                    color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w900)),
            const Text('doanh thu tháng này',
                style: TextStyle(color: AppColors.white70, fontSize: 11)),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: _RevenueInfo(
                    label: 'Hôm nay', value: _fmt(revenue['today']), icon: Icons.today_rounded)),
            Container(width: 1, height: 32, color: AppColors.white.withOpacity(0.2)),
            Expanded(
                child: _RevenueInfo(
                    label: 'Thực nhận',
                    value: _fmt(revenue['ownerReceives']),
                    icon: Icons.account_balance_wallet_rounded)),
            Container(width: 1, height: 32, color: AppColors.white.withOpacity(0.2)),
            Expanded(
                child: _RevenueInfo(
                    label: 'Số booking',
                    value: '${revenue['bookingCount']}',
                    icon: Icons.confirmation_number_rounded)),
          ]),
        ],
      ),
    );
  }

  String _fmt(dynamic val) {
    final v = (val as num).toDouble();
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _RevenueInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _RevenueInfo({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Column(children: [
        Icon(icon, size: 16, color: AppColors.white70),
        const SizedBox(height: 4),
        Text(value,
            style:
                const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: const TextStyle(color: AppColors.white70, fontSize: 10)),
      ]);
}
