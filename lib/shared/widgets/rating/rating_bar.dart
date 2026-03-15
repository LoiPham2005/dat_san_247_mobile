import 'package:flutter/material.dart';

/// Display-only rating bar (read mode)
class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 20,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  final double rating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final full = index + 1;
        if (rating >= full) {
          return Icon(Icons.star, color: activeColor, size: size);
        } else if (rating >= index + 0.5) {
          return Icon(Icons.star_half, color: activeColor, size: size);
        } else {
          return Icon(Icons.star_border, color: inactiveColor, size: size);
        }
      }),
    );
  }
}

/// Interactive rating bar (input mode)
class RatingInput extends StatefulWidget {
  const RatingInput({
    super.key,
    this.initialRating = 0,
    this.maxRating = 5,
    this.size = 32,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.onChanged,
  });

  final double initialRating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final void Function(double rating)? onChanged;

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        final starValue = (index + 1).toDouble();
        return GestureDetector(
          onTap: () {
            setState(() => _rating = starValue);
            widget.onChanged?.call(_rating);
          },
          child: Icon(
            _rating >= starValue ? Icons.star : Icons.star_border,
            color: _rating >= starValue
                ? widget.activeColor
                : widget.inactiveColor,
            size: widget.size,
          ),
        );
      }),
    );
  }
}
