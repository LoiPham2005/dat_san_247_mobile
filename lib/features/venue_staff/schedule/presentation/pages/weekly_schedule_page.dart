import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-06: Lịch Tuần — Weekly Calendar grid view
// DB: bookings (venue_id, date range week), courts, court_maintenance
// ══════════════════════════════════════════════════════════════════════════════
class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({super.key});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  static const Color _brand = Color(0xFF7C3AED);

  // Week navigation
  late DateTime _weekStart;
  String? _selectedCourtId;

  // Mock courts
  final _courts = [
    _CourtInfo('c1', 'Sân A'),
    _CourtInfo('c2', 'Sân B'),
    _CourtInfo('c3', 'Sân CL'),
  ];

  // Time slots (06:00 – 22:00, 30-min intervals)
  static final _slots = List.generate(32, (i) {
    final h = 6 + i ~/ 2;
    final m = (i % 2) * 30;
    return '${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}';
  });

  @override
  void initState() {
    super.initState();
    _weekStart = _getWeekStart(DateTime.now());
  }

  DateTime _getWeekStart(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - 1));

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  void _prevWeek() { HapticFeedback.selectionClick(); setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7))); }
  void _nextWeek() { HapticFeedback.selectionClick(); setState(() => _weekStart = _weekStart.add(const Duration(days: 7))); }
  void _today() { HapticFeedback.selectionClick(); setState(() => _weekStart = _getWeekStart(DateTime.now())); }

  // Mock booking data
  Map<String, Map<String, List<_SlotBooking>>> _buildMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final data = <String, Map<String, List<_SlotBooking>>>{};

    void add(String courtId, DateTime date, String start, String end, String name, String code, BookingStatusVS status) {
      final dk = DateFormat('yyyy-MM-dd').format(date);
      data.putIfAbsent(courtId, () => {});
      data[courtId]!.putIfAbsent(dk, () => []);
      data[courtId]![dk]!.add(_SlotBooking(start: start, end: end, customerName: name, bookingCode: code, status: status));
    }

    add('c1', today, '07:00', '08:30', 'Nguyễn An', 'DS001', BookingStatusVS.COMPLETED);
    add('c1', today, '09:00', '10:30', 'Trần Bình', 'DS002', BookingStatusVS.CHECKED_IN);
    add('c1', today, '18:00', '19:30', 'Phạm Cường', 'DS003', BookingStatusVS.CONFIRMED);
    add('c1', today, '20:00', '21:30', 'Lê Dũng', 'DS004', BookingStatusVS.CONFIRMED);
    add('c2', today, '08:00', '09:00', 'Hoàng Em', 'DS005', BookingStatusVS.COMPLETED);
    add('c2', today.add(const Duration(days: 1)), '07:00', '09:00', 'Vũ Phúc', 'DS006', BookingStatusVS.CONFIRMED);
    add('c3', today.subtract(const Duration(days: 1)), '06:00', '07:30', 'Bùi Hoàng', 'DS007', BookingStatusVS.COMPLETED);
    add('c1', today.add(const Duration(days: 2)), '19:00', '21:00', 'Trần X', 'DS008', BookingStatusVS.CONFIRMED);

    return data;
  }

  late final _mockData = _buildMockData();

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final displayedCourts = _selectedCourtId == null ? _courts : _courts.where((c) => c.id == _selectedCourtId).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(children: [
        // ── Header ──
        Container(
          color: _brand,
          child: SafeArea(
            bottom: false,
            child: Column(children: [
              // Title + nav
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Row(children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18)),
                  Expanded(child: Column(children: [
                    const Text('Lịch Tuần', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      '${DateFormat('dd/MM').format(_weekDays.first)} – ${DateFormat('dd/MM/yyyy').format(_weekDays.last)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ])),
                  TextButton(onPressed: _today, child: const Text('Hôm nay', style: TextStyle(color: Colors.white70, fontSize: 12))),
                ]),
              ),
              // Week navigation
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                child: Row(children: [
                  IconButton(onPressed: _prevWeek, icon: const Icon(Icons.chevron_left_rounded, color: Colors.white)),
                  Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: _weekDays.map((d) {
                      final isT = _isToday(d);
                      return GestureDetector(
                        onTap: () {},
                        child: Column(children: [
                          Text(DateFormat('E', 'vi').format(d), style: TextStyle(color: isT ? Colors.white : Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              color: isT ? Colors.white : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text('${d.day}', style: TextStyle(color: isT ? _brand : Colors.white, fontWeight: isT ? FontWeight.bold : FontWeight.normal, fontSize: 13))),
                          ),
                        ]),
                      );
                    }).toList()),
                  ),
                  IconButton(onPressed: _nextWeek, icon: const Icon(Icons.chevron_right_rounded, color: Colors.white)),
                ]),
              ),
              // Court filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Row(children: [
                  _CourtPill(label: 'Tất cả', selected: _selectedCourtId == null, brand: _brand, onTap: () => setState(() => _selectedCourtId = null)),
                  ..._courts.map((c) => _CourtPill(label: c.name, selected: _selectedCourtId == c.id, brand: _brand, onTap: () => setState(() => _selectedCourtId = c.id))),
                ]),
              ),
            ]),
          ),
        ),

        // ── Grid ──
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: _buildGrid(displayedCourts),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildGrid(List<_CourtInfo> courts) {
    const timeColW = 48.0;
    const cellW = 100.0;
    const cellH = 28.0;
    final totalW = timeColW + courts.length * 7 * cellW;

    return SizedBox(
      width: totalW,
      child: Column(children: [
        // ── Column headers: court × day ──
        Container(
          color: Colors.white,
          child: Row(children: [
            SizedBox(width: timeColW, child: const Center(child: Text('', style: TextStyle(fontSize: 10)))),
            ...courts.map((court) => SizedBox(
              width: 7 * cellW,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(court.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _brand)),
                ),
                Row(children: _weekDays.map((d) {
                  final isT = _isToday(d);
                  return SizedBox(
                    width: cellW,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      color: isT ? _brand.withOpacity(0.08) : null,
                      child: Center(child: Text(DateFormat('E\ndd/MM', 'vi').format(d),
                        style: TextStyle(fontSize: 9, color: isT ? _brand : AppColors.textHint, fontWeight: isT ? FontWeight.bold : FontWeight.normal),
                        textAlign: TextAlign.center)),
                    ),
                  );
                }).toList()),
              ]),
            )),
          ]),
        ),
        const Divider(height: 1, color: AppColors.borderLight),

        // ── Time rows ──
        ...List.generate(_slots.length, (slotIdx) {
          final slot = _slots[slotIdx];
          return Row(children: [
            SizedBox(width: timeColW, height: cellH,
              child: Center(child: Text(slot, style: const TextStyle(fontSize: 9, color: AppColors.textHint)))),
            ...courts.map((court) {
              return Row(children: _weekDays.map((d) {
                final dk = DateFormat('yyyy-MM-dd').format(d);
                final bookings = _mockData[court.id]?[dk] ?? [];
                final isT = _isToday(d);

                // Find booking at this slot
                final matching = bookings.where((b) {
                  return slot.compareTo(b.start) >= 0 && slot.compareTo(b.end) < 0;
                }).toList();

                return GestureDetector(
                  onTap: matching.isNotEmpty ? () => _showBookingTip(context, matching.first, court.name, d) : null,
                  child: Container(
                    width: cellW, height: cellH,
                    decoration: BoxDecoration(
                      color: matching.isNotEmpty ? _slotColor(matching.first.status) : (isT ? _brand.withOpacity(0.04) : Colors.white),
                      border: Border(
                        right: BorderSide(color: AppColors.borderLight, width: 0.5),
                        bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
                      ),
                    ),
                    child: matching.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              matching.first.customerName,
                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _slotTextColor(matching.first.status)),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList());
            }).toList(),
          ]);
        }),
      ]),
    );
  }

  Color _slotColor(BookingStatusVS s) => switch (s) {
    BookingStatusVS.COMPLETED  => AppColors.textHint.withOpacity(0.15),
    BookingStatusVS.CHECKED_IN => AppColors.success.withOpacity(0.2),
    BookingStatusVS.CONFIRMED  => _brand.withOpacity(0.15),
    BookingStatusVS.PENDING    => AppColors.warning.withOpacity(0.15),
    BookingStatusVS.CANCELLED  => AppColors.error.withOpacity(0.08),
    BookingStatusVS.NO_SHOW    => AppColors.error.withOpacity(0.15),
  };

  Color _slotTextColor(BookingStatusVS s) => switch (s) {
    BookingStatusVS.COMPLETED  => AppColors.textHint,
    BookingStatusVS.CHECKED_IN => AppColors.success,
    BookingStatusVS.CONFIRMED  => _brand,
    BookingStatusVS.PENDING    => AppColors.warning,
    _                          => AppColors.error,
  };

  void _showBookingTip(BuildContext context, _SlotBooking b, String courtName, DateTime date) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 14),
          Row(children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: _brand),
            const SizedBox(width: 8),
            Text(courtName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _brand)),
            const Spacer(),
            _StatusChip(status: b.status),
          ]),
          const SizedBox(height: 12),
          _BookingTipRow(icon: Icons.person_rounded, label: 'Khách', value: b.customerName),
          _BookingTipRow(icon: Icons.access_time_rounded, label: 'Giờ', value: '${b.start} – ${b.end}'),
          _BookingTipRow(icon: Icons.event_rounded, label: 'Ngày', value: DateFormat('EEEE, dd/MM', 'vi').format(date)),
          _BookingTipRow(icon: Icons.confirmation_number_rounded, label: 'Mã', value: b.bookingCode, isMono: true),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { Navigator.pop(ctx); },
            style: ElevatedButton.styleFrom(backgroundColor: _brand, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 12)),
            child: const Text('Xem chi tiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ]),
      ),
    );
  }
}

class _CourtInfo { final String id; final String name; const _CourtInfo(this.id, this.name); }
class _SlotBooking {
  final String start, end, customerName, bookingCode;
  final BookingStatusVS status;
  const _SlotBooking({required this.start, required this.end, required this.customerName, required this.bookingCode, required this.status});
}

class _CourtPill extends StatelessWidget {
  final String label;
  final bool selected;
  final Color brand;
  final VoidCallback onTap;
  const _CourtPill({required this.label, required this.selected, required this.brand, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? brand : Colors.white70)),
    ),
  );
}

class _StatusChip extends StatelessWidget {
  final BookingStatusVS status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      BookingStatusVS.COMPLETED  => (AppColors.textHint, 'Xong'),
      BookingStatusVS.CHECKED_IN => (AppColors.success, '✓ Check-in'),
      BookingStatusVS.CONFIRMED  => (const Color(0xFF7C3AED), '✓ Đã XN'),
      BookingStatusVS.PENDING    => (AppColors.warning, 'Chờ XN'),
      BookingStatusVS.CANCELLED  => (AppColors.error, 'Huỷ'),
      BookingStatusVS.NO_SHOW    => (AppColors.error, 'No-show'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _BookingTipRow extends StatelessWidget {
  final IconData icon; final String label, value; final bool isMono;
  const _BookingTipRow({required this.icon, required this.label, required this.value, this.isMono = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Icon(icon, size: 14, color: AppColors.textHint),
      const SizedBox(width: 10),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: isMono ? 'monospace' : null)),
    ]),
  );
}
