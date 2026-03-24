import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_status_badge.dart';

class ScheduleTimelineBookingRow extends StatelessWidget {
  final CheckInBookingModel booking;
  final bool isFirst;
  final bool isLast;
  final Color brand;
  final VoidCallback onCheckIn;
  final VoidCallback onMarkNoShow;

  const ScheduleTimelineBookingRow({
    super.key,
    required this.booking,
    required this.isFirst,
    required this.isLast,
    required this.brand,
    required this.onCheckIn,
    required this.onMarkNoShow,
  });

  @override
  Widget build(BuildContext context) {
    final (dotColor, _) = _statusStyle;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline spine ──
          SizedBox(
            width: 44,
            child: Column(children: [
              if (!isFirst)
                Container(width: 2, height: 8, color: Colors.grey.withOpacity(0.2)),
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: dotColor.withOpacity(0.4), blurRadius: 4)])),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey.withOpacity(0.2))),
            ]),
          ),
          // ── Booking card ──
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8, right: 2),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: dotColor.withOpacity(0.25)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    // Time
                    Text('${booking.startTime}',
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: brand)),
                    Text(' – ${booking.endTime}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    ScheduleStatusBadge(status: booking.status),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: brand.withOpacity(0.1),
                      child: Text(booking.customerName[0],
                          style:
                              TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brand)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(booking.customerName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      if (booking.customerPhone != null)
                        Text(booking.customerPhone!,
                            style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                    ])),
                    Text(booking.bookingCode,
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textHint, fontFamily: 'monospace')),
                  ]),

                  if (booking.addons.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                        spacing: 4,
                        children: booking.addons
                            .map((a) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryLightBrand.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text('${a.serviceName} x${a.quantity}',
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: AppColors.primaryLightBrand,
                                          fontWeight: FontWeight.bold)),
                                ))
                            .toList()),
                  ],

                  // ── Action buttons ──
                  if (booking.status == BookingStatusVS.CONFIRMED) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onCheckIn,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColors.success.withOpacity(0.3))),
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.qr_code_scanner_rounded,
                                      size: 14, color: AppColors.success),
                                  SizedBox(width: 4),
                                  Text('Check-in',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success)),
                                ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _confirmNoShow(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.error.withOpacity(0.25))),
                          child: const Row(children: [
                            Icon(Icons.person_off_rounded, size: 14, color: AppColors.error),
                            const SizedBox(width: 4),
                            Text('No-show',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error)),
                          ]),
                        ),
                      ),
                    ]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, String) get _statusStyle => switch (booking.status) {
        BookingStatusVS.COMPLETED => (AppColors.textHint, 'Hoàn thành'),
        BookingStatusVS.CHECKED_IN => (AppColors.success, 'Check-in'),
        BookingStatusVS.CONFIRMED => (AppColors.warning, 'Chờ vào'),
        BookingStatusVS.PENDING => (AppColors.info, 'Chờ xác nhận'),
        BookingStatusVS.CANCELLED => (AppColors.error, 'Huỷ'),
        BookingStatusVS.NO_SHOW => (AppColors.error, 'Vắng'),
      };

  void _confirmNoShow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40,
              height: 4,
              decoration:
                  BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Icon(Icons.person_off_rounded, color: AppColors.error, size: 40),
          const SizedBox(height: 10),
          Text('Đánh NO-SHOW cho ${booking.customerName}?',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('Trường hợp: ${booking.startTime}–${booking.endTime} | ${booking.bookingCode}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
                child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Huỷ'),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                onMarkNoShow();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Xác nhận',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}
