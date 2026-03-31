import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/cubit/staff_dashboard_cubit.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/data/models/staff_dashboard_models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dat_san_247_mobile/routes/base/annotations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_booking_status_summary.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_check_in_progress_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_court_status_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_header_stat.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_maintenance_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_revenue_summary_card.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/widgets/dashboard_section_title.dart';
import 'package:dat_san_247_mobile/features/venue_staff/check_in/presentation/pages/qr_checkin_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/today_schedule_page.dart';

@route
class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  static const Color _brand = Color(0xFF7C3AED);
  static const Color _brandDark = Color(0xFF4C1D95);

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StaffDashboardCubit>()..initDashboard(),
      child: BlocBuilder<StaffDashboardCubit, BaseState<StaffDashboardState>>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: _brand)));
          }

          if (state.isFailure) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text('Lỗi: ${state.error ?? 'Đã xảy ra lỗi'}', 
                      style: const TextStyle(color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _brand),
                      onPressed: () => context.read<StaffDashboardCubit>().initDashboard(),
                      child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = state.data?.dashboardData;
          if (data == null) {
            return const Scaffold(body: Center(child: Text('Không có dữ liệu')));
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FA),
            body: RefreshIndicator(
              color: _brand,
              onRefresh: () => context.read<StaffDashboardCubit>().initDashboard(),
              child: CustomScrollView(
                slivers: [
                  _buildHeader(data),
                  SliverToBoxAdapter(child: _buildBody(context, data)),
                ],
              ),
            ),
            floatingActionButton: _buildQrFab(context),
          );
        },
      ),
    );
  }

  Widget _buildHeader(StaffDashboardModel data) => SliverAppBar(
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
                  Row(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$_greeting, ${data.staffName.split(' ').last}! 👋',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(data.venueName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const Spacer(),
                    if (data.shiftStart != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.schedule_rounded, size: 13, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text('${data.shiftStart}–${data.shiftEnd}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    DashboardHeaderStat(
                        value: '${data.totalBookingsToday}',
                        label: 'Booking',
                        icon: Icons.calendar_today_rounded),
                    _vDivider(),
                    DashboardHeaderStat(
                        value: '${data.checkedInCount}',
                        label: 'Check-in',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success),
                    _vDivider(),
                    DashboardHeaderStat(
                        value: '${data.availableCourts}/${data.courts.length}',
                        label: 'Sân trống',
                        icon: Icons.sports_soccer_rounded,
                        color: const Color(0xFF38BDF8)),
                    _vDivider(),
                    DashboardHeaderStat(
                        value: _fmtK(data.revenueToday),
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
      color: Colors.white.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(horizontal: 10));

  Widget _buildBody(BuildContext context, StaffDashboardModel data) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
            child: Row(children: [
              const Icon(Icons.today_rounded, size: 16, color: Color(0xFF7C3AED)),
              const SizedBox(width: 8),
              Text(DateFormat('EEEE, dd/MM/yyyy', 'vi').format(data.date),
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
          const DashboardSectionTitle(title: 'Trạng thái booking hôm nay', action: ''),
          const SizedBox(height: 8),
          DashboardBookingStatusSummary(
            pendingCount: data.pendingCount,
            confirmedCount: data.confirmedCount,
            checkedInCount: data.checkedInCount,
            completedCount: data.completedCount,
            noShowCount: data.noShowCount,
          ),
          const SizedBox(height: 16),
          DashboardSectionTitle(title: 'Trạng thái sân hiện tại', action: '${data.courts.length} sân'),
          const SizedBox(height: 8),
          _courtStatusGrid(data),
          const SizedBox(height: 16),
          DashboardCheckInProgressCard(data: data, brand: _brand),
          const SizedBox(height: 16),
          if (data.maintenanceToday.isNotEmpty) ...[
            const DashboardSectionTitle(title: '🔧 Bảo trì hôm nay', action: ''),
            const SizedBox(height: 8),
            ...data.maintenanceToday.map((m) => DashboardMaintenanceCard(m: m)),
            const SizedBox(height: 16),
          ],
          DashboardRevenueSummaryCard(data: data, brand: _brand),
        ]),
      );

  Widget _courtStatusGrid(StaffDashboardModel data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.65,
      ),
      itemCount: data.courts.length,
      itemBuilder: (_, i) => DashboardCourtStatusCard(court: data.courts[i], brand: _brand),
    );
  }

  Widget _buildQrFab(BuildContext context) => FloatingActionButton.extended(
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
