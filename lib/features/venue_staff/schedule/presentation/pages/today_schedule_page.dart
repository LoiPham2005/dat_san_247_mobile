import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/data/models/check_in_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';

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

    booking(String id, String code, String? qr, String court, String cId, String name, String phone,
        String start, String end, BookingStatusVS status, double amount, List<StaffBookingAddonModel> addons) =>
      CheckInBookingModel(
        id: id, bookingCode: code, checkInCode: qr,
        courtId: cId, courtName: court, isIndoor: false,
        venueName: 'Sân K34', venueAddress: '34 PVĐ, Hà Nội',
        customerId: 'u$id', customerName: name, customerPhone: phone,
        bookingDate: today, startTime: start, endTime: end,
        status: status, totalAmount: amount, addons: addons,
      );

    final sA = [
      booking('1', 'DS24799101', 'ABCD1234', 'Sân A - 5 người', 'c1', 'Nguyễn Văn An', '0912345678', '07:00', '08:30', BookingStatusVS.COMPLETED, 225000, []),
      booking('2', 'DS24799102', 'EFGH5678', 'Sân A - 5 người', 'c1', 'Trần Thị Bình', '0987654321', '09:00', '10:30', BookingStatusVS.CHECKED_IN, 225000, []),
      booking('3', 'DS24799103', 'IJKL9012', 'Sân A - 5 người', 'c1', 'Phạm Văn Cường', '0905123456', '18:00', '19:30', BookingStatusVS.CONFIRMED, 225000, [
        StaffBookingAddonModel(id: 'a1', bookingId: '3', serviceId: 's1', serviceName: 'Nước uống x2', quantity: 2, pricePerUnit: 15000, totalPrice: 30000),
      ]),
      booking('4', 'DS24799104', null, 'Sân A - 5 người', 'c1', 'Lê Hoàng Dũng', '0908765432', '20:00', '21:30', BookingStatusVS.CONFIRMED, 225000, []),
    ];

    final sB = [
      booking('5', 'DS24799105', 'MNOP3456', 'Sân B - 7 người', 'c2', 'Hoàng Thị Em', '0917234567', '08:00', '09:00', BookingStatusVS.COMPLETED, 200000, []),
      booking('6', 'DS24799106', null, 'Sân B - 7 người', 'c2', 'Vũ Văn Phúc', '0934567890', '17:00', '18:00', BookingStatusVS.CONFIRMED, 200000, []),
      booking('7', 'DS24799107', null, 'Sân B - 7 người', 'c2', 'Đinh Thị Giang', '0923456789', '14:00', '15:00', BookingStatusVS.NO_SHOW, 200000, []),
    ];

    final sCL = [
      booking('8', 'DS24799108', 'QRST7890', 'Sân Cầu Lông', 'c3', 'Bùi Huy Hoàng', '0901234567', '06:00', '07:30', BookingStatusVS.CHECKED_IN, 120000, []),
      booking('9', 'DS24799109', null, 'Sân Cầu Lông', 'c3', 'Cao Thị Inh', '0978901234', '19:00', '20:30', BookingStatusVS.CONFIRMED, 120000, []),
    ];

    return [
      TodayCourtScheduleModel(courtId: 'c1', courtName: 'Sân A - 5 người', isIndoor: false, bookings: sA),
      TodayCourtScheduleModel(courtId: 'c2', courtName: 'Sân B - 7 người', isIndoor: false, bookings: sB),
      TodayCourtScheduleModel(courtId: 'c3', courtName: 'Sân Cầu Lông', isIndoor: true, bookings: sCL),
    ];
  }

  List<TodayCourtScheduleModel> get _filtered => _selectedCourtId == null
      ? _schedules
      : _schedules.where((s) => s.courtId == _selectedCourtId).toList();

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
            expandedHeight: 150,
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 26),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QrCheckInPage())),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                        const SizedBox(height: 4),
                        const Text('Lịch Hôm Nay', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        Row(children: [
                          _MiniStat(value: '$_totalBookings', label: 'Tổng booking'),
                          const SizedBox(width: 16),
                          _MiniStat(value: '$_checkedInTotal', label: 'Check-in', color: AppColors.success),
                          const SizedBox(width: 16),
                          _MiniStat(value: '$_pendingTotal', label: 'Chờ vào', color: AppColors.warning),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Lịch Hôm Nay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  _CourtPill(label: 'Tất cả', selected: _selectedCourtId == null, onTap: () => setState(() => _selectedCourtId = null)),
                  ..._schedules.map((s) => _CourtPill(
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
                return _CourtTimelineSection(
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
                        SnackBar(content: Text('⚠️ Đã đánh NO_SHOW: ${booking.customerName}'), backgroundColor: AppColors.error),
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

// ── Court timeline section ────────────────────────────────────────────────
class _CourtTimelineSection extends StatelessWidget {
  final TodayCourtScheduleModel schedule;
  final Color brand;
  final void Function(CheckInBookingModel) onCheckIn;
  final void Function(CheckInBookingModel) onMarkNoShow;

  const _CourtTimelineSection({
    required this.schedule,
    required this.brand,
    required this.onCheckIn,
    required this.onMarkNoShow,
  });

  @override
  Widget build(BuildContext context) {
    // Sort bookings by startTime
    final sorted = [...schedule.bookings]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Court header ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [brand.withOpacity(0.12), brand.withOpacity(0.04)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: brand.withOpacity(0.2)),
            ),
            child: Row(children: [
              Icon(schedule.isIndoor ? Icons.roofing_rounded : Icons.sports_soccer_rounded, size: 18, color: brand),
              const SizedBox(width: 8),
              Expanded(child: Text(schedule.courtName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: brand))),
              _TinyBadge(text: '${schedule.checkedInCount}✓', color: AppColors.success),
              const SizedBox(width: 6),
              _TinyBadge(text: '${schedule.confirmedCount}⏳', color: AppColors.warning),
              if (schedule.bookings.any((b) => b.status == BookingStatusVS.NO_SHOW)) ...[
                const SizedBox(width: 6),
                _TinyBadge(text: '${schedule.bookings.where((b) => b.status == BookingStatusVS.NO_SHOW).length}⚠️', color: AppColors.error),
              ],
            ]),
          ),
          const SizedBox(height: 8),

          // ── Timeline rows ──
          ...sorted.asMap().entries.map((entry) {
            final i = entry.key;
            final b = entry.value;
            return _TimelineBookingRow(
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

class _TimelineBookingRow extends StatelessWidget {
  final CheckInBookingModel booking;
  final bool isFirst;
  final bool isLast;
  final Color brand;
  final VoidCallback onCheckIn;
  final VoidCallback onMarkNoShow;

  const _TimelineBookingRow({
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
              if (!isFirst) Container(width: 2, height: 8, color: Colors.grey.withOpacity(0.2)),
              Container(width: 12, height: 12, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: dotColor.withOpacity(0.4), blurRadius: 4)])),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.withOpacity(0.2))),
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
                    Text('${booking.startTime}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: brand)),
                    Text(' – ${booking.endTime}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    _StatusBadge(status: booking.status),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    CircleAvatar(
                      radius: 14, backgroundColor: brand.withOpacity(0.1),
                      child: Text(booking.customerName[0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brand)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(booking.customerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      if (booking.customerPhone != null)
                        Text(booking.customerPhone!, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                    ])),
                    Text(booking.bookingCode, style: const TextStyle(fontSize: 9, color: AppColors.textHint, fontFamily: 'monospace')),
                  ]),

                  if (booking.addons.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(spacing: 4, children: booking.addons.map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primaryLightBrand.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text('${a.serviceName} x${a.quantity}', style: const TextStyle(fontSize: 9, color: AppColors.primaryLightBrand, fontWeight: FontWeight.bold)),
                    )).toList()),
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
                            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.success.withOpacity(0.3))),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.qr_code_scanner_rounded, size: 14, color: AppColors.success),
                              SizedBox(width: 4),
                              Text('Check-in', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _confirmNoShow(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.error.withOpacity(0.25))),
                          child: const Row(children: [
                            Icon(Icons.person_off_rounded, size: 14, color: AppColors.error),
                            SizedBox(width: 4),
                            Text('No-show', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Icon(Icons.person_off_rounded, color: AppColors.error, size: 40),
          const SizedBox(height: 10),
          Text('Đánh NO-SHOW cho ${booking.customerName}?', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('Trường hợp: ${booking.startTime}–${booking.endTime} | ${booking.bookingCode}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Huỷ'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); onMarkNoShow(); },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Xác nhận', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatusVS status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      BookingStatusVS.COMPLETED => (AppColors.textHint, 'Xong'),
      BookingStatusVS.CHECKED_IN => (AppColors.success, '✓ Check-in'),
      BookingStatusVS.CONFIRMED => (AppColors.warning, '⏳ Chờ'),
      BookingStatusVS.PENDING => (AppColors.info, 'Pending'),
      BookingStatusVS.CANCELLED => (AppColors.error, 'Huỷ'),
      BookingStatusVS.NO_SHOW => (AppColors.error, '⚠ No-show'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _TinyBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _TinyBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
  );
}

class _CourtPill extends StatelessWidget {
  final String label;
  final bool selected;
  final int? checkedIn;
  final int? confirmed;
  final VoidCallback onTap;
  const _CourtPill({required this.label, required this.selected, this.checkedIn, this.confirmed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? brand : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? brand : Colors.grey.shade200, width: selected ? 0 : 1),
          boxShadow: selected ? [BoxShadow(color: brand.withOpacity(0.3), blurRadius: 6)] : [],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textSecondary)),
          if (checkedIn != null && checkedIn! > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: selected ? Colors.white.withOpacity(0.2) : AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text('$checkedIn✓', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.success)),
            ),
          ],
        ]),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;
  const _MiniStat({required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
    Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
  ]);
}
