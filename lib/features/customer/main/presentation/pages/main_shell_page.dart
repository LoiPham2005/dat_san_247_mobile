import 'package:dat_san_247_mobile/features/customer/deals/presentation/pages/deals_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dat_san_247_mobile/features/customer/home/presentation/pages/home_page.dart';
import 'package:dat_san_247_mobile/features/customer/venue_search/presentation/pages/venue_list_page.dart';
import '../widgets/main_bottom_nav.dart';
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

  final List<MainNavItem> _navItems = [
    const MainNavItem(
      label: 'Trang chủ',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    const MainNavItem(
      label: 'Khám phá',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
    ),
    const MainNavItem(
      label: '', // ← center FAB-style (empty label)
      icon: Icons.sports_soccer_rounded,
      activeIcon: Icons.sports_soccer_rounded,
      isCenter: true,
    ),
    const MainNavItem(
      label: 'Ưu đãi',
      icon: Icons.local_offer_outlined,
      activeIcon: Icons.local_offer_rounded,
    ),
    const MainNavItem(
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
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      extendBody: false, // Tắt để không bị đè nội dung phía dưới
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        items: _navItems,
        onTabTap: _onTabTap,
      ),
    );
  }
}
