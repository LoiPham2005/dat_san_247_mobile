import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class BookingAmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;
  final Color? color;
  const BookingAmountRow(
      {super.key, required this.label, required this.amount, this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Expanded(
              child: Text(label,
                  style:
                      TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: c))),
          Text('${amount < 0 ? '-' : ''}${_fmt(amount.abs())} đ',
              style: TextStyle(
                  fontSize: 12, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: c)),
        ]));
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}
