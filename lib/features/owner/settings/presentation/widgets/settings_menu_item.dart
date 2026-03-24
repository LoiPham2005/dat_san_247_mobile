import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final bool hasSwitch;
  final bool switchValue;
  final VoidCallback onTap;

  const SettingsMenuItem(
      {super.key,
      required this.icon,
      required this.title,
      this.value,
      this.hasSwitch = false,
      this.switchValue = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFF0891B2).withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: const Color(0xFF0891B2)),
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary))),
            if (value != null)
              Text(value!, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            if (hasSwitch)
              SizedBox(
                  height: 24,
                  child: Switch(
                      value: switchValue,
                      onChanged: (_) => onTap(),
                      activeColor: const Color(0xFF0891B2)))
            else
              const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
