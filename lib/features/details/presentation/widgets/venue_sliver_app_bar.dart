import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dat_san_247_mobile/features/my_booking/data/models/venue.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VenueSliverAppBar extends StatelessWidget {
  final Venue venue;
  final List<String> venueImages;
  final int currentImage;
  final bool isFavorite;
  final CarouselSliderController carouselController;
  final Function(int) onImageChanged;
  final VoidCallback onFavoriteToggle;
  final ColorScheme colorScheme;
  final Size size;

  const VenueSliverAppBar({
    super.key,
    required this.venue,
    required this.venueImages,
    required this.currentImage,
    required this.isFavorite,
    required this.carouselController,
    required this.onImageChanged,
    required this.onFavoriteToggle,
    required this.colorScheme,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: size.height * 0.4,
      floating: false,
      pinned: true,
      backgroundColor: colorScheme.primary,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : colorScheme.primary,
            ),
            onPressed: onFavoriteToggle,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.blue),
            onPressed: () {
              _showShareSheet(context, venue);
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Carousel with images
            CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                enableInfiniteScroll: venueImages.length > 1,
                autoPlay: venueImages.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, _) => onImageChanged(index),
              ),
              items: venueImages.map((img) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Image.network(
                    img,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            // Image indicators
            if (venueImages.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Số thứ tự ảnh
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Text(
                        '${currentImage + 1}/${venueImages.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Dots indicator
                    AnimatedSmoothIndicator(
                      activeIndex: currentImage,
                      count: venueImages.length,
                      effect: const WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 10,
                        dotColor: Colors.white24,
                        activeDotColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _showShareSheet(BuildContext context, Venue venue) {
  final link = 'https://dat-san-247.com/venue/${venue.venueId}';
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chia sẻ sân',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.link, color: Colors.green),
            title: const Text('Sao chép liên kết'),
            onTap: () {
              Clipboard.setData(ClipboardData(text: link));
              Navigator.pop(context);
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Đã sao chép liên kết!')),
              // );
              Get.snackbar(
                'Sao chép liên kết',
                'Đã sao chép liên kết!',
                // snackPosition: SnackPosition.BOTTOM,
                // backgroundColor: Colors.black87,
                // colorText: Colors.white,
                margin: const EdgeInsets.all(20),
                duration: const Duration(seconds: 2),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.blue),
            title: const Text('Chia sẻ qua ứng dụng bất kỳ'),
            onTap: () {
              Share.share(link);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
