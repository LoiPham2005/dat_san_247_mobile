import 'package:flutter/material.dart';

/// Dashed divider line widget
class Dash extends StatelessWidget {
  const Dash({
    super.key,
    this.height = 1,
    this.color,
    this.dashWidth = 5.0,
    this.gapWidth = 5.0,
  });

  final double height;
  final Color? color;
  final double dashWidth;
  final double gapWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).dividerColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + gapWidth)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: effectiveColor),
              ),
            );
          }),
        );
      },
    );
  }
}
