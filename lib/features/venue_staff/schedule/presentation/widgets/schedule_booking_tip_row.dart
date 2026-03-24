import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class ScheduleBookingTipRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool isMono;
  const ScheduleBookingTipRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      this.isMono = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Icon(icon, size: 14, color: AppColors.textHint),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: isMono ? 'monospace' : null)),
        ]),
      );
}
