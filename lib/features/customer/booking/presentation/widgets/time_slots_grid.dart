import 'package:flutter/material.dart';

class TimeSlotsGrid extends StatelessWidget {
  final List<TimeOfDay> availableSlots;
  final List<TimeOfDay> bookedSlots;
  final TimeOfDay? selectedSlot;
  final Function(TimeOfDay) onSlotSelected;

  const TimeSlotsGrid({
    super.key,
    required this.availableSlots,
    required this.bookedSlots,
    this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.access_time,
                  color: Colors.orange[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Chọn giờ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Legend
          Row(
            children: [
              _buildLegendItem(Colors.green[100]!, Colors.green[600]!, "Trống"),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.red[100]!, Colors.red[600]!, "Đã đặt"),
              const SizedBox(width: 16),
              _buildLegendItem(Theme.of(context).primaryColor.withOpacity(0.1), 
                              Theme.of(context).primaryColor, "Đã chọn"),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Time slots grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: availableSlots.length,
            itemBuilder: (context, index) {
              final slot = availableSlots[index];
              final isBooked = _isSlotBooked(slot);
              final isSelected = _isSlotSelected(slot);
              
              return _buildTimeSlot(
                context,
                slot,
                isBooked: isBooked,
                isSelected: isSelected,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color backgroundColor, Color textColor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: textColor, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(
    BuildContext context,
    TimeOfDay slot, {
    required bool isBooked,
    required bool isSelected,
  }) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    if (isSelected) {
      backgroundColor = Theme.of(context).primaryColor;
      textColor = Colors.white;
      borderColor = Theme.of(context).primaryColor;
    } else if (isBooked) {
      backgroundColor = Colors.red[50]!;
      textColor = Colors.red[600]!;
      borderColor = Colors.red[200]!;
    } else {
      backgroundColor = Colors.green[50]!;
      textColor = Colors.green[700]!;
      borderColor = Colors.green[200]!;
    }
    
    return InkWell(
      onTap: isBooked ? null : () => onSlotSelected(slot),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isBooked)
                Icon(
                  Icons.lock,
                  size: 14,
                  color: textColor,
                )
              else if (isSelected)
                Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              if (isBooked || isSelected) const SizedBox(width: 4),
              Text(
                slot.format(context),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSlotBooked(TimeOfDay slot) {
    return bookedSlots.any((booked) => 
        booked.hour == slot.hour && booked.minute == slot.minute);
  }

  bool _isSlotSelected(TimeOfDay slot) {
    if (selectedSlot == null) return false;
    return selectedSlot!.hour == slot.hour && selectedSlot!.minute == slot.minute;
  }
}