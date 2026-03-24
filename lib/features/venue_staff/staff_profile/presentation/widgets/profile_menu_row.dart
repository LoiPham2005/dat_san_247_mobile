import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class ProfileMenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDestructive;
  final VoidCallback onTap;
  const ProfileMenuRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.color,
      required this.onTap,
      this.isDestructive = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? AppColors.error : AppColors.textPrimary))),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textHint),
          ]),
        ),
      );
}
