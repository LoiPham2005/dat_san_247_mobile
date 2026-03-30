import 'package:dat_san_247_mobile/core/base/di/injection.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/core/base/state/base_status.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_booking_stats.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_mini_chart.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_pending_booking_card.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_quick_actions_grid.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_revenue_card.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_review_card.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_section_header.dart';
import 'package:dat_san_247_mobile/features/owner/review/presentation/pages/owner_reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ──────────────────────────────────────────────────────────────────────────
// O-01: Owner Dashboard
// ──────────────────────────────────────────────────────────────────────────
class OwnerDashboardPage extends StatelessWidget {
  final Function(int index)? onTabChange;
  const OwnerDashboardPage({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardCubit>()..init(),
      child: _OwnerDashboardView(onTabChange: onTabChange),
    );
  }
}

class _OwnerDashboardView extends StatefulWidget {
  final Function(int index)? onTabChange;
  const _OwnerDashboardView({this.onTabChange});

  @override
  State<_OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<_OwnerDashboardView> {
  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: BlocBuilder<DashboardCubit, BaseState<DashboardState>>(
        builder: (context, state) {
          if (state.status == BaseStatus.initial || (state.isLoading && !state.hasData)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error ?? 'Đã xảy ra lỗi'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardCubit>().init(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final data = state.data!;
          if (data.venues.isEmpty && state.isEmpty) {
            return const Center(child: Text('Bạn chưa có sân nào để quản lý'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                _buildHeader(data),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(child: _buildBody(data)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DashboardState data) {
    final selectedVenue = data.selectedVenue;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 180,
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
        IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
          onPressed: () => context.push('/profile-settings'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Xin chào 👋',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(selectedVenue?.name ?? 'Đang tải...',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    if (data.venues.length > 1)
                      IconButton(
                        icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
                        onPressed: () => _showVenueSelector(data),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatsBar(data),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _showVenueSelector(DashboardState data) {
    final cubit = context.read<DashboardCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Chọn sân quản lý', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...data.venues.map((v) => ListTile(
                    leading: const Icon(Icons.stadium_rounded, color: _brand),
                    title: Text(v.name),
                    subtitle: Text('${v.district}, ${v.city}'),
                    trailing: v.id == data.selectedVenue?.id ? const Icon(Icons.check_circle, color: _brand) : null,
                    onTap: () {
                      cubit.selectVenue(v);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar(DashboardState data) {
    final stats = data.stats;
    return Row(children: [
      _statItem(
          value: '${stats?.totalToday ?? 0}', label: 'Hôm nay', icon: Icons.calendar_today_rounded),
      _vDivider(),
      _statItem(
          value: '${stats?.pending ?? 0}',
          label: 'Chờ xử lý',
          icon: Icons.hourglass_top_rounded,
          color: AppColors.warning),
      _vDivider(),
      _statItem(
          value: _fmtK(data.revenue?.revenueToday ?? 0),
          label: 'Doanh thu',
          icon: Icons.payments_rounded,
          color: const Color(0xFF34D399)),
    ]);
  }

  Widget _statItem(
          {required String value, required String label, required IconData icon, Color? color}) =>
      Expanded(
        child: Column(children: [
          Icon(icon, size: 16, color: color ?? Colors.white70),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color ?? Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 8)),
        ]),
      );

  Widget _vDivider() => Container(
      height: 32,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(horizontal: 5));

  Widget _buildBody(DashboardState data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.revenue != null)
          DashboardRevenueCard(
            revenue: {
              'today': data.revenue!.revenueToday,
              'thisMonth': data.revenue!.revenueThisMonth,
              'lastMonth': data.revenue!.revenueLastMonth,
              'ownerReceives': data.revenue!.ownerReceivesThisMonth,
              'platformFee': data.revenue!.platformFeeThisMonth,
              'bookingCount': data.revenue!.bookingCountThisMonth,
            },
          ),
        const SizedBox(height: 16),
        if (data.stats != null)
          DashboardBookingStats(
            stats: {
              'total': data.stats!.totalToday,
              'pending': data.stats!.pending,
              'confirmed': data.stats!.confirmed,
              'checkedIn': data.stats!.checkedIn,
              'completed': data.stats!.completed,
              'cancelled': data.stats!.cancelled,
            },
          ),
        const SizedBox(height: 16),
        const DashboardMiniChart(),
        const SizedBox(height: 24),
        DashboardQuickActionsGrid(
          venueId: data.selectedVenue?.id ?? '',
          venueName: data.selectedVenue?.name ?? '',
        ),
        const SizedBox(height: 24),

        // ── Pending bookings ──
        DashboardSectionHeader(
          title: 'Chờ xác nhận (${data.pendingBookings.length})',
          icon: Icons.pending_actions_rounded,
          color: AppColors.warning,
          action: 'Xem tất cả',
          onAction: () => widget.onTabChange?.call(1),
        ),
        const SizedBox(height: 10),
        if (data.pendingBookings.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Không có đơn nào chờ xác nhận'))),
        ...data.pendingBookings.map((b) => DashboardPendingBookingCard(
              booking: {
                'id': b.id,
                'code': b.bookingCode,
                'court': b.courtName,
                'customer': b.customerName,
                'phone': b.customerPhone ?? '',
                'date': b.bookingDate != null ? DateFormat('dd/MM/yyyy').format(b.bookingDate!) : '...',
                'time': '${b.startTime} - ${b.endTime}',
                'amount': b.totalAmount,
                'method': b.paymentMethod,
                'ago': b.createdAt != null ? _timeAgo(b.createdAt!) : '...',
              },
              onAccept: () => _handleAccept(b.id, b.bookingCode),
              onReject: () => _handleReject(b.id, b.bookingCode),
            )),
        const SizedBox(height: 24),

        // ── Recent reviews ──
        DashboardSectionHeader(
          title: 'Đánh giá mới nhất',
          icon: Icons.star_rounded,
          color: AppColors.warning,
          action: 'Xem tất cả',
          onAction: () => _replyReview('', data.selectedVenue?.id ?? '', data.selectedVenue?.name ?? ''),
        ),
        const SizedBox(height: 10),
        if (data.recentReviews.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Chưa có đánh giá nào'))),
        ...data.recentReviews.map((r) => DashboardReviewCard(
            review: {
              'id': r.id,
              'venue': r.venueName,
              'reviewer': r.reviewerName,
              'rating': r.overallRating,
              'comment': r.comment ?? '',
              'replied': r.hasReplied,
              'ago': r.createdAt != null ? _timeAgo(r.createdAt!) : '...',
            },
            onReply: () => _replyReview(r.id, data.selectedVenue?.id ?? '', data.selectedVenue?.name ?? ''))),
      ],
    );
  }

  String _fmtK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays} ngày';
    if (diff.inHours > 0) return '${diff.inHours} giờ';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút';
    return 'Vừa xong';
  }

  void _handleAccept(String id, String code) {
    context.read<DashboardCubit>().acceptBooking(id);
  }

  void _handleReject(String id, String code) {
    context.read<DashboardCubit>().rejectBooking(id);
  }

  void _replyReview(String id, String venueId, String venueName) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OwnerReviewsPage(venueId: venueId, venueName: venueName)));
  }
}
