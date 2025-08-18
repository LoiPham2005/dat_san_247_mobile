// import 'package:flutter/material.dart';
// import 'package:snakeup_app/features/account/screens/account_screen.dart';
// import 'package:snakeup_app/features/home/screens/home_screen.dart';
// import 'package:snakeup_app/features/notificaton/screens/notificaton_screen.dart';
// import 'package:snakeup_app/features/order/screens/order_screen.dart';
// import 'package:snakeup_app/features/product/screens/product_screen.dart';
// import 'package:snakeup_app/features/size/screens/size_screen.dart';

// import '../../brands/screens/brands_screen.dart';

// class BotttomMenu extends StatefulWidget {
//   const BotttomMenu({super.key});

//   @override
//   State<BotttomMenu> createState() => _BotttomMenuState();
// }

// class _BotttomMenuState extends State<BotttomMenu> {
//   int _currentIndex = 0;
//   final List<Widget> _screen = [
//     // HomeScreen(),
//     // ProductScreen(),
//     // OrderScreen(),
//     // NotificatonScreen(),
//     // AccountScreen()
//     HomeScreen(key: ValueKey('home')),
//     ProductScreen(key: ValueKey('product')),
//     SizeScreen(key: ValueKey('order')),
//     // NotificatonScreen(key: ValueKey('notification')),
//     BrandsScreen(key: ValueKey('brand')),
//     AccountScreen(key: ValueKey('account')),
//   ];

//   final List<BottomNavigationBarItem> _items = [
//     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//     BottomNavigationBarItem(
//         icon: Icon(Icons.production_quantity_limits), label: "Product"),
//     BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Order"),
//     BottomNavigationBarItem(
//         icon: Icon(Icons.notifications), label: "Notification"),
//     BottomNavigationBarItem(icon: Icon(Icons.people), label: "Account"),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screen,
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white, // màu nền rõ ràng
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: BottomNavigationBar(
//           items: _items,
//           currentIndex: _currentIndex,
//           selectedItemColor: Colors.orange,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.transparent, // không đè màu

//           elevation: 0, // không đổ bóng nếu muốn
//           onTap: (value) {
//             setState(() {
//               _currentIndex = value;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
