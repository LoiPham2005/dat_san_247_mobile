import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class NotificationFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color brand;
  final int count;
  const NotificationFilterChip(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap,
      required this.brand,
      this.count = 0});

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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selected ? brand : Colors.white70)),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  child: Center(
                      child: Text('$count',
                          style: const TextStyle(
                              fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)))),
            ],
          ]),
        ),
      );
}
