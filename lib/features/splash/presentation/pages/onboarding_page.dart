import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/routes/config/route_names.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Tìm Kiếm Dễ Dàng',
      'description': 'Tìm và đặt sân thể thao gần bạn chỉ với vài cú chạm.',
      'icon': 'search',
    },
    {
      'title': 'Đặt Lịch Tức Thì',
      'description': 'Biết trước lịch trống, chốt sân nhanh chóng không cần gọi điện.',
      'icon': 'event_available',
    },
    {
      'title': 'Thanh Toán Tiện Lợi',
      'description': 'Hỗ trợ đa dạng phương thức thanh toán an toàn, minh bạch.',
      'icon': 'payment',
    },
  ];

  void _onSlideChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'search':
        return Icons.search_rounded;
      case 'event_available':
        return Icons.event_available_rounded;
      case 'payment':
        return Icons.payments_rounded;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go(RouteNames.login),
                child: const Text('Bỏ qua', style: TextStyle(color: AppColors.textHint, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: _onSlideChanged,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightBrand.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(_slides[index]['icon']!),
                            size: 100,
                            color: AppColors.primaryLightBrand,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _slides[index]['title']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _slides[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primaryLightBrand : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage == _slides.length - 1)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go(RouteNames.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLightBrand,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text('Bắt Đầu Ngay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLightBrand,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text('Tiếp Theo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
