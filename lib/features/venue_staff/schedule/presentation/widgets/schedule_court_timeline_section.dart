import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_tiny_badge.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_timeline_booking_row.dart';

class ScheduleCourtTimelineSection extends StatelessWidget {
  final TodayCourtScheduleModel schedule;
  final Color brand;
  final void Function(CheckInBookingModel) onCheckIn;
  final void Function(CheckInBookingModel) onMarkNoShow;

  const ScheduleCourtTimelineSection({
    super.key,
    required this.schedule,
    required this.brand,
    required this.onCheckIn,
    required this.onMarkNoShow,
  });

  @override
  Widget build(BuildContext context) {
    // Sort bookings by startTime
    final sorted = [...schedule.bookings]..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Court header ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [brand.withOpacity(0.12), brand.withOpacity(0.04)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: brand.withOpacity(0.2)),
            ),
            child: Row(children: [
              Icon(schedule.isIndoor ? Icons.roofing_rounded : Icons.sports_soccer_rounded,
                  size: 18, color: brand),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(schedule.courtName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: brand))),
              ScheduleTinyBadge(text: '${schedule.checkedInCount}✓', color: AppColors.success),
              const SizedBox(width: 6),
              ScheduleTinyBadge(text: '${schedule.confirmedCount}⏳', color: AppColors.warning),
              if (schedule.bookings.any((b) => b.status == BookingStatusVS.NO_SHOW)) ...[
                const SizedBox(width: 6),
                ScheduleTinyBadge(
                    text:
                        '${schedule.bookings.where((b) => b.status == BookingStatusVS.NO_SHOW).length}⚠️',
                    color: AppColors.error),
              ],
            ]),
          ),
          const SizedBox(height: 8),

          // ── Timeline rows ──
          ...sorted.asMap().entries.map((entry) {
            final i = entry.key;
            final b = entry.value;
            return ScheduleTimelineBookingRow(
              booking: b,
              isFirst: i == 0,
              isLast: i == sorted.length - 1,
              brand: brand,
              onCheckIn: () => onCheckIn(b),
              onMarkNoShow: () => onMarkNoShow(b),
            );
          }),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
