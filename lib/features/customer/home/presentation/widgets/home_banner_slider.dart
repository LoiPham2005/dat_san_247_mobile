import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/design/theme/styles/app_colors.dart';
import 'package:dat_san_247_mobile/features/customer/home/data/models/banner_model.dart';
import 'dart:async';

class HomeBannerSlider extends StatefulWidget {
  final List<BannerModel> banners;

  const HomeBannerSlider({super.key, required this.banners});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty && widget.banners.first.autoSlide) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(milliseconds: widget.banners.first.slideDuration), (timer) {
      if (_pageController.hasClients) {
        int nextIndex = _currentIndex + 1;
        if (nextIndex >= widget.banners.length) {
          nextIndex = 0;
          _pageController.jumpToPage(nextIndex);
        } else {
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.mutedLight,
                  image: banner.mobileImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(banner.mobileImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: banner.mobileImageUrl == null
                    ? Center(
                        child: Text(
                          banner.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? AppColors.primaryLightBrand : AppColors.borderLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        )
      ],
    );
  }
}
