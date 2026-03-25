import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class TimeSlotGrid extends StatefulWidget {
  final bool isOpen;
  const TimeSlotGrid({super.key, required this.isOpen});

  @override
  State<TimeSlotGrid> createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends State<TimeSlotGrid> {
  // Mock: index 1, 3, 5 đã bị đặt
  final Set<int> _booked = {1, 3, 5};
  int? _selectedSlot;

  static const _slots = [
    '06:00',
    '08:00',
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
    '20:00',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.4,
      ),
      itemCount: _slots.length,
      itemBuilder: (_, i) {
        final isBooked = _booked.contains(i);
        final isSelected = _selectedSlot == i;
        final canTap = widget.isOpen && !isBooked;
        return GestureDetector(
          onTap: canTap ? () => setState(() => _selectedSlot = isSelected ? null : i) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLightBrand
                  : isBooked
                      ? const Color(0xFFF5F7FA)
                      : const Color(0xFFF0FBF9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryLightBrand
                    : isBooked
                        ? const Color(0xFFDDE3EA)
                        : const Color(0xFFB8EDE5),
              ),
            ),
            child: Text(
              _slots[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : isBooked
                        ? const Color(0xFFBCC6D1)
                        : AppColors.primaryLightBrand,
              ),
            ),
          ),
        );
      },
    );
  }
}
