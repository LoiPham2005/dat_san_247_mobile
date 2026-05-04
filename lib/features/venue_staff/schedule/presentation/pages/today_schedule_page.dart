import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/core/services/manager/toast_service.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/providers/staff_schedule_notifier.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_court_pill.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_court_timeline_section.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_mini_stat.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';
import 'package:dat_san_247_mobile/routes/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ──────────────────────────────────────────────────────────────────────────
// VS-04: Lịch Booking Hôm Nay — Timeline grouped by court
// ──────────────────────────────────────────────────────────────────────────
@route
class TodaySchedulePage extends ConsumerWidget {
  const TodaySchedulePage({super.key});

  static const Color _brand = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(staffScheduleProvider);
    final notifier = ref.read(staffScheduleProvider.notifier);

    useAsyncValueListener(provider: staffScheduleProvider, ref: ref);

    final data = state.value;
    final schedules = data?.schedules ?? [];
    final rawBookings = data?.rawBookings ?? [];
    final selectedCourtId = data?.selectedCourtId;

    final filtered = selectedCourtId == null
        ? schedules
        : schedules.where((s) => s.courtId == selectedCourtId).toList();

    final totalBookings = rawBookings.length;
    final checkedInTotal =
        rawBookings.where((b) => b.status == BookingStatusVS.CHECKED_IN).length;
    final pendingTotal =
        rawBookings.where((b) => b.status == BookingStatusVS.CONFIRMED).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: RefreshIndicator(
        onRefresh: () => notifier.fetchSchedule(isRefreshing: true),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: _brand,
              automaticallyImplyLeading: false,
              expandedHeight: 110,
              centerTitle: false,
              title: const Text('Lịch trình hôm nay',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded,
                      color: Colors.white, size: 26),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const QrCheckInPage()),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 36),
                          Row(children: [
                            ScheduleMiniStat(
                                value: '$totalBookings', label: 'Booking'),
                            const SizedBox(width: 16),
                            ScheduleMiniStat(
                                value: '$checkedInTotal',
                                label: 'Check-in',
                                color: AppColors.success),
                            const SizedBox(width: 16),
                            ScheduleMiniStat(
                                value: '$pendingTotal',
                                label: 'Chờ vào',
                                color: AppColors.warning),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ScheduleCourtPill(
                        label: 'Tất cả',
                        selected: selectedCourtId == null,
                        onTap: () => notifier.selectCourt(null)),
                    ...schedules.map((s) => ScheduleCourtPill(
                          label: s.courtName,
                          selected: selectedCourtId == s.courtId,
                          checkedIn: s.checkedInCount,
                          confirmed: s.confirmedCount,
                          onTap: () => notifier.selectCourt(s.courtId),
                        )),
                  ]),
                ),
              ),
            ),
            if (state.isLoading && data == null)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else if (state.hasError && data == null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text('${state.error}',
                          style: const TextStyle(color: AppColors.error)),
                      TextButton(
                          onPressed: notifier.fetchSchedule,
                          child: const Text('Thử lại')),
                    ],
                  ),
                ),
              )
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy_outlined,
                          size: 48, color: AppColors.textHint),
                      SizedBox(height: 12),
                      Text('Không có lịch đặt cho ngày này',
                          style: TextStyle(color: AppColors.textHint)),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final schedule = filtered[i];
                    return ScheduleCourtTimelineSection(
                      schedule: schedule,
                      brand: _brand,
                      onCheckIn: (booking) async {
                        final result =
                            await CheckInConfirmRoute($extra: booking).push(context);
                        if (result == true && context.mounted) {
                          notifier.fetchSchedule(isRefreshing: true);
                        }
                      },
                      onMarkNoShow: (booking) {
                        HapticFeedback.heavyImpact();
                        notifier.updateBookingStatus(
                            booking.id, BookingStatusVS.NO_SHOW);
                        toast.error(
                            'Đã đánh NO_SHOW cho khách ${booking.customerName}');
                      },
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
