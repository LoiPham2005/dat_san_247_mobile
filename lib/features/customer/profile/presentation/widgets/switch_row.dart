import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class SwitchRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  const SwitchRow({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        leading: Icon(icon,
            size: 20,
            color: value ? AppColors.primaryLightBrand : AppColors.textHint),
        title: Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        trailing: Switch.adaptive(
          value: value,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onChanged(v);
          },
          activeColor: AppColors.primaryLightBrand,
        ),
      );
}
