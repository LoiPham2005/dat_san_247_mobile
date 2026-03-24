import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';

class BookingTimeCard extends StatelessWidget {
  final OwnerBookingModel booking;
  final VoidCallback onTap;
  const BookingTimeCard({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final statusColor = switch (booking.status) {
      BookingStatus.PENDING => AppColors.warning,
      BookingStatus.CONFIRMED => AppColors.info,
      BookingStatus.CHECKED_IN => brand,
      BookingStatus.COMPLETED => AppColors.success,
      BookingStatus.CANCELLED => AppColors.error,
      BookingStatus.NO_SHOW => AppColors.textHint,
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
        child: Row(children: [
          Container(
              width: 5,
              decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)))),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(booking.startTime,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                          Text(booking.endTime,
                              style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                        ]),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(booking.customerName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(booking.courtName, style: const TextStyle(fontSize: 11, color: brand)),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(booking.status.label,
                              style: TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
                      const SizedBox(height: 4),
                      Text(_fmtPrice(booking.totalAmount),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textHint),
                  ]))),
        ]),
      ),
    );
  }

  String _fmtPrice(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}
