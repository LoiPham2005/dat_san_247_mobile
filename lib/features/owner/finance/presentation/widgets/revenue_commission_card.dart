import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class RevenueCommissionCard extends StatelessWidget {
  final CommissionRecordModel record;
  const RevenueCommissionCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final statusColor = switch (record.status) {
      CommissionStatus.PENDING => AppColors.warning,
      CommissionStatus.APPROVED => AppColors.info,
      CommissionStatus.PAID => AppColors.success,
      CommissionStatus.CANCELLED => AppColors.error,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Row(children: [
        Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(record.status.emoji, style: const TextStyle(fontSize: 16)),
            ])),
        const SizedBox(width: 10),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(record.bookingCode,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          Text('${record.customerName} · ${record.courtName}',
              style: const TextStyle(fontSize: 10, color: AppColors.textHint),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(DateFormat('dd/MM/yyyy').format(record.bookingDate),
              style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_fmtVnd(record.ownerReceives),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: brand)),
          Text(
              '-${record.commissionRate.toStringAsFixed(0)}% = -${_fmtVnd(record.commissionAmount)}',
              style: const TextStyle(fontSize: 9, color: AppColors.error)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(record.status.label,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
        ]),
      ]),
    );
  }

  String _fmtVnd(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M đ';
    if (v >= 1000) return '${(v / 1000).round()}K đ';
    return '${v.toStringAsFixed(0)} đ';
  }
}
