import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const BookingInfoRow(
      {super.key, required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 8),
        SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis)),
      ]));
}
