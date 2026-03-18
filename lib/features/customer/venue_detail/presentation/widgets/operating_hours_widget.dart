import 'package:flutter/material.dart';
import '../../data/models/operating_hours_model.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class OperatingHoursWidget extends StatelessWidget {
  final List<OperatingHoursModel> operatingHours;

  const OperatingHoursWidget({super.key, required this.operatingHours});

  String _translateDay(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday: return 'Thứ 2';
      case DayOfWeek.tuesday: return 'Thứ 3';
      case DayOfWeek.wednesday: return 'Thứ 4';
      case DayOfWeek.thursday: return 'Thứ 5';
      case DayOfWeek.friday: return 'Thứ 6';
      case DayOfWeek.saturday: return 'Thứ 7';
      case DayOfWeek.sunday: return 'Chủ Nhật';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (operatingHours.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.schedule_rounded, color: AppColors.primaryLightBrand, size: 20),
            SizedBox(width: 8),
            Text(
              'Giờ hoạt động',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: operatingHours.map((hours) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _translateDay(hours.dayOfWeek),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      hours.isClosed ? 'Đóng cửa' : '${hours.openTime.substring(0, 5)} - ${hours.closeTime.substring(0, 5)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: hours.isClosed ? AppColors.destructiveLight : AppColors.primaryLightBrand,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
