import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/features/owner/finance/data/models/finance_models.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class RevenueMonthCard extends StatefulWidget {
  final RevenueSummaryModel summary;
  const RevenueMonthCard({super.key, required this.summary});

  @override
  State<RevenueMonthCard> createState() => _RevenueMonthCardState();
}

class _RevenueMonthCardState extends State<RevenueMonthCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.summary;
    final dt = DateTime.parse('${s.month}-01');
    final label = DateFormat('MMMM yyyy', 'vi').format(dt);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Column(children: [
        GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                    Text('${s.bookingCount} booking',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(_fmtVnd(s.totalOwnerReceives),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0891B2))),
                    if (s.pendingAmount > 0)
                      Text('Chờ: ${_fmtVnd(s.pendingAmount)}',
                          style: const TextStyle(fontSize: 10, color: AppColors.warning)),
                  ]),
                  const SizedBox(width: 8),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: AppColors.textHint),
                ]))),
        if (_expanded) ...[
          const Divider(height: 1, color: AppColors.borderLight),
          Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(children: [
                _RevRow('Tổng booking', _fmtVnd(s.totalBookingAmount)),
                _RevRow(
                    'Hoa hồng platform (${(s.totalCommissionAmount / s.totalBookingAmount * 100).toStringAsFixed(1)}%)',
                    '- ${_fmtVnd(s.totalCommissionAmount)}',
                    color: AppColors.error),
                const Divider(height: 12, color: AppColors.borderLight),
                _RevRow('Thực nhận', _fmtVnd(s.totalOwnerReceives),
                    bold: true, color: const Color(0xFF0891B2)),
                _RevRow('Đã thanh toán', _fmtVnd(s.paidAmount), color: AppColors.success),
                if (s.pendingAmount > 0)
                  _RevRow('Còn chờ', _fmtVnd(s.pendingAmount), color: AppColors.warning),
              ])),
        ],
      ]),
    );
  }

  String _fmtVnd(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M đ';
    if (v >= 1000) return '${(v / 1000).round()}K đ';
    return '${v.toStringAsFixed(0)} đ';
  }
}

class _RevRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? color;
  const _RevRow(this.label, this.value, {this.bold = false, this.color});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: color ?? AppColors.textSecondary,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
        Text(value,
            style: TextStyle(
                fontSize: 11,
                color: color ?? AppColors.textPrimary,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ]));
}
