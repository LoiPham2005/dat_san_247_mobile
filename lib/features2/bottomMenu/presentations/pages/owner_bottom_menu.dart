import 'package:dat_san_247_mobile/features2/bottomMenu/presentations/pages/owner_booking_screen.dart';
import 'package:dat_san_247_mobile/features2/bottomMenu/presentations/pages/owner_field_screen.dart';
import 'package:dat_san_247_mobile/features2/bottomMenu/presentations/pages/owner_home_screen.dart';
import 'package:dat_san_247_mobile/features2/bottomMenu/presentations/pages/owner_profile_screen.dart';
import 'package:dat_san_247_mobile/features2/bottomMenu/presentations/pages/owner_statistics_screen.dart';
import 'package:flutter/material.dart';

class OwnerBottomMenu extends StatefulWidget {
  const OwnerBottomMenu({Key? key}) : super(key: key);

  @override
  State<OwnerBottomMenu> createState() => _OwnerBottomMenuPageState();
}

class _OwnerBottomMenuPageState extends State<OwnerBottomMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OwnerHomeScreen(),
    const OwnerBookingScreen(),
    const OwnerFieldScreen(),
    const OwnerStatisticsScreen(),
    const OwnerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Đặt sân',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer),
              label: 'Sân của tôi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Thống kê',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}