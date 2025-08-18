import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:dat_san_247_mobile/features/order/presentation/pages/order_page.dart';
import 'package:dat_san_247_mobile/features/product/presentation/pages/product_page.dart';

import '../../account/screens/account_screen.dart';
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
    const ProductPage(key: ValueKey('product')),
    const OrderPage(key: ValueKey('order')),
    const NotificationPage(key: ValueKey('notification')),
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

  int _previousIndex = 0;

  Widget itemBottom(IconData iconData, String title, int index) {
    final selected = index == _currentIndex;
    return InkWell(
      onTap: () {
        onTabTapped(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: selected ? Colors.orange : Colors.grey),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: selected ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // tắt swipe nếu chỉ muốn nhấn tab
          children: _screens,
        ),

        // Thanh menu dưới custom bo góc
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, -1),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemBottom(Icons.home, "Trang chủ", 0),
                  itemBottom(Icons.production_quantity_limits, "Sản phẩm", 1),
                  itemBottom(Icons.favorite_border, "Đơn hàng", 2),
                  itemBottom(Icons.notifications, "chatbot", 3),
                  itemBottom(Icons.people, "Tài khoản", 4),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

