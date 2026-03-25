import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/my_booking_models.dart';

class VenueInfoDetailCard extends StatelessWidget {
  final BookingDetailModel detail;

  const VenueInfoDetailCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(detail.bookingDate);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.stadium_rounded, 'Thông tin đặt sân'),
          const SizedBox(height: 12),
          _infoRow(Icons.location_on_rounded, 'Địa điểm',
              '${detail.courtName} - ${detail.venueName}'),
          const SizedBox(height: 8),
          _infoRow(Icons.map_rounded, 'Địa chỉ', detail.venueAddress),
          const SizedBox(height: 8),
          _infoRow(Icons.calendar_today_rounded, 'Ngày', dateStr),
          const SizedBox(height: 8),
          _infoRow(Icons.access_time_rounded, 'Giờ',
              '${detail.startTime} – ${detail.endTime} (${detail.totalHours.toStringAsFixed(0)}h)'),
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

  Widget _infoRow(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 14, color: AppColors.textHint),
      const SizedBox(width: 6),
      SizedBox(
          width: 60,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textHint))),
      Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600))),
    ],
  );
}
