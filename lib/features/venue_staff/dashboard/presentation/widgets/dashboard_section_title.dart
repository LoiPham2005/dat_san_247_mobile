import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardSectionTitle extends StatelessWidget {
  final String title;
  final String action;
  const DashboardSectionTitle({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        const Spacer(),
        if (action.isNotEmpty)
          Text(action, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
      ]);
}
