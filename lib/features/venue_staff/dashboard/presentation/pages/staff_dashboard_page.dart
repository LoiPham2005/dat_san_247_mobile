import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_booking_status_summary.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_check_in_progress_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_court_status_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_header_stat.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_maintenance_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_revenue_summary_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_section_title.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/today_schedule_page.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ══════════════════════════════════════════════════════════════════════════════
// VS-01 Staff Dashboard Page
// ══════════════════════════════════════════════════════════════════════════════
@route
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
          id: 'm1',
          courtId: 'c3',
          startAt: DateTime(now.year, now.month, now.day, 8, 0),
          endAt: DateTime(now.year, now.month, now.day, 11, 0),
          reason: 'Thay lưới cầu lông định kỳ',
          isEmergency: false,
        ),
      ],
      courts: [
        const CourtStatusModel(
            id: 'c1',
            name: 'Sân A',
            isIndoor: false,
            isActive: true,
            surfaceType: 'ARTIFICIAL_GRASS',
            size: '5 người',
            pricePerHour: 150000,
            displayOrder: 1,
            currentBookingId: 'b2',
            currentCustomerName: 'Trần Thị Bình',
            currentCustomerPhone: '0987654321',
            currentStartTime: '09:00',
            currentEndTime: '10:30',
            currentBookingCode: 'DS24799102',
            todayBookingCount: 4,
            todayCheckedInCount: 2),
        const CourtStatusModel(
            id: 'c2',
            name: 'Sân B',
            isIndoor: false,
            isActive: true,
            surfaceType: 'ARTIFICIAL_GRASS',
            size: '7 người',
            pricePerHour: 200000,
            displayOrder: 2,
            nextCustomerName: 'Lê Hoàng Dũng',
            nextStartTime: '20:00',
            todayBookingCount: 3,
            todayCheckedInCount: 1),
        CourtStatusModel(
            id: 'c3',
            name: 'Sân CL',
            isIndoor: true,
            isActive: true,
            surfaceType: 'WOOD',
            size: 'Cầu Lông',
            pricePerHour: 80000,
            displayOrder: 3,
            activeMaintenance: CourtMaintenanceModel(
                id: 'm1',
                courtId: 'c3',
                startAt: DateTime(now.year, now.month, now.day, 8, 0),
                endAt: DateTime(now.year, now.month, now.day, 11, 0),
                reason: 'Thay lưới',
                isEmergency: false),
            todayBookingCount: 2,
            todayCheckedInCount: 1),
        const CourtStatusModel(
            id: 'c4',
            name: 'Sân D',
            isIndoor: false,
            isActive: true,
            surfaceType: 'ARTIFICIAL_GRASS',
            size: '5 người',
            pricePerHour: 150000,
            displayOrder: 4,
            todayBookingCount: 3,
            todayCheckedInCount: 0),
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
        expandedHeight: 170,
        backgroundColor: _brand,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Tổng quan hệ thống',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 38),
                  // Greeting row
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$_greeting, ${_data.staffName.split(' ').last}! 👋',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(_data.venueName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const Spacer(),
                    // Shift badge
                    if (_data.shiftStart != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.schedule_rounded, size: 13, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text('${_data.shiftStart}–${_data.shiftEnd}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  // Quick stats row
                  Row(children: [
                    DashboardHeaderStat(
                        value: '${_data.totalBookingsToday}',
                        label: 'Booking',
                        icon: Icons.calendar_today_rounded),
                    _vDivider(),
                    DashboardHeaderStat(
                        value: '${_data.checkedInCount}',
                        label: 'Check-in',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success),
                    _vDivider(),
                    DashboardHeaderStat(
                        value: '${_data.availableCourts}/${_data.courts.length}',
                        label: 'Sân trống',
                        icon: Icons.sports_soccer_rounded,
                        color: const Color(0xFF38BDF8)),
                    _vDivider(),
                    DashboardHeaderStat(
                        value: _fmtK(_data.revenueToday),
                        label: 'D.Thu',
                        icon: Icons.payments_rounded,
                        color: const Color(0xFF34D399)),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      );

  Widget _vDivider() => Container(
      height: 32,
      width: 1,
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 10));

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Date bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
            child: Row(children: [
              const Icon(Icons.today_rounded, size: 16, color: Color(0xFF7C3AED)),
              const SizedBox(width: 8),
              Text(DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_data.date),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const TodaySchedulePage())),
                child: const Row(children: [
                  Text('Xem lịch',
                      style: TextStyle(fontSize: 12, color: _brand, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right_rounded, size: 16, color: _brand),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 14),

          // ── Booking Status Summary ──
          const DashboardSectionTitle(title: 'Trạng thái booking hôm nay', action: ''),
          const SizedBox(height: 8),
          DashboardBookingStatusSummary(
            pendingCount: _data.pendingCount,
            confirmedCount: _data.confirmedCount,
            checkedInCount: _data.checkedInCount,
            completedCount: _data.completedCount,
            noShowCount: _data.noShowCount,
          ),
          const SizedBox(height: 16),

          // ── Court Status ──
          DashboardSectionTitle(title: 'Trạng thái sân hiện tại', action: '${_data.courts.length} sân'),
          const SizedBox(height: 8),
          _courtStatusGrid(),
          const SizedBox(height: 16),

          // ── Check-in Progress ──
          DashboardCheckInProgressCard(data: _data, brand: _brand),
          const SizedBox(height: 16),

          // ── Maintenance alerts ──
          if (_data.maintenanceToday.isNotEmpty) ...[
            const DashboardSectionTitle(title: '🔧 Bảo trì hôm nay', action: ''),
            const SizedBox(height: 8),
            ..._data.maintenanceToday.map((m) => DashboardMaintenanceCard(m: m)),
            const SizedBox(height: 16),
          ],

          // ── Revenue summary ──
          DashboardRevenueSummaryCard(data: _data, brand: _brand),
        ]),
      );

  Widget _courtStatusGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.65,
      ),
      itemCount: _data.courts.length,
      itemBuilder: (_, i) => DashboardCourtStatusCard(court: _data.courts[i], brand: _brand),
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
        label: const Text('Quét QR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );

  String _fmtK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }
}
