import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerCarousel extends StatefulWidget {
  // final List<Banner> banners; // Đổi tên và kiểu dữ liệu
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentBannerIndex = 0;


  List<String> banners = [
    'https://www.shutterstock.com/image-vector/soccer-template-design-football-banner-260nw-2185778153.jpg',
    'https://www.shutterstock.com/image-vector/soccer-template-design-football-banner-260nw-2185778153.jpg',
    'https://www.shutterstock.com/image-vector/soccer-template-design-football-banner-260nw-2185778153.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 180,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) {
                  setState(() => _currentBannerIndex = index);
                },
              ),
              items: banners.map((banner) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Banner Image
                    Image.network(
                      banner ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.sports_soccer,
                            size: 48,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            // banner.title ??
                                'Khuyến mãi đặc biệt',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Active Status Badge
                          // if (banner.isActive ?? false)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Đang diễn ra',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Page Indicator
          AnimatedSmoothIndicator(
            activeIndex: _currentBannerIndex,
            count: banners.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 12,
              dotColor: Colors.grey[300]!,
              activeDotColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Model classes
class BannerItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badge;
  final Color badgeColor;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badge,
    required this.badgeColor,
  });
}
