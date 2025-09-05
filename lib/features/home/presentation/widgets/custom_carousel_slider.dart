import 'dart:math';

import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';
import 'package:dat_san_247_mobile/features/home/presentation/controller/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

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
        print("Banner list is empty");
        return Center(child: CircularProgressIndicator());
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            items: _bannerController.bannerList.map((banner) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImage(
                    imageUrl: banner.mediaUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 340 / 207,
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerController.bannerList.length, (
              index,
            ) {
              bool isSelected = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 18 : 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isSelected ? Colors.amber : Colors.grey,
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
