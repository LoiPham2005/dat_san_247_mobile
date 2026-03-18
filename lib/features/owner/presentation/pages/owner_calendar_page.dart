import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/data/models/owner_extended_models.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_booking_detail_page.dart';

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
  static const Color _brand = Color(0xFF0891B2);
  static const Color _brandDark = Color(0xFF0E7490);

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
      OwnerBookingModel(id:'b1', bookingCode:'DS24800101', customerId:'u1', customerName:'Nguyễn Văn An', customerPhone:'0912345678', courtId:'c1', courtName:'Sân A (5)', venueId:widget.venueId, bookingDate:today, startTime:'18:00', endTime:'19:30', status:BookingStatus.PENDING, totalHours:1.5, pricePerHour:150000, subTotal:225000, totalAmount:225000, commissionAmount:22500, createdAt:now.subtract(const Duration(hours:2))),
      OwnerBookingModel(id:'b2', bookingCode:'DS24800102', customerId:'u2', customerName:'Lê Thị Bình', customerPhone:'0987654321', courtId:'c2', courtName:'Sân B (7)', venueId:widget.venueId, bookingDate:today, startTime:'20:00', endTime:'21:30', status:BookingStatus.CONFIRMED, totalHours:1.5, pricePerHour:200000, subTotal:300000, totalAmount:300000, commissionAmount:30000, createdAt:now.subtract(const Duration(hours:5))),
      OwnerBookingModel(id:'b3', bookingCode:'DS24800103', customerId:'u3', customerName:'Phạm Văn Cường', courtId:'c1', courtName:'Sân A (5)', venueId:widget.venueId, bookingDate:today.add(const Duration(days:1)), startTime:'06:00', endTime:'07:30', status:BookingStatus.CONFIRMED, totalHours:1.5, pricePerHour:120000, subTotal:180000, totalAmount:180000, commissionAmount:18000, createdAt:now.subtract(const Duration(hours:12))),
      OwnerBookingModel(id:'b4', bookingCode:'DS24800104', customerId:'u4', customerName:'Hoàng Minh Đức', courtId:'c3', courtName:'Cầu Lông', venueId:widget.venueId, bookingDate:today, startTime:'09:00', endTime:'10:00', status:BookingStatus.COMPLETED, totalHours:1.0, pricePerHour:100000, subTotal:100000, totalAmount:100000, commissionAmount:10000, createdAt:now.subtract(const Duration(days:1))),
      OwnerBookingModel(id:'b5', bookingCode:'DS24800105', customerId:'u5', customerName:'Trần Văn Em', courtId:'c2', courtName:'Sân B (7)', venueId:widget.venueId, bookingDate:today.add(const Duration(days:2)), startTime:'17:00', endTime:'19:00', status:BookingStatus.PENDING, totalHours:2.0, pricePerHour:200000, subTotal:400000, totalAmount:400000, commissionAmount:40000, createdAt:now.subtract(const Duration(hours:1))),
    ];
  }

  List<OwnerBookingModel> get _dayBookings {
    final sel = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    return _mockBookings.where((b) {
      final bd = DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day);
      final matchDay = bd == sel;
      final matchCourt = _selectedCourtId == null || b.courtId == _selectedCourtId;
      return matchDay && matchCourt;
    }).toList()..sort((a,b) => a.startTime.compareTo(b.startTime));
  }

  Set<DateTime> get _daysWithBookings {
    return _mockBookings.map((b) => DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day)).toSet();
  }

  Set<DateTime> get _daysWithPending {
    return _mockBookings.where((b) => b.status == BookingStatus.PENDING).map((b) => DateTime(b.bookingDate.year, b.bookingDate.month, b.bookingDate.day)).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(slivers: [
        // ── AppBar ──
        SliverAppBar(
          pinned: true, expandedHeight: 130, backgroundColor: _brand,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [_brandDark, _brand], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 46, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.venueName, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
                const Text('Lịch Booking', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Row(children: [
                  _HDot(AppColors.warning, 'Chờ xác nhận'), const SizedBox(width: 12),
                  _HDot(AppColors.info, 'Đã xác nhận'), const SizedBox(width: 12),
                  _HDot(AppColors.success, 'Hoàn thành'),
                ]),
              ]))),
            ),
            title: const Text('Lịch Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),

        // ── Court filter ──
        SliverToBoxAdapter(child: Container(
          color: Colors.white, padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
            children: List.generate(_courts.length, (i) => GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedCourtId = _courtIds[i]); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 150), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: _selectedCourtId == _courtIds[i] ? _brand : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _selectedCourtId == _courtIds[i] ? _brand : AppColors.borderLight)),
                child: Text(_courts[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _selectedCourtId == _courtIds[i] ? Colors.white : AppColors.textSecondary))),
            )),
          )),
        )),

        // ── Calendar ──
        SliverToBoxAdapter(child: Container(
          color: Colors.white, margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: _CalendarView(
            focusedDay: _focusedDay, selectedDay: _selectedDay,
            daysWithBookings: _daysWithBookings, daysWithPending: _daysWithPending,
            onDaySelected: (sel, foc) => setState(() { _selectedDay = sel; _focusedDay = foc; }),
            onPageChanged: (foc) => setState(() => _focusedDay = foc),
          ),
        )),

        // ── Selected day header ──
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          child: Row(children: [
            Text(DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_selectedDay), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: _brand.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('${_dayBookings.length} booking', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0891B2)))),
          ]),
        )),

        // ── Booking list for selected day ──
        _dayBookings.isEmpty
            ? SliverFillRemaining(hasScrollBody: false, child: Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.event_available_rounded, size: 40, color: AppColors.textHint), SizedBox(height: 8), Text('Không có booking ngày này', style: TextStyle(color: AppColors.textHint))])))
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                sliver: SliverList(delegate: SliverChildBuilderDelegate(
                  (_, i) => _BookingTimeCard(
                    booking: _dayBookings[i],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OwnerBookingDetailPage(bookingId: _dayBookings[i].id, booking: _dayBookings[i]))),
                  ),
                  childCount: _dayBookings.length,
                )),
              ),
      ]),
    );
  }
}

// ── Simple custom calendar view ───────────────────────────────────────────────
class _CalendarView extends StatelessWidget {
  final DateTime focusedDay, selectedDay;
  final Set<DateTime> daysWithBookings, daysWithPending;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;
  const _CalendarView({required this.focusedDay, required this.selectedDay, required this.daysWithBookings, required this.daysWithPending, required this.onDaySelected, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7;
    final days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return Column(children: [
      // Month navigation
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: Row(children: [
        GestureDetector(onTap: () => onPageChanged(DateTime(focusedDay.year, focusedDay.month - 1)), child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0891B2))),
        Expanded(child: Text(DateFormat('MMMM yyyy', 'vi').format(focusedDay), textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        GestureDetector(onTap: () => onPageChanged(DateTime(focusedDay.year, focusedDay.month + 1)), child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF0891B2))),
      ])),
      // Day headers
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(children: days.map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textHint))))).toList())),
      const SizedBox(height: 6),
      // Day cells
      Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 10), child: GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 2, childAspectRatio: 1.1),
        itemCount: startWeekday + daysInMonth,
        itemBuilder: (_, idx) {
          if (idx < startWeekday) return const SizedBox();
          final day = idx - startWeekday + 1;
          final date = DateTime(focusedDay.year, focusedDay.month, day);
          final dateKey = DateTime(date.year, date.month, date.day);
          final isSelected = date.day == selectedDay.day && date.month == selectedDay.month && date.year == selectedDay.year;
          final isToday = date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year;
          final hasBooking = daysWithBookings.contains(dateKey);
          final hasPending = daysWithPending.contains(dateKey);
          return GestureDetector(
            onTap: () => onDaySelected(date, date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(color: isSelected ? brand : isToday ? brand.withOpacity(0.1) : Colors.transparent, shape: BoxShape.circle),
              child: Stack(alignment: Alignment.center, children: [
                Center(child: Text('$day', style: TextStyle(fontSize: 12, fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : isToday ? brand : AppColors.textPrimary))),
                if (hasBooking && !isSelected) Positioned(bottom: 2, child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 4, height: 4, decoration: BoxDecoration(color: hasPending ? AppColors.warning : AppColors.info, shape: BoxShape.circle)),
                ])),
              ]),
            ),
          );
        },
      )),
    ]);
  }
}

class _BookingTimeCard extends StatelessWidget {
  final OwnerBookingModel booking;
  final VoidCallback onTap;
  const _BookingTimeCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF0891B2);
    final statusColor = switch (booking.status) {
      BookingStatus.PENDING    => AppColors.warning,
      BookingStatus.CONFIRMED  => AppColors.info,
      BookingStatus.CHECKED_IN => brand,
      BookingStatus.COMPLETED  => AppColors.success,
      BookingStatus.CANCELLED  => AppColors.error,
      BookingStatus.NO_SHOW    => AppColors.textHint,
    };
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
        child: Row(children: [
          Container(width: 5, decoration: BoxDecoration(color: statusColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)))),
          Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 10), child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(booking.startTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              Text(booking.endTime, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(booking.customerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(booking.courtName, style: TextStyle(fontSize: 11, color: brand)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(booking.status.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor))),
              const SizedBox(height: 4),
              Text(_fmt(booking.totalAmount), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textHint),
          ]))),
        ]),
      ),
    );
  }

  String _fmt(double v) { if (v >= 1000000) return '${(v/1000000).toStringAsFixed(1)}M'; if (v >= 1000) return '${(v/1000).round()}K'; return v.toStringAsFixed(0); }
}

class _HDot extends StatelessWidget {
  final Color color; final String label; const _HDot(this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold))]);
}
