import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_court_pill.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_court_timeline_section.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/widgets/schedule_mini_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/check_in_confirm_page.dart';

// ──────────────────────────────────────────────────────────────────────────
// VS-04: Lịch Booking Hôm Nay — Timeline grouped by court
// ──────────────────────────────────────────────────────────────────────────
class TodaySchedulePage extends StatefulWidget {
  const TodaySchedulePage({super.key});

  @override
  State<TodaySchedulePage> createState() => _TodaySchedulePageState();
}

class _TodaySchedulePageState extends State<TodaySchedulePage> {
  static const Color _brand = Color(0xFF7C3AED);
  String? _selectedCourtId;

  // ── Mock data ────────────────────────────────────────────────────────
  final List<TodayCourtScheduleModel> _schedules = _buildMockData();

  static List<TodayCourtScheduleModel> _buildMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    booking(
            String id,
            String code,
            String? qr,
            String court,
            String cId,
            String name,
            String phone,
            String start,
            String end,
            BookingStatusVS status,
            double amount,
            List<StaffBookingAddonModel> addons) =>
        CheckInBookingModel(
          id: id,
          bookingCode: code,
          checkInCode: qr,
          courtId: cId,
          courtName: court,
          isIndoor: false,
          venueName: 'Sân K34',
          venueAddress: '34 PVĐ, Hà Nội',
          customerId: 'u$id',
          customerName: name,
          customerPhone: phone,
          bookingDate: today,
          startTime: start,
          endTime: end,
          status: status,
          totalAmount: amount,
          addons: addons,
        );

    final sA = [
      booking('1', 'DS24799101', 'ABCD1234', 'Sân A - 5 người', 'c1', 'Nguyễn Văn An', '0912345678', '07:00', '08:30',
          BookingStatusVS.COMPLETED, 225000, []),
      booking('2', 'DS24799102', 'EFGH5678', 'Sân A - 5 người', 'c1', 'Trần Thị Bình', '0987654321', '09:00', '10:30',
          BookingStatusVS.CHECKED_IN, 225000, []),
      booking('3', 'DS24799103', 'IJKL9012', 'Sân A - 5 người', 'c1', 'Phạm Văn Cường', '0905123456', '18:00', '19:30',
          BookingStatusVS.CONFIRMED, 225000, [
        StaffBookingAddonModel(
            id: 'a1',
            bookingId: '3',
            serviceId: 's1',
            serviceName: 'Nước uống x2',
            quantity: 2,
            pricePerUnit: 15000,
            totalPrice: 30000),
      ]),
      booking('4', 'DS24799104', null, 'Sân A - 5 người', 'c1', 'Lê Hoàng Dũng', '0908765432', '20:00', '21:30',
          BookingStatusVS.CONFIRMED, 225000, []),
    ];

    final sB = [
      booking('5', 'DS24799105', 'MNOP3456', 'Sân B - 7 người', 'c2', 'Hoàng Thị Em', '0917234567', '08:00', '09:00',
          BookingStatusVS.COMPLETED, 200000, []),
      booking('6', 'DS24799106', null, 'Sân B - 7 người', 'c2', 'Vũ Văn Phúc', '0934567890', '17:00', '18:00',
          BookingStatusVS.CONFIRMED, 200000, []),
      booking('7', 'DS24799107', null, 'Sân B - 7 người', 'c2', 'Đinh Thị Giang', '0923456789', '14:00', '15:00',
          BookingStatusVS.NO_SHOW, 200000, []),
    ];

    final sCL = [
      booking('8', 'DS24799108', 'QRST7890', 'Sân Cầu Lông', 'c3', 'Bùi Huy Hoàng', '0901234567', '06:00', '07:30',
          BookingStatusVS.CHECKED_IN, 120000, []),
      booking('9', 'DS24799109', null, 'Sân Cầu Lông', 'c3', 'Cao Thị Inh', '0978901234', '19:00', '20:30',
          BookingStatusVS.CONFIRMED, 120000, []),
    ];

    return [
      TodayCourtScheduleModel(courtId: 'c1', courtName: 'Sân A - 5 người', isIndoor: false, bookings: sA),
      TodayCourtScheduleModel(courtId: 'c2', courtName: 'Sân B - 7 người', isIndoor: false, bookings: sB),
      TodayCourtScheduleModel(courtId: 'c3', courtName: 'Sân Cầu Lông', isIndoor: true, bookings: sCL),
    ];
  }

  List<TodayCourtScheduleModel> get _filtered =>
      _selectedCourtId == null ? _schedules : _schedules.where((s) => s.courtId == _selectedCourtId).toList();

  int get _totalBookings => _schedules.fold(0, (sum, s) => sum + s.bookings.length);
  int get _checkedInTotal => _schedules.fold(0, (sum, s) => sum + s.checkedInCount);
  int get _pendingTotal => _schedules.fold(0, (sum, s) => sum + s.confirmedCount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            pinned: true,
            backgroundColor: _brand,
            automaticallyImplyLeading: false,
            expandedHeight: 180,
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 26),
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QrCheckInPage())),
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
                        Text('📅 ${DateFormat('EEEE, dd/MM', 'vi').format(DateTime.now())}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(children: [
                          ScheduleMiniStat(value: '$_totalBookings', label: 'Tổng booking'),
                          const SizedBox(width: 16),
                          ScheduleMiniStat(value: '$_checkedInTotal', label: 'Check-in', color: AppColors.success),
                          const SizedBox(width: 16),
                          ScheduleMiniStat(value: '$_pendingTotal', label: 'Chờ vào', color: AppColors.warning),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Lịch Hôm Nay',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              centerTitle: false,
            ),
          ),

          // ── Court filter pills ──
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ScheduleCourtPill(
                      label: 'Tất cả',
                      selected: _selectedCourtId == null,
                      onTap: () => setState(() => _selectedCourtId = null)),
                  ..._schedules.map((s) => ScheduleCourtPill(
                        label: s.courtName,
                        selected: _selectedCourtId == s.courtId,
                        checkedIn: s.checkedInCount,
                        confirmed: s.confirmedCount,
                        onTap: () => setState(() => _selectedCourtId = s.courtId),
                      )),
                ]),
              ),
            ),
          ),

          // ── Timeline grouped by court ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final schedule = _filtered[i];
                return ScheduleCourtTimelineSection(
                  schedule: schedule,
                  brand: _brand,
                  onCheckIn: (booking) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CheckInConfirmPage(booking: booking)),
                  ),
                  onMarkNoShow: (booking) {
                    HapticFeedback.heavyImpact();
                    setState(() {
                      // Simulate mark no-show
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('⚠️ Đã đánh NO_SHOW: ${booking.customerName}'),
                            backgroundColor: AppColors.error),
                      );
                    });
                  },
                );
              },
              childCount: _filtered.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
