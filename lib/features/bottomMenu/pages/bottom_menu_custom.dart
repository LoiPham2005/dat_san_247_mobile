import 'package:dat_san_247_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dat_san_247_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:dat_san_247_mobile/features/map/presentation/pages/map_page.dart';
import 'package:dat_san_247_mobile/features/my_booking/presentation/pages/my_booking_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../profile/presentation/pages/account_page.dart';

class BottomMenuCustom extends StatefulWidget {
  const BottomMenuCustom({super.key});

  @override
  State<BottomMenuCustom> createState() => _BottomMenuCustomState();
}

class _BottomMenuCustomState extends State<BottomMenuCustom> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    // HomePage(key: ValueKey('home')),
    HomePage(key: ValueKey('home')),
    MapPage(key: ValueKey('map')),
    MyBookingPage(key: ValueKey('booking')),
    ProfilePage(key: ValueKey('profile')),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        backgroundColor: Colors.transparent, // để PageView hiển thị dưới
        color: Color(0xff62b766),
        buttonBackgroundColor: Color(0xff62b766),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.map, size: 30, color: Colors.white),
          Icon(Icons.my_library_books, size: 30, color: Colors.white),
          Icon(Icons.people, size: 30, color: Colors.white),
          // Icon(Icons.people, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          onTabTapped(index);
        },
      ),
    );
  }
}
