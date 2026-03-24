import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  final bool isBold;
  const ProfileInfoRow(
      {super.key, required this.label, required this.value, this.valueColor, this.isBold = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          Flexible(
              child: Text(value,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
                      color: valueColor ?? AppColors.textPrimary),
                  textAlign: TextAlign.end)),
        ]),
      );
}
