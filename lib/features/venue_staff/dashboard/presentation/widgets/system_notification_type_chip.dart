import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class SystemNotificationTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color brand;
  final VoidCallback onTap;
  final int count;
  final IconData? icon;
  const SystemNotificationTypeChip(
      {super.key,
      required this.label,
      required this.selected,
      required this.brand,
      required this.onTap,
      this.count = 0,
      this.icon});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[
              Icon(icon, size: 11, color: selected ? brand : Colors.white70),
              const SizedBox(width: 4)
            ],
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: selected ? brand : Colors.white70)),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  child: Center(
                      child: Text('$count',
                          style: const TextStyle(
                              fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)))),
            ],
          ]),
        ),
      );
}
