import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class RevenuePayoutCard extends StatelessWidget {
  final PayoutRequestModel payout;
  const RevenuePayoutCard({super.key, required this.payout});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (payout.status) {
      PayoutStatus.PENDING => AppColors.warning,
      PayoutStatus.PROCESSING => AppColors.info,
      PayoutStatus.COMPLETED => AppColors.success,
      PayoutStatus.REJECTED => AppColors.error,
      PayoutStatus.CANCELLED => AppColors.textHint,
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
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.account_balance_rounded, color: statusColor, size: 20)),
        const SizedBox(width: 10),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${payout.bankName} · ${payout.bankAccountName}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(DateFormat('dd/MM/yyyy HH:mm').format(payout.createdAt),
              style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
          if (payout.rejectionReason != null)
            Text('Từ chối: ${payout.rejectionReason}',
                style: const TextStyle(fontSize: 10, color: AppColors.error)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_fmtVnd(payout.amount), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(payout.status.label,
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
