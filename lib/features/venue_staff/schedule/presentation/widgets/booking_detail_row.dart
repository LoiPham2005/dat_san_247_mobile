import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class BookingDetailRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isMono;
  final bool isBold;
  final bool isFmtValue; // Just to help with spacing if needed
  const BookingDetailRow(
      {super.key,
      this.icon,
      required this.label,
      required this.value,
      this.valueColor,
      this.isMono = false,
      this.isBold = false,
      this.isFmtValue = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.textHint),
            const SizedBox(width: 8)
          ],
          Expanded(
              child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 14 : 12,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                  fontFamily: isMono ? 'monospace' : null)),
        ]),
      );
}
