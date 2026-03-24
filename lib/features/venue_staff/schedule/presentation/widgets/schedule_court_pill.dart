import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class ScheduleCourtPill extends StatelessWidget {
  final String label;
  final bool selected;
  final int? checkedIn;
  final int? confirmed;
  final VoidCallback onTap;
  const ScheduleCourtPill(
      {super.key,
      required this.label,
      required this.selected,
      this.checkedIn,
      this.confirmed,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    return GestureDetector(
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
          border:
              Border.all(color: selected ? brand : Colors.grey.shade200, width: selected ? 0 : 1),
          boxShadow: selected ? [BoxShadow(color: brand.withOpacity(0.3), blurRadius: 6)] : [],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textSecondary)),
          if (checkedIn != null && checkedIn! > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.2) : AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Text('$checkedIn✓',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : AppColors.success)),
            ),
          ],
        ]),
      ),
    );
  }
}
