import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentBannerIndex = 0;
  // Mock data
  final List<BannerItem> banners = [
    BannerItem(
      title: "Giảm 30% Cuối Tuần",
      subtitle: "Đặt sân bóng đá - Ưu đãi hấp dẫn",
      imageUrl:
          "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800",
      badge: "HOT",
      badgeColor: Colors.red,
    ),
    BannerItem(
      title: "Sân Cầu Lông Mới",
      subtitle: "Khai trương với nhiều khuyến mãi",
      imageUrl:
          "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800",
      badge: "MỚI",
      badgeColor: Colors.green,
    ),
    BannerItem(
      title: "Giải Đấu Mùa Hè",
      subtitle: "Đăng ký tham gia ngay hôm nay",
      imageUrl:
          "https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=800",
      badge: "EVENT",
      badgeColor: Colors.orange,
    ),
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
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
              ),
              items: banners.map((banner) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade600,
                            ],
                          ),
                        ),
                      ),
                    ),
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
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: banner.badgeColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              banner.badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner.subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
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
