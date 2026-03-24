import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class VenueFilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color brand;
  final VoidCallback onTap;
  final int count;
  const VenueFilterPill(
      {super.key,
      required this.label,
      required this.selected,
      required this.brand,
      required this.onTap,
      this.count = 0});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: selected ? brand : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? brand : AppColors.borderLight)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : AppColors.textSecondary)),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                      color: selected ? Colors.white.withOpacity(0.3) : brand.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: Center(
                      child: Text('$count',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: selected ? Colors.white : brand))))
            ],
          ]),
        ),
      );
}
