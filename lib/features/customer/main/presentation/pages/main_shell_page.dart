import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/deals/presentation/pages/deals_page.dart';
import 'package:dat_san_247_mobile/features/customer/home/presentation/pages/home_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tab_pages.dart';

// ──────────────────────────────────────────────────────────────────────────
// MainShellPage — Bottom Navigation Shell cho Customer
// 5 tabs: Trang chủ | Khám phá | Đặt sân | Ưu đãi | Tài khoản
// ──────────────────────────────────────────────────────────────────────────

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // Mỗi tab giữ PageStorageBucket riêng để giữ scroll position
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<_NavItem> _navItems = [
    const _NavItem(
      label: 'Trang chủ',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    const _NavItem(
      label: 'Khám phá',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
    ),
    const _NavItem(
      label: '', // ← center FAB-style (empty label)
      icon: Icons.sports_soccer_rounded,
      activeIcon: Icons.sports_soccer_rounded,
      isCenter: true,
    ),
    const _NavItem(
      label: 'Ưu đãi',
      icon: Icons.local_offer_outlined,
      activeIcon: Icons.local_offer_rounded,
    ),
    const _NavItem(
      label: 'Tài khoản',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  late final List<Widget> _pages = [
    const HomePage(),
    const VenueListPage(),
    const MyBookingsPage(), // index 2 = đặt sân (center button)
    const DealsPage(),
    const ProfilePage(),
  ];

  void _onTabTap(int index) {
    HapticFeedback.selectionClick();
    if (index == _currentIndex && index == 0) {
      // Scroll to top nếu tap home đang active (future improvement)
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Chiều cao ước tính của bottom nav: 80 (height) + safe area bottom
    final double bottomPadding =
        80 + MediaQuery.of(context).padding.bottom + 16;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: PageStorage(
          bucket: _bucket,
          child: _pages[_currentIndex],
        ),
      ),
      extendBody: true, // Vẫn giữ true để đảm bảo UI mướt
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 80,
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              if (item.isCenter) {
                return _buildCenterButton(index);
              }
              return _buildNavItem(index, item);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem item) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  key: ValueKey(isActive),
                  size: 24,
                  color: isActive
                      ? AppColors.primaryLightBrand
                      : AppColors.textHint,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primaryLightBrand
                      : AppColors.textHint,
                ),
                child: Text(item.label),
              ),
              // Active indicator dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 4 : 0,
                height: 4,
                margin: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLightBrand,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(int index) {
    final isActive = _currentIndex == index;
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
                  colors: isActive
                      ? [const Color(0xFF0F7A35), const Color(0xFF22C55E)]
                      : [AppColors.primaryLightBrand, const Color(0xFF22C55E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLightBrand
                        .withOpacity(isActive ? 0.5 : 0.3),
                    blurRadius: isActive ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                turns: isActive ? 0.08 : 0,
                child: const Icon(
                  Icons.sports_soccer_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Đặt sân',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color:
                    isActive ? AppColors.primaryLightBrand : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ─────────────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isCenter;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isCenter = false,
  });
}
