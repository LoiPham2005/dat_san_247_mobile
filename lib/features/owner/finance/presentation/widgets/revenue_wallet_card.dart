import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class RevenueWalletCard extends StatelessWidget {
  final WalletModel wallet;
  final double pendingAmount;
  final double paidAmount;
  final VoidCallback onPayout;
  const RevenueWalletCard({
    super.key,
    required this.wallet,
    required this.pendingAmount,
    required this.paidAmount,
    required this.onPayout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Số dư khả dụng', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text(_fmtVnd(wallet.balance),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5)),
              Text('Khoá: ${_fmtVnd(wallet.lockedBalance)}',
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
            ])),
            ElevatedButton.icon(
              onPressed: onPayout,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              icon: const Icon(Icons.upload_rounded, size: 14, color: Color(0xFF0891B2)),
              label: const Text('Rút tiền',
                  style:
                      TextStyle(color: Color(0xFF0891B2), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _WChip('Chờ nhận', _fmtVnd(pendingAmount), AppColors.warning),
            const SizedBox(width: 8),
            _WChip('Đã nhận', _fmtVnd(paidAmount), AppColors.success),
          ]),
        ],
      ),
    );
  }

  String _fmtVnd(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M đ';
    if (v >= 1000) return '${(v / 1000).round()}K đ';
    return '${v.toStringAsFixed(0)} đ';
  }
}

class _WChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _WChip(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3))),
        child: Column(children: [
          Text(label,
              style: TextStyle(color: color.withOpacity(0.8), fontSize: 9, fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
        ]),
      );
}
