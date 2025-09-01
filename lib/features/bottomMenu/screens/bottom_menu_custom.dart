import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dat_san_247_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:dat_san_247_mobile/features/order/presentation/pages/order_page.dart';
import 'package:dat_san_247_mobile/features/venue/presentation/pages/venue_page.dart';
import '../../profile/presentation/pages/account_page.dart';
import '../../home/presentation/pages/home_page.dart';

class BottomMenuCustom extends StatefulWidget {
  const BottomMenuCustom({super.key});

  @override
  State<BottomMenuCustom> createState() => _BottomMenuCustomState();
}

class _BottomMenuCustomState extends State<BottomMenuCustom> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    HomePage(key: ValueKey('home')),
    VenuePage(key: ValueKey('venue')),
    OrderPage(key: ValueKey('order')),
    NotificationPage(key: ValueKey('notification')),
    AccountScreen(key: ValueKey('account')),
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
        color: Colors.blue,
        buttonBackgroundColor: Colors.orange,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.production_quantity_limits, size: 30, color: Colors.white),
          Icon(Icons.favorite_border, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.people, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          onTabTapped(index);
        },
      ),
    );
  }
}
