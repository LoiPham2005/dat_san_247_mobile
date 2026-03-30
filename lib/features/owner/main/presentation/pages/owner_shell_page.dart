import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/owner/booking/presentation/pages/owner_calendar_page.dart';
import 'package:dat_san_247_mobile/features/owner/dashboard/presentation/pages/owner_dashboard_page.dart';
import 'package:dat_san_247_mobile/features/owner/finance/presentation/pages/owner_revenue_page.dart';
import 'package:dat_san_247_mobile/features/owner/settings/presentation/pages/owner_settings_page.dart';
import 'package:dat_san_247_mobile/features/owner/venue/presentation/pages/owner_venue_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    _NavItem(
        label: 'Dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded),
    _NavItem(
        label: 'Booking',
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today_rounded),
    _NavItem(
        label: 'Sân',
        icon: Icons.sports_soccer_rounded,
        activeIcon: Icons.sports_soccer_rounded,
        isCenter: true),
    _NavItem(
        label: 'Doanh thu', icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded),
    _NavItem(label: 'Cài đặt', icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded),
  ];

  Widget _buildPage(int index) {
    return switch (index) {
      0 => OwnerDashboardPage(onTabChange: _onTabTap),
      1 => const OwnerCalendarPage(venueId: 'v1', venueName: 'Venue Của Bạn'),
      2 => const OwnerVenueListPage(),
      3 => const OwnerRevenuePage(),
      4 => const OwnerSettingsPage(),
      _ => const SizedBox.shrink(),
    };
  }

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: PageStorage(
        bucket: _bucket,
        child: _buildPage(_currentIndex),
      ),
      extendBody: false,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))
        ],
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
              width: active ? 4 : 0,
              height: 4,
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(color: _ownerBrand, shape: BoxShape.circle),
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_ownerBrand.withOpacity(0.8), _ownerBrand],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: _ownerBrand.withOpacity(active ? 0.5 : 0.3),
                      blurRadius: active ? 16 : 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Icon(Icons.stadium_rounded, color: AppColors.white, size: 26),
            ),
            const SizedBox(height: 3),
            Text('Sân',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active ? _ownerBrand : AppColors.textHint)),
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
  const _NavItem(
      {required this.label, required this.icon, required this.activeIcon, this.isCenter = false});
}
