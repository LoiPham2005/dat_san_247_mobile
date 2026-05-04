import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/pages/owner_booking_detail_page.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/providers/owner_calendar_notifier.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_status_dot.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_time_card.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-08: Calendar Booking (Owner View)
// ══════════════════════════════════════════════════════════════════════════════
class OwnerCalendarPage extends ConsumerWidget {
  final String venueId;
  final String venueName;
  const OwnerCalendarPage({
    super.key,
    required this.venueId,
    required this.venueName,
  });

  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ownerCalendarProvider(venueId);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    useAsyncValueListener(provider: provider, ref: ref);

    final data = state.value;
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dayBookings = data.dayBookings;
    final courtNames = <String>['Tất cả', ...data.courts.map((c) => c.name)];
    final courtIds = <String?>[null, ...data.courts.map((c) => c.id)];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 100,
          backgroundColor: _brand,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
          ),
          centerTitle: false,
          title: const Text('Lịch đặt sân',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [_brandDark, _brand],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 38),
                      Row(children: [
                        BookingStatusDot(color: AppColors.warning, label: 'Chờ XN'),
                        SizedBox(width: 12),
                        BookingStatusDot(color: AppColors.info, label: 'Đã XN'),
                        SizedBox(width: 12),
                        BookingStatusDot(color: AppColors.success, label: 'Hoàn thành'),
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
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  courtNames.length,
                  (i) => GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      notifier.setCourt(courtIds[i]);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: data.selectedCourtId == courtIds[i]
                            ? _brand
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: data.selectedCourtId == courtIds[i]
                                ? _brand
                                : AppColors.borderLight),
                      ),
                      child: Text(
                        courtNames[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: data.selectedCourtId == courtIds[i]
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: CalendarView(
              focusedDay: data.focusedDay,
              selectedDay: data.selectedDay,
              daysWithBookings: data.daysWithBookings,
              daysWithPending: data.daysWithPending,
              onDaySelected: notifier.updateDaySelection,
              onPageChanged: (foc) {
                notifier.updatePage(foc);
                notifier.fetchBookings(month: foc);
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
            child: Row(children: [
              Text(
                DateFormat('EEEE, dd/MM/yyyy', 'vi').format(data.selectedDay),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${dayBookings.length} booking',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, color: _brand),
                ),
              ),
            ]),
          ),
        ),
        if (state.isLoading)
          const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
        else if (dayBookings.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_available_rounded,
                      size: 40, color: AppColors.textHint),
                  SizedBox(height: 8),
                  Text('Không có booking ngày này',
                      style: TextStyle(color: AppColors.textHint)),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => BookingTimeCard(
                  booking: dayBookings[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OwnerBookingDetailPage(
                        bookingId: dayBookings[i].id,
                        booking: dayBookings[i],
                      ),
                    ),
                  ),
                ),
                childCount: dayBookings.length,
              ),
            ),
          ),
      ]),
    );
  }
}
