// import 'package:dat_san_247_mobile/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class WelcomPage extends StatefulWidget {
//   const WelcomPage({super.key});

//   @override
//   State<WelcomPage> createState() => _WelcomPageState();
// }

// class _WelcomPageState extends State<WelcomPage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   final List<OnboardingData> _onboardingData = [
//     OnboardingData(
//       title: 'Tìm Sân Dễ Dàng',
//       description: 'Khám phá hàng trăm sân bóng, cầu lông, tennis gần bạn chỉ với vài chạm.',
//       icon: Icons.search,
//     ),
//     OnboardingData(
//       title: 'Đặt Sân Nhanh Chóng',
//       description: 'Lịch trình linh hoạt, thanh toán an toàn và xác nhận ngay lập tức.',
//       icon: Icons.event_available,
//     ),
//     OnboardingData(
//       title: 'Giao Lưu Kết Nối',
//       description: 'Tìm đồng đội, tham gia hội nhóm và cùng nhau rèn luyện sức khỏe.',
//       icon: Icons.group,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: TextButton(
//                 onPressed: () => context.go('/login'),
//                 child: const Text('Bỏ qua', style: TextStyle(color: AppColors.grey)),
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: _onboardingData.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(40.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: 200,
//                           width: 200,
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             _onboardingData[index].icon,
//                             size: 100,
//                             color: AppColors.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                         Text(
//                           _onboardingData[index].title,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           _onboardingData[index].description,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: AppColors.textSecondary,
//                             height: 1.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: List.generate(
//                       _onboardingData.length,
//                       (index) => Container(
//                         margin: const EdgeInsets.only(right: 8),
//                         height: 8,
//                         width: _currentPage == index ? 24 : 8,
//                         decoration: BoxDecoration(
//                           color: _currentPage == index ? AppColors.primary : AppColors.greyLight,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       if (_currentPage == _onboardingData.length - 1) {
//                         context.go('/login');
//                       } else {
//                         _pageController.nextPage(
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.easeInOut,
//                         );
//                       }
//                     },
//                     child: Container(
//                       height: 60,
//                       width: 60,
//                       decoration: const BoxDecoration(
//                         color: AppColors.primary,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         _currentPage == _onboardingData.length - 1
//                             ? Icons.check
//                             : Icons.arrow_forward_ios,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OnboardingData {
//   final String title;
//   final String description;
//   final IconData icon;

//   OnboardingData({required this.title, required this.description, required this.icon});
// }
