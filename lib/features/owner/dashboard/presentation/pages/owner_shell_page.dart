import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_venue_list_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_revenue_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_reviews_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_calendar_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_settings_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_venue_manage_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_venue_services_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_staff_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_verification_page.dart';
import 'package:dat_san_247_mobile/features/owner/presentation/pages/owner_refund_policy_page.dart';


// ──────────────────────────────────────────────────────────────────────────
// Owner Main Shell — Bottom navigation cho Owner
// 5 tabs: Dashboard · Booking · Venue · Doanh Thu · Cài Đặt
// ──────────────────────────────────────────────────────────────────────────
class OwnerShellPage extends StatefulWidget {
  const OwnerShellPage({super.key});

  @override
  State<OwnerShellPage> createState() => _OwnerShellPageState();
}

class _OwnerShellPageState extends State<OwnerShellPage> {
  int _currentIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<_NavItem> _navItems = const [
    _NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded),
    _NavItem(label: 'Booking', icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today_rounded),
    _NavItem(label: 'Sân', icon: Icons.sports_soccer_rounded, activeIcon: Icons.sports_soccer_rounded, isCenter: true),
    _NavItem(label: 'Doanh thu', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded),
    _NavItem(label: 'Cài đặt', icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded),
  ];

  late final List<Widget> _pages = [
    const OwnerDashboardPage(),
    const OwnerCalendarPage(venueId: 'v1', venueName: 'Venue Của Bạn'),
    const OwnerVenueListPage(),  // O-02 → O-03 → O-04 → O-05
    const OwnerRevenuePage(),
    const OwnerSettingsPage(),
  ];

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = 80 + MediaQuery.of(context).padding.bottom + 16;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: PageStorage(
          bucket: _bucket,
          child: _pages[_currentIndex],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              return item.isCenter ? _buildCenterBtn(i) : _buildNavItem(i, item);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem item) {
    final active = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: Icon(
                active ? item.activeIcon : item.icon,
                key: ValueKey(active),
                size: 24,
                color: active ? _ownerBrand : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? _ownerBrand : AppColors.textHint,
              ),
              child: Text(item.label),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 4 : 0, height: 4,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(color: _ownerBrand, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterBtn(int index) {
    final active = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 52, height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_ownerBrand.withOpacity(0.8), _ownerBrand],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _ownerBrand.withOpacity(active ? 0.5 : 0.3), blurRadius: active ? 16 : 8, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.stadium_rounded, color: AppColors.white, size: 26),
            ),
            const SizedBox(height: 3),
            Text('Sân', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: active ? _ownerBrand : AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  static const Color _ownerBrand = Color(0xFF1565C0); // Owner blue brand
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isCenter;
  const _NavItem({required this.label, required this.icon, required this.activeIcon, this.isCenter = false});
}


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

  // ── Mock data ──────────────────────────────────────────────────────────
  final _venueName = 'Sân K34 Phạm Văn Đồng';
  final _ownerName = 'Trần Văn Bình';

  final _stats = {
    'total': 18, 'pending': 3, 'confirmed': 8, 'checkedIn': 4, 'completed': 2, 'cancelled': 1,
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
    {'id': 'b1', 'code': 'DS24799101', 'court': 'Sân A - 5 người', 'customer': 'Nguyễn Văn An', 'phone': '0912345678', 'date': '19/03/2026', 'time': '18:00 - 19:30', 'amount': 225000.0, 'method': 'WALLET', 'ago': '5 phút'},
    {'id': 'b2', 'code': 'DS24799102', 'court': 'Sân B - 7 người', 'customer': 'Lê Thị Bình', 'phone': '0987654321', 'date': '19/03/2026', 'time': '20:00 - 21:00', 'amount': 200000.0, 'method': 'MOMO', 'ago': '12 phút'},
    {'id': 'b3', 'code': 'DS24799103', 'court': 'Sân Cầu Lông', 'customer': 'Phạm Văn Cường', 'phone': '0905123456', 'date': '20/03/2026', 'time': '06:00 - 07:30', 'amount': 120000.0, 'method': 'VNPAY', 'ago': '28 phút'},
  ];

  final List<Map<String, dynamic>> _recentReviews = [
    {'id': 'r1', 'venue': 'Sân K34', 'reviewer': 'Nguyễn Văn A', 'rating': 5, 'comment': 'Sân đẹp lắm, dịch vụ tốt, sẽ quay lại!', 'replied': false, 'ago': '2 giờ'},
    {'id': 'r2', 'venue': 'Sân K34', 'reviewer': 'Trần Thị B', 'rating': 4, 'comment': 'Sân khá tốt nhưng ánh đèn hơi yếu.', 'replied': true, 'ago': '5 giờ'},
    {'id': 'r3', 'venue': 'Sân K34', 'reviewer': 'Lê Văn C', 'rating': 3, 'comment': 'Bãi đỗ xe hơi chật.', 'replied': false, 'ago': '1 ngày'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: _brand,
            automaticallyImplyLeading: false,
            actions: [
              Stack(children: [
                IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.white), onPressed: () {}),
                Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle))),
              ]),
              IconButton(icon: const Icon(Icons.account_circle_outlined, color: AppColors.white), onPressed: () => context.push('/profile-settings')),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: AppColors.white.withOpacity(0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.stadium_rounded, color: AppColors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_venueName, style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text('Xin chào, $_ownerName 👋', style: const TextStyle(color: AppColors.white70, fontSize: 12)),
                            ],
                          )),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: Text(_venueName, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Revenue card ──
                  _RevenueCard(revenue: _revenue),
                  const SizedBox(height: 16),

                  // ── Booking today stats ──
                  _BookingStatsCard(stats: _stats),
                  const SizedBox(height: 16),

                  // ── Chart hint (7-day trend) ──
                  _MiniChart(),
                  const SizedBox(height: 24),

                  // ── Quick Actions / Phím Trực Tiếp (For easy access) ──
                  Row(children: [
                    const Icon(Icons.flash_on_rounded, size: 18, color: Color(0xFF1565C0)),
                    const SizedBox(width: 8),
                    const Text('Phím Tắt Quản Lý', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ]),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.1,
                    children: [
                      _QuickActionBtn(icon: Icons.stadium_rounded, label: 'Quản Lý\nVenue', color: const Color(0xFF0891B2), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OwnerVenueManagePage(venueId: 'v1')))),
                      _QuickActionBtn(icon: Icons.room_service_rounded, label: 'Dịch Vụ\nBán Kèm', color: const Color(0xFFE1306C), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OwnerVenueServicesPage(venueId: 'v1', venueName: 'Venue Của Bạn')))),
                      _QuickActionBtn(icon: Icons.people_rounded, label: 'Nhân\nViên', color: const Color(0xFF4267B2), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OwnerStaffPage(venueId: 'v1', venueName: 'Venue Của Bạn')))),
                      _QuickActionBtn(icon: Icons.verified_rounded, label: 'Xác Minh\nVenue', color: AppColors.success, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OwnerVerificationPage(venueId: 'v1', venueName: 'Venue Của Bạn')))),
                      _QuickActionBtn(icon: Icons.policy_rounded, label: 'Hoàn Tiền\n(Policy)', color: AppColors.warning, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OwnerRefundPolicyPage(venueId: 'v1', venueName: 'Venue Của Bạn')))),
                      _QuickActionBtn(icon: Icons.rate_review_rounded, label: 'Đánh Giá\n(Reviews)', color: const Color(0xFF9C27B0), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OwnerReviewsPage(venueId: 'v1', venueName: 'Venue Của Bạn')))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Pending bookings ──
                  _SectionHeader(
                    title: 'Chờ xác nhận (${_pendingBookings.length})',
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warning,
                    action: 'Xem tất cả',
                    onAction: () {},
                  ),
                  const SizedBox(height: 10),
                  ..._pendingBookings.map((b) => _PendingBookingCard(
                    booking: b,
                    onAccept: () => _handleAccept(b['id']),
                    onReject: () => _handleReject(b['id']),
                  )),
                  const SizedBox(height: 16),

                  // ── Recent reviews ──
                  _SectionHeader(
                    title: 'Đánh giá mới nhất',
                    icon: Icons.star_rounded,
                    color: AppColors.warning,
                    action: 'Xem tất cả',
                    onAction: () {},
                  ),
                  const SizedBox(height: 10),
                  ..._recentReviews.map((r) => _ReviewCard(review: r, onReply: () => _replyReview(r['id']))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAccept(String id) {
    setState(() => _pendingBookings.removeWhere((b) => b['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã xác nhận booking'), backgroundColor: AppColors.success));
  }

  void _handleReject(String id) {
    setState(() => _pendingBookings.removeWhere((b) => b['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Đã từ chối booking'), backgroundColor: AppColors.error));
  }

  void _replyReview(String id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OwnerReviewsPage(venueId: 'v1', venueName: _venueName)));
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Revenue Card
// ──────────────────────────────────────────────────────────────────────────
class _RevenueCard extends StatelessWidget {
  final Map<String, dynamic> revenue;
  const _RevenueCard({required this.revenue});

  @override
  Widget build(BuildContext context) {
    final growth = revenue['lastMonth'] == 0
        ? 100.0
        : (revenue['thisMonth'] - revenue['lastMonth']) / revenue['lastMonth'] * 100;
    final isPositive = growth >= 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFF1565C0).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Doanh thu tháng này', style: TextStyle(color: AppColors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: isPositive ? AppColors.success.withOpacity(0.25) : AppColors.error.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded, size: 14, color: isPositive ? AppColors.success : AppColors.error),
                  const SizedBox(width: 4),
                  Text('${growth.toStringAsFixed(1)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPositive ? AppColors.success : AppColors.error)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(children: [
            Text(_fmt(revenue['thisMonth']), style: const TextStyle(color: AppColors.white, fontSize: 30, fontWeight: FontWeight.w900)),
            const Text('doanh thu tháng này', style: TextStyle(color: AppColors.white70, fontSize: 11)),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _RevenueInfo(label: 'Hôm nay', value: _fmt(revenue['today']), icon: Icons.today_rounded)),
            Container(width: 1, height: 32, color: AppColors.white.withOpacity(0.2)),
            Expanded(child: _RevenueInfo(label: 'Thực nhận', value: _fmt(revenue['ownerReceives']), icon: Icons.account_balance_wallet_rounded)),
            Container(width: 1, height: 32, color: AppColors.white.withOpacity(0.2)),
            Expanded(child: _RevenueInfo(label: 'Số booking', value: '${revenue['bookingCount']}', icon: Icons.confirmation_number_rounded)),
          ]),
        ],
      ),
    );
  }

  String _fmt(dynamic val) {
    final v = (val as num).toDouble();
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _RevenueInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _RevenueInfo({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Column(children: [
    Icon(icon, size: 16, color: AppColors.white70),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    Text(label, style: const TextStyle(color: AppColors.white70, fontSize: 10)),
  ]);
}

// ──────────────────────────────────────────────────────────────────────────
// Booking Stats Card
// ──────────────────────────────────────────────────────────────────────────
class _BookingStatsCard extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _BookingStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.today_rounded, size: 18, color: Color(0xFF1565C0)),
            const SizedBox(width: 8),
            Text('Booking hôm nay · Tổng ${stats['total']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _StatChip(label: 'Chờ', count: stats['pending'], color: AppColors.warning),
            const SizedBox(width: 8),
            _StatChip(label: 'Xác nhận', count: stats['confirmed'], color: AppColors.info),
            const SizedBox(width: 8),
            _StatChip(label: 'Check-in', count: stats['checkedIn'], color: const Color(0xFF1565C0)),
            const SizedBox(width: 8),
            _StatChip(label: 'Hoàn thành', count: stats['completed'], color: AppColors.success),
            const SizedBox(width: 8),
            _StatChip(label: 'Huỷ', count: stats['cancelled'], color: AppColors.error),
          ]),
          const SizedBox(height: 10),
          // ── Progress bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                _ProgressBar(flex: stats['pending'], color: AppColors.warning),
                _ProgressBar(flex: stats['confirmed'], color: AppColors.info),
                _ProgressBar(flex: stats['checkedIn'], color: const Color(0xFF1565C0)),
                _ProgressBar(flex: stats['completed'], color: AppColors.success),
                _ProgressBar(flex: stats['cancelled'], color: AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text('$count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _ProgressBar extends StatelessWidget {
  final int flex;
  final Color color;
  const _ProgressBar({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) => Flexible(
    flex: flex == 0 ? 0 : flex,
    child: flex == 0 ? const SizedBox.shrink() : Container(height: 6, color: color),
  );
}

// ──────────────────────────────────────────────────────────────────────────
// Mini 7-day chart (sparkline simulation)
// ──────────────────────────────────────────────────────────────────────────
class _MiniChart extends StatelessWidget {
  final List<double> _data = const [1.2, 1.8, 0.9, 2.3, 1.5, 2.8, 2.7];
  final List<String> _days = const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final maxVal = _data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.show_chart_rounded, size: 18, color: Color(0xFF1565C0)),
            SizedBox(width: 8),
            Text('Doanh thu 7 ngày qua (triệu đ)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 14),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_data.length, (i) {
                final h = (_data[i] / maxVal) * 70;
                final isMax = _data[i] == maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isMax) Text('${_data[i]}M', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300 + i * 80),
                          height: h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withOpacity(isMax ? 1 : 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_days[i], style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Section Header
// ──────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? action;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, required this.icon, required this.color, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      const Spacer(),
      if (action != null) GestureDetector(
        onTap: onAction,
        child: Text(action!, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}

// ──────────────────────────────────────────────────────────────────────────
// Pending Booking Card — Accept/Reject inline
// ──────────────────────────────────────────────────────────────────────────
class _PendingBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  const _PendingBookingCard({required this.booking, required this.onAccept, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18, backgroundColor: AppColors.warning.withOpacity(0.15),
                child: Text(booking['customer'][0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning, fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking['customer'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(booking['phone'] ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              )),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(booking['code'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textHint, letterSpacing: 0.5)),
                Text(booking['ago'], style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF4F6FA), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.sports_soccer_rounded, size: 14, color: Color(0xFF1565C0)),
                    const SizedBox(width: 4),
                    Text(booking['court'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.event_rounded, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text('${booking['date']} · ${booking['time']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ]),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(_fmtAmount(booking['amount']), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primaryLightBrand)),
                  _PayMethodChip(method: booking['method']),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () { HapticFeedback.mediumImpact(); onReject(); },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error), elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Từ chối', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () { HapticFeedback.mediumImpact(); onAccept(); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success, elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Xác nhận', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  String _fmtAmount(double v) {
    final n = v.toInt();
    String s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}đ';
  }
}

class _PayMethodChip extends StatelessWidget {
  final String method;
  const _PayMethodChip({required this.method});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (method) {
      'WALLET' => ('Ví', AppColors.info),
      'MOMO' => ('MoMo', const Color(0xFFAD1457)),
      'VNPAY' => ('VNPay', AppColors.error),
      'ZALOPAY' => ('ZaloPay', AppColors.info),
      'CASH' => ('Tiền mặt', AppColors.success),
      _ => ('Bank', AppColors.textHint),
    };
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Review Card
// ──────────────────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final VoidCallback onReply;
  const _ReviewCard({required this.review, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 16, backgroundColor: AppColors.warning.withOpacity(0.15),
              child: Text('${review['reviewer'][0]}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(review['reviewer'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Row(children: [
                ...List.generate(5, (i) => Icon(i < review['rating'] ? Icons.star_rounded : Icons.star_border_rounded, size: 13, color: AppColors.warning)),
                const SizedBox(width: 4),
                Text(review['ago'], style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
              ]),
            ])),
            if (!review['replied'])
              GestureDetector(
                onTap: onReply,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFF1565C0).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text('Phản hồi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Text('Đã phản hồi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
              ),
          ]),
          if (review['comment'] != null && (review['comment'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review['comment'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
