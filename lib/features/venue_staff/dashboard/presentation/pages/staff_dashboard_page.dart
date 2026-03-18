import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/today_schedule_page.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-01 Staff Dashboard Page
// ══════════════════════════════════════════════════════════════════════════════
class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  static const Color _brand = Color(0xFF7C3AED);
  static const Color _brandDark = Color(0xFF4C1D95);

  late final StaffDashboardModel _data = _buildMock();

  // ── Mock data (replace with API call) ─────────────────────────────────────
  static StaffDashboardModel _buildMock() {
    final now = DateTime.now();
    return StaffDashboardModel(
      venueId: 'v1',
      venueName: 'Sân K34 Phạm Văn Đồng',
      venueAddress: '34 Phạm Văn Đồng, Cầu Giấy, HN',
      date: now,
      totalBookingsToday: 12,
      pendingCount: 2,
      confirmedCount: 3,
      checkedInCount: 4,
      completedCount: 3,
      noShowCount: 1,
      revenueToday: 1650000,
      revenuePending: 675000,
      staffName: 'Trần Thị Nhân Viên',
      staffRole: 'STAFF',
      shiftStart: '14:00',
      shiftEnd: '22:00',
      maintenanceToday: [
        CourtMaintenanceModel(
          id: 'm1', courtId: 'c3',
          startAt: DateTime(now.year, now.month, now.day, 8, 0),
          endAt: DateTime(now.year, now.month, now.day, 11, 0),
          reason: 'Thay lưới cầu lông định kỳ', isEmergency: false,
        ),
      ],
      courts: [
        CourtStatusModel(id: 'c1', name: 'Sân A', isIndoor: false, isActive: true, surfaceType: 'ARTIFICIAL_GRASS', size: '5 người', pricePerHour: 150000, displayOrder: 1, currentBookingId: 'b2', currentCustomerName: 'Trần Thị Bình', currentCustomerPhone: '0987654321', currentStartTime: '09:00', currentEndTime: '10:30', currentBookingCode: 'DS24799102', todayBookingCount: 4, todayCheckedInCount: 2),
        CourtStatusModel(id: 'c2', name: 'Sân B', isIndoor: false, isActive: true, surfaceType: 'ARTIFICIAL_GRASS', size: '7 người', pricePerHour: 200000, displayOrder: 2, nextCustomerName: 'Lê Hoàng Dũng', nextStartTime: '20:00', todayBookingCount: 3, todayCheckedInCount: 1),
        CourtStatusModel(id: 'c3', name: 'Sân CL', isIndoor: true, isActive: true, surfaceType: 'WOOD', size: 'Cầu Lông', pricePerHour: 80000, displayOrder: 3,
          activeMaintenance: CourtMaintenanceModel(id: 'm1', courtId: 'c3', startAt: DateTime(now.year, now.month, now.day, 8, 0), endAt: DateTime(now.year, now.month, now.day, 11, 0), reason: 'Thay lưới', isEmergency: false),
          todayBookingCount: 2, todayCheckedInCount: 1),
        CourtStatusModel(id: 'c4', name: 'Sân D', isIndoor: false, isActive: true, surfaceType: 'ARTIFICIAL_GRASS', size: '5 người', pricePerHour: 150000, displayOrder: 4, todayBookingCount: 3, todayCheckedInCount: 0),
      ],
    );
  }

  // ── Derived ────────────────────────────────────────────────────────────────
  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
      floatingActionButton: _buildQrFab(),
    );
  }

  // ── SliverAppBar header ────────────────────────────────────────────────────
  Widget _buildHeader() => SliverAppBar(
    pinned: true,
    expandedHeight: 172,
    backgroundColor: _brand,
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
        onPressed: () {},
      ),
    ],
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_brandDark, _brand],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 34),
              // Greeting row
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$_greeting, ${_data.staffName.split(' ').last}! 👋',
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(_data.venueName,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                ]),
                const Spacer(),
                // Shift badge
                if (_data.shiftStart != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.schedule_rounded, size: 13, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('${_data.shiftStart}–${_data.shiftEnd}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ]),
                  ),
              ]),
              const SizedBox(height: 14),
              // Quick stats row
              Row(children: [
                _HeaderStat(value: '${_data.totalBookingsToday}', label: 'Booking', icon: Icons.calendar_today_rounded),
                _vDivider(),
                _HeaderStat(value: '${_data.checkedInCount}', label: 'Check-in', icon: Icons.check_circle_rounded, color: AppColors.success),
                _vDivider(),
                _HeaderStat(value: '${_data.availableCourts}/${_data.courts.length}', label: 'Sân trống', icon: Icons.sports_soccer_rounded, color: const Color(0xFF38BDF8)),
                _vDivider(),
                _HeaderStat(value: _fmtK(_data.revenueToday), label: 'Doanh thu', icon: Icons.payments_rounded, color: const Color(0xFF34D399)),
              ]),
            ]),
          ),
        ),
      ),
      title: const Text('Staff Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
    ),
  );

  Widget _vDivider() => Container(height: 32, width: 1, color: Colors.white.withOpacity(0.2), margin: const EdgeInsets.symmetric(horizontal: 10));

  Widget _buildBody() => Padding(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ── Date bar ──
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
        child: Row(children: [
          const Icon(Icons.today_rounded, size: 16, color: Color(0xFF7C3AED)),
          const SizedBox(width: 8),
          Text(DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_data.date),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TodaySchedulePage())),
            child: Row(children: [
              Text('Xem lịch', style: TextStyle(fontSize: 12, color: _brand, fontWeight: FontWeight.bold)),
              Icon(Icons.chevron_right_rounded, size: 16, color: _brand),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 14),

      // ── Booking Status Summary ──
      _SectionTitle(title: 'Trạng thái booking hôm nay', action: ''),
      const SizedBox(height: 8),
      _bookingStatusGrid(),
      const SizedBox(height: 16),

      // ── Court Status ──
      _SectionTitle(title: 'Trạng thái sân hiện tại', action: '${_data.courts.length} sân'),
      const SizedBox(height: 8),
      _courtStatusGrid(),
      const SizedBox(height: 16),

      // ── Check-in Progress ──
      _CheckInProgressCard(data: _data, brand: _brand),
      const SizedBox(height: 16),

      // ── Maintenance alerts ──
      if (_data.maintenanceToday.isNotEmpty) ...[
        _SectionTitle(title: '🔧 Bảo trì hôm nay', action: ''),
        const SizedBox(height: 8),
        ..._data.maintenanceToday.map((m) => _MaintenanceCard(m: m)),
        const SizedBox(height: 16),
      ],

      // ── Revenue summary ──
      _RevenueSummaryCard(data: _data, brand: _brand),
    ]),
  );

  Widget _bookingStatusGrid() {
    final items = [
      _StatusItem('Chờ XN', _data.pendingCount, AppColors.warning, Icons.hourglass_empty_rounded),
      _StatusItem('Đã XN', _data.confirmedCount, AppColors.info, Icons.event_available_rounded),
      _StatusItem('Check-in', _data.checkedInCount, AppColors.success, Icons.how_to_reg_rounded),
      _StatusItem('Xong', _data.completedCount, AppColors.textHint, Icons.done_all_rounded),
      _StatusItem('No-show', _data.noShowCount, AppColors.error, Icons.person_off_rounded),
    ];
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = items[i];
          return Container(
            width: 86,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: item.color.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(item.icon, size: 20, color: item.color),
              const SizedBox(height: 4),
              Text('${item.count}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: item.color)),
              Text(item.label, style: TextStyle(fontSize: 9, color: item.color.withOpacity(0.8), fontWeight: FontWeight.bold)),
            ]),
          );
        },
      ),
    );
  }

  Widget _courtStatusGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.65,
      ),
      itemCount: _data.courts.length,
      itemBuilder: (_, i) => _CourtStatusCard(court: _data.courts[i], brand: _brand),
    );
  }

  Widget _buildQrFab() => FloatingActionButton.extended(
    onPressed: () {
      HapticFeedback.mediumImpact();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QrCheckInPage()));
    },
    backgroundColor: _brand,
    elevation: 6,
    icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
    label: const Text('Quét QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  );

  String _fmtK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatusItem {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  const _StatusItem(this.label, this.count, this.color, this.icon);
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  const _HeaderStat({required this.value, required this.label, required this.icon, this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Icon(icon, size: 14, color: color ?? Colors.white70),
      const SizedBox(height: 3),
      Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
    ]),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String action;
  const _SectionTitle({required this.title, required this.action});

  @override
  Widget build(BuildContext context) => Row(children: [
    Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
    const Spacer(),
    if (action.isNotEmpty)
      Text(action, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
  ]);
}

class _CourtStatusCard extends StatelessWidget {
  final CourtStatusModel court;
  final Color brand;
  const _CourtStatusCard({required this.court, required this.brand});

  @override
  Widget build(BuildContext context) {
    final status = court.statusNow;
    final (bgColor, dotColor, icon) = switch (status) {
      CourtStatusNow.available   => (AppColors.success.withOpacity(0.08), AppColors.success, Icons.sports_soccer_rounded),
      CourtStatusNow.occupied    => (brand.withOpacity(0.08), brand, Icons.people_rounded),
      CourtStatusNow.reserved    => (AppColors.warning.withOpacity(0.08), AppColors.warning, Icons.event_rounded),
      CourtStatusNow.maintenance => (AppColors.error.withOpacity(0.08), AppColors.error, Icons.build_rounded),
      CourtStatusNow.inactive    => (AppColors.textHint.withOpacity(0.08), AppColors.textHint, Icons.block_rounded),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dotColor.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(child: Text(court.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 14, color: dotColor),
          ),
        ]),
        const SizedBox(height: 4),
        Text(status.label, style: TextStyle(fontSize: 10, color: dotColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        // Context info
        if (status == CourtStatusNow.occupied && court.currentCustomerName != null)
          Text('👤 ${court.currentCustomerName}', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)
        else if (status == CourtStatusNow.reserved && court.nextStartTime != null)
          Text('⏰ ${court.nextStartTime} – ${court.nextCustomerName ?? ''}', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)
        else if (status == CourtStatusNow.maintenance)
          Text('🔧 ${court.activeMaintenance?.reason ?? ''}', style: const TextStyle(fontSize: 9, color: AppColors.error), overflow: TextOverflow.ellipsis, maxLines: 1)
        else
          Text('${court.todayBookingCount} booking hôm nay', style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        const SizedBox(height: 2),
        Row(children: [
          Icon(court.isIndoor ? Icons.roofing_rounded : Icons.wb_sunny_rounded, size: 9, color: AppColors.textHint),
          const SizedBox(width: 3),
          Text(court.size ?? (court.isIndoor ? 'Trong nhà' : 'Ngoài trời'), style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
        ]),
      ]),
    );
  }
}

class _CheckInProgressCard extends StatelessWidget {
  final StaffDashboardModel data;
  final Color brand;
  const _CheckInProgressCard({required this.data, required this.brand});

  @override
  Widget build(BuildContext context) {
    final rate = data.checkInRate;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.how_to_reg_rounded, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          const Text('Tỉ lệ Check-in hôm nay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('${data.checkedInCount}/${data.totalBookingsToday}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.success)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: rate.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
          ),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _ProgStat('${data.checkedInCount}\nCheck-in', AppColors.success),
          _ProgStat('${data.confirmedCount}\nChờ vào', AppColors.info),
          _ProgStat('${data.noShowCount}\nVắng mặt', AppColors.error),
          _ProgStat('${data.completedCount}\nHoàn thành', AppColors.textHint),
        ]),
      ]),
    );
  }
}

class _ProgStat extends StatelessWidget {
  final String text;
  final Color color;
  const _ProgStat(this.text, this.color);

  @override
  Widget build(BuildContext context) => Text(text,
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold, height: 1.5));
}

class _MaintenanceCard extends StatelessWidget {
  final CourtMaintenanceModel m;
  const _MaintenanceCard({required this.m});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: m.isEmergency ? AppColors.error.withOpacity(0.06) : AppColors.warning.withOpacity(0.06),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: (m.isEmergency ? AppColors.error : AppColors.warning).withOpacity(0.3)),
    ),
    child: Row(children: [
      Icon(m.isEmergency ? Icons.warning_rounded : Icons.build_rounded,
          size: 18, color: m.isEmergency ? AppColors.error : AppColors.warning),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(m.reason, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(
          '${DateFormat('HH:mm').format(m.startAt)} – ${DateFormat('HH:mm').format(m.endAt)}'
          '${m.isActiveNow ? '  ⏳ Đang diễn ra' : ''}',
          style: TextStyle(fontSize: 10, color: m.isEmergency ? AppColors.error : AppColors.warning),
        ),
      ])),
      if (m.isEmergency)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
          child: const Text('Khẩn cấp', style: TextStyle(fontSize: 9, color: AppColors.error, fontWeight: FontWeight.bold)),
        ),
    ]),
  );
}

class _RevenueSummaryCard extends StatelessWidget {
  final StaffDashboardModel data;
  final Color brand;
  const _RevenueSummaryCard({required this.data, required this.brand});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [brand.withOpacity(0.06), brand.withOpacity(0.02)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: brand.withOpacity(0.2)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.payments_rounded, size: 16, color: brand),
        const SizedBox(width: 6),
        const Text('Doanh thu hôm nay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _RevRow(label: 'Đã thu', value: data.revenueToday, color: AppColors.success)),
        Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2)),
        Expanded(child: _RevRow(label: 'Chờ thu', value: data.revenuePending, color: AppColors.warning)),
        Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2)),
        Expanded(child: _RevRow(label: 'Tổng', value: data.revenueToday + data.revenuePending, color: brand)),
      ]),
    ]),
  );
}

class _RevRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _RevRow({required this.label, required this.value, required this.color});

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(_fmt(value), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: color)),
    Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
  ]);
}
