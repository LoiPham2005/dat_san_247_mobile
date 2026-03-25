import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/pages/staff_dashboard_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/dashboard/presentation/pages/staff_notifications_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/schedule/presentation/pages/today_schedule_page.dart';
import 'package:dat_san_247_mobile/features/venue_staff/staff_profile/presentation/pages/staff_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Venue Staff Main Shell
// Bottom nav: Dashboard · Lịch · Thông Báo · Hồ Sơ
// Phân quyền: MANAGER > STAFF > RECEPTIONIST
// venue_staff.is_active = true && platform role = "customer"
// ══════════════════════════════════════════════════════════════════════════════
class VenueStaffShellPage extends StatefulWidget {
  const VenueStaffShellPage({super.key});

  @override
  State<VenueStaffShellPage> createState() => _VenueStaffShellPageState();
}

class _VenueStaffShellPageState extends State<VenueStaffShellPage>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF7C3AED);

  int _currentIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  // ── Role info (mock — later from auth provider) ──
  // final String _staffRole = 'STAFF'; // use auth provider in production

  // ── Pages ──
  late final List<Widget> _pages = [
    const StaffDashboardPage(),
    const TodaySchedulePage(),
    const StaffNotificationsPage(),
    const StaffProfilePage(isManager: false), // VS-12
  ];

  // ── Nav items ──
  static const _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, activeIcon: Icons.dashboard, label: 'Dashboard'),
    _NavItem(
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month_rounded,
        label: 'Lịch'),
    _NavItem(
        icon: Icons.notifications_outlined,
        activeIcon: Icons.notifications_rounded,
        label: 'Thông Báo'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Hồ Sơ'),
  ];

  // Unread badge mocks
  final Map<int, int> _badges = {2: 3}; // index → count

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      extendBody: false,
      body: PageStorage(
        bucket: _bucket,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: _buildBottomNav(bottomPadding),
    );
  }

  Widget _buildBottomNav(double bottomPadding) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isSelected = _currentIndex == i;
              final badge = _badges[i] ?? 0;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex == i) return;
                    HapticFeedback.selectionClick();
                    setState(() => _currentIndex = i);
                    // Clear badge on tab visit
                    if (_badges.containsKey(i)) {
                      setState(() => _badges.remove(i));
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? _brand.withOpacity(0.12) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: 22,
                              color: isSelected ? _brand : AppColors.textHint,
                            ),
                          ),
                          if (badge > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                    color: AppColors.error, shape: BoxShape.circle),
                                child: Center(
                                  child: Text('$badge',
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? _brand : AppColors.textHint,
                        ),
                        child: Text(item.label),
                      ),
                      // Active indicator dot
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(top: 2),
                        width: isSelected ? 16 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: _brand,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
