import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

/// Generic reusable carousel widget
/// - items: danh sách các widget hiển thị trong carousel
/// - autoPlay: có tự động chạy hay không
/// - aspectRatio: tỉ lệ chiều ngang / chiều cao
/// - viewportFraction: độ rộng item so với slider
class CustomCarousel extends StatefulWidget {
  final List<Widget> items;
  final bool autoPlay;
  final double aspectRatio;
  final double viewportFraction;

  const CustomCarousel({
    Key? key,
    required this.items,
    this.autoPlay = true,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.9,
  }) : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
            autoPlay: widget.autoPlay,
            aspectRatio: widget.aspectRatio,
            viewportFraction: widget.viewportFraction,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
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
  }
}
