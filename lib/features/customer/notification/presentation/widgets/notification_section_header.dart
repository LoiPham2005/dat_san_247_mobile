import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String label;
  final int? count;
  const NotificationSectionHeader({super.key, required this.label, this.count});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    child: Row(children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textHint, letterSpacing: 0.5)),
      if (count != null) ...[
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: AppColors.primaryLightBrand.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Text('$count', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryLightBrand)),
        ),
      ],
    ]),
  );
}
