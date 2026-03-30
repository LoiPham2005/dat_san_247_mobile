import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';

class AppDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Chọn ngày',
  }) async {
    DateTime? selectedDate;

    return await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              
              // Calendar
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryLightBrand,
                    onPrimary: Colors.white,
                    onSurface: AppColors.textPrimary,
                    secondary: AppColors.primaryLightBrand,
                  ),
                  dividerColor: Colors.transparent,
                ),
                child: CalendarDatePicker(
                  initialDate: initialDate,
                  firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (date) {
                    selectedDate = date;
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedDate ?? initialDate),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBrand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
