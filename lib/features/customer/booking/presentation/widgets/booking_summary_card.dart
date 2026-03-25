import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/booking/data/models/time_slot_model.dart';

class BookingSummaryCard extends StatelessWidget {
  final String courtName;
  final String venueName;
  final String venueAddress;
  final String bookingDate;
  final List<TimeSlotModel> selectedSlots;

  const BookingSummaryCard({
    super.key,
    required this.courtName,
    required this.venueName,
    required this.venueAddress,
    required this.bookingDate,
    required this.selectedSlots,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final startTime = selectedSlots.first.startTime;
    final endTime = selectedSlots.last.endTime;
    final date = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
        .format(DateTime.parse(bookingDate));

    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.sports_soccer_rounded, 'Thông tin đặt sân'),
          const SizedBox(height: 16),
          _infoRow(Icons.stadium_rounded, 'Sân', '$courtName - $venueName'),
          const SizedBox(height: 10),
          _infoRow(Icons.location_on_rounded, 'Địa chỉ', venueAddress),
          const SizedBox(height: 10),
          _infoRow(Icons.calendar_today_rounded, 'Ngày', date),
          const SizedBox(height: 10),
          _infoRow(Icons.access_time_rounded, 'Giờ',
              '$startTime → $endTime (${selectedSlots.length}h)'),
          const SizedBox(height: 10),
          _infoRow(Icons.attach_money_rounded, 'Đơn giá',
              fmt.format(selectedSlots.first.price) + '/h'),
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

  Widget _sectionTitle(IconData icon, String title) => Row(
    children: [
      Icon(icon, color: AppColors.primaryLightBrand, size: 20),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary)),
    ],
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: AppColors.textHint),
      const SizedBox(width: 8),
      SizedBox(
          width: 64,
          child: Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.textHint))),
      Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600))),
    ],
  );
}
