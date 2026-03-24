import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_booking_stats.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_mini_chart.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_pending_booking_card.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_quick_actions_grid.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_revenue_card.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_review_card.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/widgets/dashboard_section_header.dart';
import 'package:dat_san_247_mobile/features/owner/review/presentation/pages/owner_reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ──────────────────────────────────────────────────────────────────────────
// O-01: Owner Dashboard
// ──────────────────────────────────────────────────────────────────────────
class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  static const Color _brand = Color(0xFF1565C0);
  static const Color _brandDark = Color(0xFF0D47A1);

  // ── Mock data ──────────────────────────────────────────────────────────
  final _venueName = 'Sân K34 Phạm Văn Đồng';
  final _ownerName = 'Trần Văn Bình';

  final _stats = {
    'total': 18,
    'pending': 3,
    'confirmed': 8,
    'checkedIn': 4,
    'completed': 2,
    'cancelled': 1,
  };

  final _revenue = {
    'today': 2700000.0,
    'thisMonth': 58500000.0,
    'lastMonth': 42000000.0,
    'ownerReceives': 49725000.0,
    'platformFee': 8775000.0,
    'bookingCount': 142,
  };

  final List<Map<String, dynamic>> _pendingBookings = [
    {
      'id': 'b1',
      'code': 'DS24799101',
      'court': 'Sân A - 5 người',
      'customer': 'Nguyễn Văn An',
      'phone': '0912345678',
      'date': '19/03/2026',
      'time': '18:00 - 19:30',
      'amount': 225000.0,
      'method': 'WALLET',
      'ago': '5 phút'
    },
    {
      'id': 'b2',
      'code': 'DS24799102',
      'court': 'Sân B - 7 người',
      'customer': 'Lê Thị Bình',
      'phone': '0987654321',
      'date': '19/03/2026',
      'time': '20:00 - 21:00',
      'amount': 200000.0,
      'method': 'MOMO',
      'ago': '12 phút'
    },
    {
      'id': 'b3',
      'code': 'DS24799103',
      'court': 'Sân Cầu Lông',
      'customer': 'Phạm Văn Cường',
      'phone': '0905123456',
      'date': '20/03/2026',
      'time': '06:00 - 07:30',
      'amount': 120000.0,
      'method': 'VNPAY',
      'ago': '28 phút'
    },
  ];

  final List<Map<String, dynamic>> _recentReviews = [
    {
      'id': 'r1',
      'venue': 'Sân K34',
      'reviewer': 'Nguyễn Văn A',
      'rating': 5,
      'comment': 'Sân đẹp lắm, dịch vụ tốt, sẽ quay lại!',
      'replied': false,
      'ago': '2 giờ'
    },
    {
      'id': 'r2',
      'venue': 'Sân K34',
      'reviewer': 'Trần Thị B',
      'rating': 4,
      'comment': 'Sân khá tốt nhưng ánh đèn hơi yếu.',
      'replied': true,
      'ago': '5 giờ'
    },
    {
      'id': 'r3',
      'venue': 'Sân K34',
      'reviewer': 'Lê Văn C',
      'rating': 3,
      'comment': 'Bãi đỗ xe hơi chật.',
      'replied': false,
      'ago': '1 ngày'
    },
  ];

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
    );
  }

  Widget _buildHeader() => SliverAppBar(
        pinned: true,
        expandedHeight: 210,
        backgroundColor: _brand,
        automaticallyImplyLeading: false,
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
                    Text('Xin chào, $_ownerName 👋',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(_venueName,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildStatsBar(),
                  ]),
                ),
              ),
            ),
            title: const Text('Dashboard 📊',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
            centerTitle: false,
          ),
      );

  Widget _buildStatsBar() => Row(children: [
        _statItem(value: '${_stats['total']}', label: 'Tổng booking', icon: Icons.calendar_today_rounded),
        _vDivider(),
        _statItem(
            value: '${_stats['pending']}',
            label: 'Chờ xác nhận',
            icon: Icons.hourglass_top_rounded,
            color: AppColors.warning),
        _vDivider(),
        _statItem(
            value: _fmtK((_revenue['today']?.toDouble() ?? 0.0)),
            label: 'Doanh thu',
            icon: Icons.payments_rounded,
            color: const Color(0xFF34D399)),
      ]);

  Widget _statItem({required String value, required String label, required IconData icon, Color? color}) =>
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
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 5));

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardRevenueCard(revenue: _revenue),
            const SizedBox(height: 16),
            DashboardBookingStats(stats: _stats),
            const SizedBox(height: 16),
            const DashboardMiniChart(),
            const SizedBox(height: 24),
            DashboardQuickActionsGrid(venueName: _venueName),
            const SizedBox(height: 24),

            // ── Pending bookings ──
            DashboardSectionHeader(
              title: 'Chờ xác nhận (${_pendingBookings.length})',
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
              action: 'Xem tất cả',
              onAction: () {},
            ),
            const SizedBox(height: 10),
            ..._pendingBookings.map((b) => DashboardPendingBookingCard(
                  booking: b,
                  onAccept: () => _handleAccept(b['id']),
                  onReject: () => _handleReject(b['id']),
                )),
            const SizedBox(height: 24),

            // ── Recent reviews ──
            DashboardSectionHeader(
              title: 'Đánh giá mới nhất',
              icon: Icons.star_rounded,
              color: AppColors.warning,
              action: 'Xem tất cả',
              onAction: () {},
            ),
            const SizedBox(height: 10),
            ..._recentReviews
                .map((r) => DashboardReviewCard(review: r, onReply: () => _replyReview(r['id']))),
          ],
        ),
      );

  String _fmtK(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}K';
    return v.toStringAsFixed(0);
  }

  void _handleAccept(String id) {
    setState(() => _pendingBookings.removeWhere((b) => b['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Đã xác nhận booking'), backgroundColor: AppColors.success));
  }

  void _handleReject(String id) {
    setState(() => _pendingBookings.removeWhere((b) => b['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Đã từ chối booking'), backgroundColor: AppColors.error));
  }

  void _replyReview(String id) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OwnerReviewsPage(venueId: 'v1', venueName: _venueName)));
  }
}
