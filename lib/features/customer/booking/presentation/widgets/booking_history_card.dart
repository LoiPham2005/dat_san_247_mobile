import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class BookingHistoryCard extends StatelessWidget {
  final List<BookingStatusHistoryModel> statusHistory;

  const BookingHistoryCard({super.key, required this.statusHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.history_rounded, 'Lịch sử trạng thái'),
          const SizedBox(height: 12),
          ...List.generate(statusHistory.length, (i) {
            final h = statusHistory[i];
            final isLast = i == statusHistory.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isLast
                            ? AppColors.primaryLightBrand
                            : AppColors.borderLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isLast
                                ? AppColors.primaryLightBrand
                                : AppColors.greyLight,
                            width: 2),
                      ),
                    ),
                    if (!isLast)
                      Container(width: 2, height: 36, color: AppColors.borderLight),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.status.label,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isLast
                                    ? AppColors.primaryLightBrand
                                    : AppColors.textPrimary)),
                        if (h.note != null)
                          Text(h.note!,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                        Text(DateFormat('HH:mm dd/MM/yyyy').format(h.createdAt),
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
          color: AppColors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2))
    ],
  );

  Widget _sectionHeader(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 18),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    ],
  );
}
