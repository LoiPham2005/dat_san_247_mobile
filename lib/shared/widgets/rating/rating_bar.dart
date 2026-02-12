import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingBar({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 20,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        if (index < rating) {
          return Icon(Icons.star, color: activeColor, size: size);
        } else {
          return Icon(Icons.star_border, color: inactiveColor, size: size);
        }
      }),
    );
  }
}
