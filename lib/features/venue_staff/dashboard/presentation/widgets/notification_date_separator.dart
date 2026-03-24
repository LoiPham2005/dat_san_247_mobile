import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class NotificationDateSeparator extends StatelessWidget {
  final DateTime date;
  const NotificationDateSeparator({super.key, required this.date});

  String _label() {
    final now = DateTime.now();
    final d = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    if (d == today) return 'Hôm nay';
    if (d == today.subtract(const Duration(days: 1))) return 'Hôm qua';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
        child: Row(children: [
          const Expanded(child: Divider(color: AppColors.borderLight, height: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(_label(),
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.bold)),
          ),
          const Expanded(child: Divider(color: AppColors.borderLight, height: 1)),
        ]),
      );
}
