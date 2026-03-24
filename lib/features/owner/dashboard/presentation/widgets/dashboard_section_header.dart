import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? action;
  final VoidCallback? onAction;
  const DashboardSectionHeader(
      {super.key, required this.title, required this.icon, required this.color, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!,
                  style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
            ),
        ],
      );
}
