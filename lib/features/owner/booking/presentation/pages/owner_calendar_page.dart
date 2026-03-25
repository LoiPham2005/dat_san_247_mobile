import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/booking/data/models/booking_models.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/pages/owner_booking_detail_page.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_status_dot.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/booking_time_card.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/widgets/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ══════════════════════════════════════════════════════════════════════════════
// O-08: Calendar Booking (Owner View)
// DB: bookings (venue_id, booking_date, status), courts
// ══════════════════════════════════════════════════════════════════════════════
class OwnerCalendarPage extends StatefulWidget {
  final String venueId;
  final String venueName;
  const OwnerCalendarPage({super.key, required this.venueId, required this.venueName});
  @override
  State<OwnerCalendarPage> createState() => _OwnerCalendarPageState();
}

class _OwnerCalendarPageState extends State<OwnerCalendarPage> {
  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF1565C0);

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _selectedCourtId;

  final _courts = ['Tất cả', 'Sân A (5)', 'Sân B (7)', 'Cầu Lông', 'Sân Tennis'];
  final _courtIds = [null, 'c1', 'c2', 'c3', 'c4'];

  List<OwnerBookingModel> get _mockBookings => _buildMockBookings();
  List<OwnerBookingModel> _buildMockBookings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      OwnerBookingModel(
          id: 'b1',
          bookingCode: 'DS24800101',
          customerId: 'u1',
          customerName: 'Nguyễn Văn An',
          customerPhone: '0912345678',
          courtId: 'c1',
          courtName: 'Sân A (5)',
          venueId: widget.venueId,
          bookingDate: today,
          startTime: '18:00',
          endTime: '19:30',
          status: BookingStatus.PENDING,
          totalHours: 1.5,
          pricePerHour: 150000,
          subTotal: 225000,
          totalAmount: 225000,
          commissionAmount: 22500,
          createdAt: now.subtract(const Duration(hours: 2))),
      OwnerBookingModel(
          id: 'b2',
          bookingCode: 'DS24800102',
          customerId: 'u2',
          customerName: 'Lê Thị Bình',
          customerPhone: '0987654321',
          courtId: 'c2',
          courtName: 'Sân B (7)',
          venueId: widget.venueId,
          bookingDate: today,
          startTime: '20:00',
          endTime: '21:30',
          status: BookingStatus.CONFIRMED,
          totalHours: 1.5,
          pricePerHour: 200000,
          subTotal: 300000,
          totalAmount: 300000,
          commissionAmount: 30000,
          createdAt: now.subtract(const Duration(hours: 5))),
      OwnerBookingModel(
          id: 'b3',
          bookingCode: 'DS24800103',
          customerId: 'u3',
          customerName: 'Phạm Văn Cường',
          courtId: 'c1',
          courtName: 'Sân A (5)',
          venueId: widget.venueId,
          bookingDate: today.add(const Duration(days: 1)),
          startTime: '06:00',
          endTime: '07:30',
          status: BookingStatus.CONFIRMED,
          totalHours: 1.5,
          pricePerHour: 120000,
          subTotal: 180000,
          totalAmount: 180000,
          commissionAmount: 18000,
          createdAt: now.subtract(const Duration(hours: 12))),
      OwnerBookingModel(
          id: 'b4',
          bookingCode: 'DS24800104',
          customerId: 'u4',
          customerName: 'Hoàng Minh Đức',
          courtId: 'c3',
          courtName: 'Cầu Lông',
          venueId: widget.venueId,
          bookingDate: today,
          startTime: '09:00',
          endTime: '10:00',
          status: BookingStatus.COMPLETED,
          totalHours: 1.0,
          pricePerHour: 100000,
          subTotal: 100000,
          totalAmount: 100000,
          commissionAmount: 10000,
          createdAt: now.subtract(const Duration(days: 1))),
      OwnerBookingModel(
          id: 'b5',
          bookingCode: 'DS24800105',
          customerId: 'u5',
          customerName: 'Trần Văn Em',
          courtId: 'c2',
          courtName: 'Sân B (7)',
          venueId: widget.venueId,
          bookingDate: today.add(const Duration(days: 2)),
          startTime: '17:00',
          endTime: '19:00',
          status: BookingStatus.PENDING,
          totalHours: 2.0,
          pricePerHour: 200000,
          subTotal: 400000,
          totalAmount: 400000,
          commissionAmount: 40000,
          createdAt: now.subtract(const Duration(hours: 1))),
    ];
  }

  List<OwnerBookingModel> get _dayBookings {
    final sel = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    return _mockBookings.where((b) {
      final bd = DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day);
      final matchDay = bd == sel;
      final matchCourt = _selectedCourtId == null || b.courtId == _selectedCourtId;
      return matchDay && matchCourt;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Set<DateTime> get _daysWithBookings {
    return _mockBookings
        .map((b) => DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day))
        .toSet();
  }

  Set<DateTime> get _daysWithPending {
    return _mockBookings
        .where((b) => b.status == BookingStatus.PENDING)
        .map((b) => DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        // ── AppBar ──
        SliverAppBar(
          pinned: true,
          expandedHeight: 100,
          backgroundColor: _brand,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('Lịch đặt sân',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_brandDark, _brand],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 38),
                    // const Text('Quản lý đặt sân',
                    //     style: TextStyle(
                    //         color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    // Text(widget.venueName,
                    //     style: const TextStyle(
                    //         color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 16),
                    Row(children: [
                      BookingStatusDot(color: AppColors.warning, label: 'Chờ XN'),
                      SizedBox(width: 12),
                      BookingStatusDot(color: AppColors.info, label: 'Đã XN'),
                      SizedBox(width: 12),
                      BookingStatusDot(color: AppColors.success, label: 'Hoàn thành'),
                    ]),
                  ]),
                ),
              ),
            ),
          ),
        ),

        // ── Court filter ──
        SliverToBoxAdapter(
            child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    _courts.length,
                    (i) => GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedCourtId = _courtIds[i]);
                          },
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                  color: _selectedCourtId == _courtIds[i] ? _brand : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: _selectedCourtId == _courtIds[i]
                                          ? _brand
                                          : AppColors.borderLight)),
                              child: Text(_courts[i],
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedCourtId == _courtIds[i]
                                          ? Colors.white
                                          : AppColors.textSecondary))),
                        )),
              )),
        )),

        // ── Calendar ──
        SliverToBoxAdapter(
            child: Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: CalendarView(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            daysWithBookings: _daysWithBookings,
            daysWithPending: _daysWithPending,
            onDaySelected: (sel, foc) => setState(() {
              _selectedDay = sel;
              _focusedDay = foc;
            }),
            onPageChanged: (foc) => setState(() => _focusedDay = foc),
          ),
        )),

        // ── Selected day header ──
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          child: Row(children: [
            Text(DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_selectedDay),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: _brand.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${_dayBookings.length} booking',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))),
          ]),
        )),

        // ── Booking list for selected day ──
        _dayBookings.isEmpty
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(32),
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.event_available_rounded, size: 40, color: AppColors.textHint),
                      SizedBox(height: 8),
                      Text('Không có booking ngày này', style: TextStyle(color: AppColors.textHint))
                    ])))
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (_, i) => BookingTimeCard(
                    booking: _dayBookings[i],
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OwnerBookingDetailPage(
                                bookingId: _dayBookings[i].id, booking: _dayBookings[i]))),
                  ),
                  childCount: _dayBookings.length,
                )),
              ),
      ]),
    );
  }
}
