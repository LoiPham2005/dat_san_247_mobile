import 'package:dat_san_247_mobile/core/widgets/image/custom_image.dart';
import 'package:dat_san_247_mobile/features/home/presentation/controller/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({super.key});

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int _currentIndex = 0;
  final BannerController _bannerController = Get.find<BannerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_bannerController.bannerList.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            items: _bannerController.bannerList.map((banner) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomImage(
                    // imageUrl: banner.mediaUrl ?? '',
                    imageUrl:
                        "https://photo.znews.vn/w660/Uploaded/mdf_eioxrd/2021_07_06/2.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 340 / 207,
              viewportFraction: 0.92,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerController.bannerList.length, (
              index,
            ) {
              bool isSelected = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSelected ? 22 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isSelected ? Color(0xff62b766) : Colors.grey[300],
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(0xff62b766).withOpacity(0.18),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
